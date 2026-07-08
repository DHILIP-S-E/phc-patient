import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/repositories/live_assistant_repository.dart';
import 'auth_provider.dart';

final liveAssistantRepositoryProvider = Provider<LiveAssistantRepository>(
  (ref) => LiveAssistantRepository(ref.watch(tokenStorageProvider)),
);

// Must match GEMINI_LIVE mic-input / audio-output rates the backend expects
// (services/patient/live_assistant_service.py sends "audio/pcm;rate=16000"
// for mic input; Gemini Live's own audio output is 24kHz).
const _micSampleRate = 16000;
const _playbackSampleRate = 24000;

sealed class LiveAssistantState {
  const LiveAssistantState();
}

class AssistantIdle extends LiveAssistantState {
  const AssistantIdle();
}

/// Mic is open; [transcript] is the last thing either party said, if any yet.
class AssistantListening extends LiveAssistantState {
  final String? transcript;
  const AssistantListening({this.transcript});
}

/// Audio is streaming back from Gemini.
class AssistantSpeaking extends LiveAssistantState {
  final String? transcript;
  const AssistantSpeaking({this.transcript});
}

class AssistantError extends LiveAssistantState {
  final String message;
  const AssistantError(this.message);
}

/// Owns the full-duplex session: mic capture -> WS -> Gemini, and
/// Gemini -> WS -> speaker playback, both streaming concurrently. See
/// phc_api/services/patient/live_assistant_service.py for the server side
/// this talks to.
class LiveAssistantNotifier extends Notifier<LiveAssistantState> {
  WebSocketChannel? _channel;
  StreamSubscription? _channelSubscription;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  StreamController<Uint8List>? _micController;
  StreamSubscription<Uint8List>? _micSubscription;
  bool _recorderOpen = false;
  bool _playerOpen = false;

  @override
  LiveAssistantState build() {
    ref.onDispose(() {
      unawaited(_teardown());
    });
    return const AssistantIdle();
  }

  Future<void> start() async {
    if (state is! AssistantIdle && state is! AssistantError) return;

    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      state = const AssistantError('Microphone permission is required to talk to the assistant.');
      return;
    }

    try {
      if (!_recorderOpen) {
        await _recorder.openRecorder();
        _recorderOpen = true;
      }
      if (!_playerOpen) {
        await _player.openPlayer();
        _playerOpen = true;
      }

      final channel = await ref.read(liveAssistantRepositoryProvider).connect();
      _channel = channel;
      _channelSubscription = channel.stream.listen(
        _handleServerFrame,
        onDone: _handleDisconnect,
        onError: (_) => _handleDisconnect(),
      );

      await _player.startPlayerFromStream(
        codec: Codec.pcm16,
        numChannels: 1,
        interleaved: true,
        sampleRate: _playbackSampleRate,
        bufferSize: 4096,
      );

      final micController = StreamController<Uint8List>();
      _micController = micController;
      _micSubscription = micController.stream.listen((chunk) => _channel?.sink.add(chunk));
      await _recorder.startRecorder(
        toStream: micController.sink,
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: _micSampleRate,
      );

      state = const AssistantListening();
    } catch (e) {
      await _teardown();
      state = AssistantError('Could not start the assistant: $e');
    }
  }

  Future<void> stop() async {
    await _teardown();
    state = const AssistantIdle();
  }

  void _handleServerFrame(dynamic frame) {
    if (frame is List<int>) {
      _player.uint8ListSink?.add(Uint8List.fromList(frame));
      state = AssistantSpeaking(transcript: _currentTranscript());
      return;
    }

    final payload = jsonDecode(frame as String) as Map<String, dynamic>;
    switch (payload['type']) {
      case 'ready':
        state = const AssistantListening();
      case 'transcript':
        state = AssistantSpeaking(transcript: payload['text'] as String?);
      case 'interrupted':
        // The user started talking over the assistant — flush whatever's
        // still queued so stale audio doesn't keep playing over them.
        unawaited(_flushPlayback());
        state = AssistantListening(transcript: _currentTranscript());
      case 'error':
        state = AssistantError(payload['message'] as String? ?? 'Assistant error');
    }
  }

  String? _currentTranscript() {
    final current = state;
    if (current is AssistantSpeaking) return current.transcript;
    if (current is AssistantListening) return current.transcript;
    return null;
  }

  Future<void> _flushPlayback() async {
    await _player.stopPlayer();
    await _player.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      interleaved: true,
      sampleRate: _playbackSampleRate,
      bufferSize: 4096,
    );
  }

  void _handleDisconnect() {
    if (state is AssistantError) return;
    state = const AssistantError('Connection to the assistant was lost.');
    unawaited(_teardown());
  }

  Future<void> _teardown() async {
    await _micSubscription?.cancel();
    _micSubscription = null;
    await _micController?.close();
    _micController = null;
    await _channelSubscription?.cancel();
    _channelSubscription = null;
    await _channel?.sink.close();
    _channel = null;
    if (_recorderOpen && _recorder.isRecording) {
      await _recorder.stopRecorder();
    }
    if (_playerOpen && _player.isPlaying) {
      await _player.stopPlayer();
    }
  }
}

final liveAssistantProvider =
    NotifierProvider<LiveAssistantNotifier, LiveAssistantState>(LiveAssistantNotifier.new);
