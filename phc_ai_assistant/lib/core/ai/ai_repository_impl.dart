// ============================================================
// PHC AI Assistant - AI Repository Implementation
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phc_ai_assistant/core/constants/app_constants.dart';
import 'package:phc_ai_assistant/core/constants/model_constants.dart';
import 'package:phc_ai_assistant/core/errors/failures.dart';
import 'package:phc_ai_assistant/core/models/ai_response.dart';
import 'ai_repository.dart';
import 'gemma_inference_datasource.dart';

class AiRepositoryImpl implements AiRepository {
  final GemmaInferenceDataSource _inferenceSource;
  final SharedPreferences _prefs;
  final Logger _logger = Logger();

  final List<Map<String, String>> _contextHistory = [];

  AiRepositoryImpl({
    required GemmaInferenceDataSource inferenceSource,
    required SharedPreferences prefs,
  })  : _inferenceSource = inferenceSource,
        _prefs = prefs;

  @override
  bool get isModelLoaded => _inferenceSource.isLoaded;

  @override
  Future<Either<Failure, void>> loadModel() async {
    try {
      final modelPath = _prefs.getString(AppConstants.keyModelPath);
      if (modelPath == null) {
        return const Left(ModelNotFoundFailure());
      }
      await _inferenceSource.loadModel(modelPath);
      _logger.i('[AiRepository] Model loaded');
      return const Right(null);
    } catch (e) {
      _logger.e('[AiRepository] Load failed: $e');
      return Left(ModelLoadFailure(message: 'Failed to load model: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> unloadModel() async {
    try {
      _inferenceSource.unloadModel();
      return const Right(null);
    } catch (e) {
      return Left(ModelLoadFailure(message: 'Failed to unload model: $e'));
    }
  }

  @override
  Future<Either<Failure, AiResponse>> generateResponse({
    required String userMessage,
    required String languageCode,
    required List<Map<String, String>> conversationHistory,
  }) async {
    if (!_inferenceSource.isLoaded) {
      final loadResult = await loadModel();
      if (loadResult.isLeft()) {
        return loadResult.fold(
          (failure) => Left(failure),
          (_) => const Left(ModelLoadFailure(message: 'Model not available')),
        );
      }
    }

    try {
      // Build context from PRIOR turns only. The caller passes the conversation
      // with the current user message already appended as the last entry, so we
      // drop it here — otherwise the current question was concatenated twice
      // ("Patient: X\nPatient: X"), which confused the 1B model and produced
      // repetitive / garbled ("dummy") answers.
      final priorHistory = conversationHistory.isNotEmpty
          ? conversationHistory.sublist(0, conversationHistory.length - 1)
          : conversationHistory;
      final contextStr = _buildContextString(priorHistory);
      final fullUserMessage = contextStr.isEmpty
          ? userMessage
          : '$contextStr\nPatient: $userMessage';

      final systemPrompt = ModelConstants.healthcareSystemPrompt(languageCode);

      _logger.i('[AiRepository] generateResponse lang=$languageCode '
          'historyTurns=${conversationHistory.length}');
      _logger.d('[AiRepository] fullUserMessage sent to model:\n$fullUserMessage');

      final stopwatch = Stopwatch()..start();
      final responseText = await _inferenceSource.generateResponse(
        systemPrompt: systemPrompt,
        userMessage: fullUserMessage,
        maxTokens: AppConstants.maxResponseTokens,
        temperature: ModelConstants.temperature,
        topP: ModelConstants.topP,
      );
      stopwatch.stop();

      _logger.i('[AiRepository] Response in ${stopwatch.elapsed.inMilliseconds}ms, '
          '${responseText.length} chars');
      _logger.d('[AiRepository] model reply (raw): "$responseText"');

      final cleaned = _cleanResponse(responseText);
      if (cleaned.isEmpty) {
        _logger.w('[AiRepository] Model returned EMPTY text (after cleanup) — the '
            'UI will show a blank reply. See "phc_llama" native logs for the cause.');
      } else if (cleaned != responseText.trim()) {
        _logger.d('[AiRepository] model reply (cleaned): "$cleaned"');
      }

      return Right(AiResponse(
        text: cleaned,
        languageCode: languageCode,
        inferenceTime: stopwatch.elapsed,
        detectedKeywords: _extractHealthKeywords(cleaned),
      ));
    } catch (e) {
      _logger.e('[AiRepository] Inference error: $e');
      return Left(InferenceFailure(message: 'Inference failed: $e'));
    }
  }

  @override
  Stream<Either<Failure, String>> generateResponseStream({
    required String userMessage,
    required String languageCode,
    required List<Map<String, String>> conversationHistory,
  }) async* {
    if (!_inferenceSource.isLoaded) {
      final loadResult = await loadModel();
      if (loadResult.isLeft()) {
        yield const Left(ModelLoadFailure(message: 'Model not available'));
        return;
      }
    }

    // Same prompt assembly as the non-streaming path: context from PRIOR turns
    // only (the current message is the last history entry — don't duplicate it).
    final priorHistory = conversationHistory.isNotEmpty
        ? conversationHistory.sublist(0, conversationHistory.length - 1)
        : conversationHistory;
    final contextStr = _buildContextString(priorHistory);
    final fullUserMessage =
        contextStr.isEmpty ? userMessage : '$contextStr\nPatient: $userMessage';
    final systemPrompt = ModelConstants.healthcareSystemPrompt(languageCode);

    _logger.i('[AiRepository] stream generate lang=$languageCode');
    final raw = StringBuffer();
    final sw = Stopwatch()..start();
    try {
      await for (final delta in _inferenceSource.generateResponseStream(
        systemPrompt: systemPrompt,
        userMessage: fullUserMessage,
        maxTokens: AppConstants.maxResponseTokens,
        temperature: ModelConstants.temperature,
        topP: ModelConstants.topP,
      )) {
        raw.write(delta);
        // Clean each cumulative snapshot so leaked ChatDoctor boilerplate never
        // appears on screen, even mid-stream.
        yield Right(_cleanResponse(raw.toString()));
      }
      sw.stop();
      _logger.i('[AiRepository] stream complete in ${sw.elapsedMilliseconds}ms, '
          '${raw.length} raw chars');
    } catch (e) {
      _logger.e('[AiRepository] stream error: $e');
      yield Left(InferenceFailure(message: 'Inference failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearContext() async {
    _contextHistory.clear();
    return const Right(null);
  }

  @override
  void cancelGeneration() => _inferenceSource.cancelGeneration();

  // ── Helpers ───────────────────────────────────────────────

  /// Strip training-data boilerplate the fine-tuned GGUF leaked from the
  /// ChatDoctor / "Ask A Doctor" dataset it was trained on. The model keeps
  /// introducing itself as "ChatDoctor" and pasting the dataset's canned intro
  /// ("welcome to 'Ask A Doctor' service", "I am ChatDoctor answering your
  /// query...") instead of behaving as Aarogya — those are the "dummy quotes".
  /// This is a band-aid; the real fix is retraining on clean, persona-consistent
  /// data. We remove the known boilerplate phrases/sentences and tidy whitespace.
  String _cleanResponse(String raw) {
    var text = raw.trim();
    if (text.isEmpty) return text;

    // Strip Gemma chat-template control markers that sometimes leak into the
    // text as literal words (e.g. "<start_of_turn>", "<end_of_turn>", a stray
    // "<eos>", or a leading "model"/"user" role word). These show up as the
    // "<start_of_turn>" gibberish the user reported.
    text = text
        .replaceAll(RegExp(r'<\s*/?\s*(start_of_turn|end_of_turn|eos|bos|pad)\s*>',
            caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]{0,20}>'), '') // any short leftover <...> tag
        .replaceAll(RegExp(r'^\s*(model|user|assistant)\b[:\s]*',
            caseSensitive: false), '')
        .trim();
    if (text.isEmpty) return text;

    // Phrases that only ever appear as leaked dataset boilerplate.
    const boilerplate = [
      "welcome to 'Ask A Doctor' service",
      'welcome to Ask A Doctor service',
      'I am ChatDoctor',
      'ChatDoctor',
      'Ask A Doctor',
      'answering your query in simple words',
      'Thanks for asking on Healthcare Magic',
      'Hope I have answered your query',
      'Get well soon',
    ];
    for (final phrase in boilerplate) {
      text = text.replaceAll(
        RegExp(RegExp.escape(phrase), caseSensitive: false),
        '',
      );
    }

    // Drop any sentence still mentioning the leaked service/persona, then tidy
    // up the punctuation/whitespace the removals left behind.
    final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    final kept = sentences.where((s) {
      final low = s.toLowerCase();
      return !low.contains('doctor service') && !low.contains('chatdoctor');
    });
    text = kept.join(' ');

    text = text
        .replaceAll(RegExp(r'\s{2,}'), ' ')       // collapse double spaces
        .replaceAll(RegExp(r'^[\s,.;:'"'"'-]+'), '') // leading junk punctuation
        .trim();

    return text;
  }

  String _buildContextString(List<Map<String, String>> history) {
    if (history.isEmpty) return '';
    final recent = history.length > AppConstants.maxConversationHistory
        ? history.sublist(history.length - AppConstants.maxConversationHistory)
        : history;
    return recent.map((m) {
      final role = m['role'] == 'user' ? 'Patient' : 'Aarogya';
      return '$role: ${m['content']}';
    }).join('\n');
  }

  List<String> _extractHealthKeywords(String text) {
    const healthKeywords = [
      'fever', 'cough', 'pain', 'diabetes', 'blood pressure', 'pregnancy',
      'vaccination', 'malaria', 'dengue', 'nutrition', 'diet', 'hospital',
      'doctor', 'medicine', 'symptoms', 'maternal', 'child', 'emergency',
    ];
    final lowerText = text.toLowerCase();
    return healthKeywords.where((kw) => lowerText.contains(kw)).toList();
  }
}
