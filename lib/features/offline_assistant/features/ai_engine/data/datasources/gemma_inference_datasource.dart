// ============================================================
// PHC AI Assistant - Gemma Inference Data Source
// FFI bridge to llama.cpp for offline Gemma 3 1B GGUF inference
// ============================================================

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:logger/logger.dart';
import '../../../../core/constants/model_constants.dart';

// ── FFI Type Definitions ──────────────────────────────────

// llama_model_params struct (opaque pointer)
final class LlamaModelParams extends Opaque {}
// llama_context_params struct (opaque pointer)  
final class LlamaContextParams extends Opaque {}
// llama_model struct (opaque pointer)
final class LlamaModel extends Opaque {}
// llama_context struct (opaque pointer)
final class LlamaContext extends Opaque {}
// llama_token is int32
typedef LlamaToken = Int32;

// Function signatures from llama.cpp shared library

// These bind to the phc_* wrappers in llama_bridge.cpp (NOT the raw llama.cpp
// functions), because the raw ones take *_params structs by value which Dart FFI
// cannot pass. The wrappers take simple scalar args instead.
typedef _PhcLoadModelNative = Pointer<LlamaModel> Function(Pointer<Utf8> path);
typedef _PhcLoadModel = Pointer<LlamaModel> Function(Pointer<Utf8> path);

typedef _PhcNewContextNative = Pointer<LlamaContext> Function(
    Pointer<LlamaModel> model, Int32 nCtx, Int32 nThreads, Int32 nBatch);
typedef _PhcNewContext = Pointer<LlamaContext> Function(
    Pointer<LlamaModel> model, int nCtx, int nThreads, int nBatch);

typedef _PhcFreeModelNative = Void Function(Pointer<LlamaModel> model);
typedef _PhcFreeModel = void Function(Pointer<LlamaModel> model);

typedef _PhcFreeContextNative = Void Function(Pointer<LlamaContext> ctx);
typedef _PhcFreeContext = void Function(Pointer<LlamaContext> ctx);

typedef _PhcGenerateResponseNative = Pointer<Utf8> Function(
    Pointer<LlamaContext> ctx,
    Pointer<LlamaModel> model,
    Pointer<Utf8> systemPrompt,
    Pointer<Utf8> userMessage,
    Int32 maxTokens,
    Float temperature,
    Float topP,
    Float repeatPenalty);

typedef _PhcGenerateResponse = Pointer<Utf8> Function(
    Pointer<LlamaContext> ctx,
    Pointer<LlamaModel> model,
    Pointer<Utf8> systemPrompt,
    Pointer<Utf8> userMessage,
    int maxTokens,
    double temperature,
    double topP,
    double repeatPenalty);

typedef _PhcFreeStringNative = Void Function(Pointer<Utf8> str);
typedef _PhcFreeString = void Function(Pointer<Utf8> str);

// ── Streaming API (token-by-token) ────────────────────────
typedef _PhcStreamStartNative = Int32 Function(
    Pointer<LlamaContext> ctx,
    Pointer<LlamaModel> model,
    Pointer<Utf8> systemPrompt,
    Pointer<Utf8> userMessage,
    Float temperature,
    Float topP,
    Float repeatPenalty);
typedef _PhcStreamStart = int Function(
    Pointer<LlamaContext> ctx,
    Pointer<LlamaModel> model,
    Pointer<Utf8> systemPrompt,
    Pointer<Utf8> userMessage,
    double temperature,
    double topP,
    double repeatPenalty);

typedef _PhcStreamNextNative = Pointer<Utf8> Function(
    Pointer<LlamaContext> ctx, Pointer<LlamaModel> model, Int32 maxTokens);
typedef _PhcStreamNext = Pointer<Utf8> Function(
    Pointer<LlamaContext> ctx, Pointer<LlamaModel> model, int maxTokens);

typedef _PhcStreamFinishNative = Void Function();
typedef _PhcStreamFinish = void Function();

typedef _PhcStreamCancelNative = Void Function();
typedef _PhcStreamCancel = void Function();

// ── Gemma Inference Data Source ───────────────────────────

class GemmaInferenceDataSource {
  static const String _libName = 'phc_llama';
  final Logger _logger = Logger();

  DynamicLibrary? _lib;
  Pointer<LlamaModel>? _model;
  Pointer<LlamaContext>? _context;
  bool _isLoaded = false;
  // The llama context is NOT safe for concurrent use. This guards against two
  // inferences running at once (e.g. user sends a 2nd message mid-generation),
  // which would race the context on the worker isolate and crash natively.
  bool _isGenerating = false;

  // Loaded function pointers (bound to the phc_* wrappers)
  late _PhcLoadModel _phcLoadModel;
  late _PhcNewContext _phcNewContext;
  late _PhcFreeModel _phcFreeModel;
  late _PhcFreeContext _phcFreeContext;
  _PhcStreamCancel? _phcStreamCancel;

  bool get isLoaded => _isLoaded;
  bool get isGenerating => _isGenerating;

  /// Load the shared library and initialize llama.cpp
  Future<void> loadLibrary() async {
    if (_lib != null) return;
    try {
      if (Platform.isAndroid) {
        _lib = DynamicLibrary.open('lib$_libName.so');
      } else {
        throw UnsupportedError('Only Android is supported');
      }
      _bindFunctions();
      _logger.i('[GemmaInference] Library loaded successfully');
    } catch (e) {
      _logger.e('[GemmaInference] Failed to load library: $e');
      rethrow;
    }
  }

  void _bindFunctions() {
    final lib = _lib!;
    _phcLoadModel = lib
        .lookup<NativeFunction<_PhcLoadModelNative>>('phc_load_model')
        .asFunction();
    _phcNewContext = lib
        .lookup<NativeFunction<_PhcNewContextNative>>('phc_new_context')
        .asFunction();
    _phcFreeModel = lib
        .lookup<NativeFunction<_PhcFreeModelNative>>('phc_free_model_wrapper')
        .asFunction();
    _phcFreeContext = lib
        .lookup<NativeFunction<_PhcFreeContextNative>>('phc_free_context')
        .asFunction();
    _phcStreamCancel = lib
        .lookup<NativeFunction<_PhcStreamCancelNative>>('phc_stream_cancel')
        .asFunction();
    // phc_generate_response / phc_free_string are looked up inside the worker
    // isolate (see generateResponse), so they are not bound here.
  }

  /// Load GGUF model from file system into memory.
  /// Should be called once and reused.
  Future<void> loadModel(String modelPath) async {
    if (_isLoaded) {
      _logger.i('[GemmaInference] Model already loaded, reusing.');
      return;
    }

    if (_lib == null) await loadLibrary();

    _logger.i('[GemmaInference] Loading model from: $modelPath');

    final pathPtr = modelPath.toNativeUtf8();
    try {
      // phc_load_model builds llama_model_params natively (CPU-only).
      final modelPtr = _phcLoadModel(pathPtr);
      if (modelPtr == nullptr) {
        throw Exception('phc_load_model returned null (bad/corrupt GGUF?)');
      }
      _model = modelPtr;

      // phc_new_context builds llama_context_params natively.
      final ctxPtr = _phcNewContext(
        modelPtr,
        ModelConstants.nCtx,
        ModelConstants.nThreads,
        ModelConstants.nBatch,
      );
      if (ctxPtr == nullptr) {
        _phcFreeModel(modelPtr);
        _model = null;
        throw Exception('phc_new_context returned null');
      }

      _context = ctxPtr;
      _isLoaded = true;
      _logger.i('[GemmaInference] Model loaded successfully');
    } finally {
      calloc.free(pathPtr);
    }
  }

  /// Generate a response from the model.
  /// Returns the generated text string.
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = ModelConstants.maxNewTokens,
    double temperature = ModelConstants.temperature,
    double topP = ModelConstants.topP,
    double repeatPenalty = ModelConstants.repeatPenalty,
  }) async {
    if (!_isLoaded || _context == null || _model == null) {
      throw StateError('Model not loaded. Call loadModel() first.');
    }
    if (_isGenerating) {
      throw StateError('A response is already being generated. Please wait.');
    }
    _isGenerating = true;

    // Run the BLOCKING native inference on a background isolate. Doing it on the
    // main isolate froze the UI thread for the whole generation, which Android
    // flagged as an ANR ("app not responding" -> looked like a crash).
    // The model/context live in shared process memory, so we pass their pointer
    // addresses (ints) and rebuild the pointers inside the isolate. Only one
    // inference runs at a time, so using the context from the worker thread is safe.
    final ctxAddr = _context!.address;
    final modelAddr = _model!.address;
    const libName = _libName;

    _logger.i('[GemmaInference] generate() start — '
        'systemPrompt=${systemPrompt.length} chars, '
        'userMessage=${userMessage.length} chars, maxTokens=$maxTokens');
    _logger.d('[GemmaInference] userMessage: $userMessage');
    final sw = Stopwatch()..start();

    try {
      final out = await Isolate.run(() {
        final lib = DynamicLibrary.open('lib$libName.so');
        final gen = lib.lookupFunction<_PhcGenerateResponseNative, _PhcGenerateResponse>(
            'phc_generate_response');
        final freeStr = lib.lookupFunction<_PhcFreeStringNative, _PhcFreeString>(
            'phc_free_string');

        final systemPtr = systemPrompt.toNativeUtf8();
        final userPtr = userMessage.toNativeUtf8();
        try {
          final resultPtr = gen(
            Pointer<LlamaContext>.fromAddress(ctxAddr),
            Pointer<LlamaModel>.fromAddress(modelAddr),
            systemPtr,
            userPtr,
            maxTokens,
            temperature,
            topP,
            repeatPenalty,
          );
          if (resultPtr == nullptr) return '';
          final result = resultPtr.toDartString();
          freeStr(resultPtr);
          return result;
        } finally {
          calloc.free(systemPtr);
          calloc.free(userPtr);
        }
      });
      sw.stop();
      _logger.i('[GemmaInference] generate() done in ${sw.elapsedMilliseconds}ms '
          '— reply=${out.length} chars');
      if (out.isEmpty) {
        _logger.w('[GemmaInference] reply is EMPTY — check "phc_llama" native '
            'logs for tokenization/decode errors or immediate EOS.');
      } else {
        _logger.d('[GemmaInference] raw reply: $out');
      }
      return out;
    } finally {
      _isGenerating = false; // release the lock no matter what
    }
  }

  /// Streaming variant of [generateResponse]. Yields each token's text ("delta")
  /// as it is produced, so the UI can render words live. Runs the blocking native
  /// loop on a worker isolate and pipes pieces back over a SendPort.
  Stream<String> generateResponseStream({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = ModelConstants.maxNewTokens,
    double temperature = ModelConstants.temperature,
    double topP = ModelConstants.topP,
    double repeatPenalty = ModelConstants.repeatPenalty,
  }) async* {
    if (!_isLoaded || _context == null || _model == null) {
      throw StateError('Model not loaded. Call loadModel() first.');
    }
    if (_isGenerating) {
      throw StateError('A response is already being generated. Please wait.');
    }
    _isGenerating = true;

    final ctxAddr = _context!.address;
    final modelAddr = _model!.address;
    const libName = _libName;

    _logger.i('[GemmaInference] stream start — userMessage=${userMessage.length} chars');
    final sw = Stopwatch()..start();

    final rp = ReceivePort();
    final sp = rp.sendPort;

    // Worker isolate: run the native token loop, sending each piece back. A
    // trailing null on the port signals completion. We ignore its return value.
    final done = Isolate.run<void>(() {
      final lib = DynamicLibrary.open('lib$libName.so');
      final start = lib.lookupFunction<_PhcStreamStartNative, _PhcStreamStart>('phc_stream_start');
      final next = lib.lookupFunction<_PhcStreamNextNative, _PhcStreamNext>('phc_stream_next');
      final finish = lib.lookupFunction<_PhcStreamFinishNative, _PhcStreamFinish>('phc_stream_finish');
      final freeStr = lib.lookupFunction<_PhcFreeStringNative, _PhcFreeString>('phc_free_string');

      final ctx = Pointer<LlamaContext>.fromAddress(ctxAddr);
      final model = Pointer<LlamaModel>.fromAddress(modelAddr);
      final systemPtr = systemPrompt.toNativeUtf8();
      final userPtr = userMessage.toNativeUtf8();
      try {
        final rc = start(ctx, model, systemPtr, userPtr, temperature, topP, repeatPenalty);
        if (rc != 0) return; // error already logged natively; finally sends null
        while (true) {
          final p = next(ctx, model, maxTokens);
          if (p == nullptr) break;
          final piece = p.toDartString();
          freeStr(p);
          sp.send(piece);
        }
        finish();
      } finally {
        calloc.free(systemPtr);
        calloc.free(userPtr);
        sp.send(null); // completion sentinel
      }
    });

    try {
      await for (final msg in rp) {
        if (msg == null) break;
        yield msg as String;
      }
      try {
        await done; // surface any isolate crash
      } catch (e) {
        _logger.e('[GemmaInference] stream isolate error: $e');
      }
      sw.stop();
      _logger.i('[GemmaInference] stream done in ${sw.elapsedMilliseconds}ms');
    } finally {
      rp.close();
      _isGenerating = false;
    }
  }

  /// Abort an in-flight streaming generation (barge-in / stop). Sets the native
  /// cancel flag; the worker loop ends on its next token and the stream closes.
  void cancelGeneration() {
    if (!_isGenerating) return;
    try {
      _phcStreamCancel?.call();
      _logger.i('[GemmaInference] cancel requested');
    } catch (e) {
      _logger.w('[GemmaInference] cancel failed: $e');
    }
  }

  /// Unload the model to free memory.
  /// Call when low on memory or app goes to background.
  void unloadModel() {
    if (!_isLoaded) return;
    // Never free the context/model while an inference is running on the worker
    // isolate -- it would use freed memory and crash. Skip; the OS reclaims on exit.
    if (_isGenerating) {
      _logger.w('[GemmaInference] unloadModel skipped: generation in progress.');
      return;
    }

    if (_context != null) {
      _phcFreeContext(_context!);
      _context = null;
    }
    if (_model != null) {
      _phcFreeModel(_model!);
      _model = null;
    }

    _isLoaded = false;
    _logger.i('[GemmaInference] Model unloaded');
  }

  void dispose() {
    unloadModel();
    _lib = null;
  }
}
