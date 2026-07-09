// ============================================================
// PHC AI Assistant - TTS Playback Queue
// Manages sequential, non-overlapping sentence playback for streaming TTS.
//
// BUG FIX: The previous version had a window between sentences where both
// _isProcessing=false and _tts.isSpeaking=false, making isSpeaking report
// false mid-reply. This caused SpeakingCompleteEvent to fire too early,
// which triggered StartListeningEvent and restarted the voice loop before
// the AI finished speaking.
//
// Fix: introduce _isPendingOrActive that stays true from the moment the first
// chunk is enqueued until _processQueue fully drains, with no gaps.
// ============================================================

import 'dart:collection';
import 'package:logger/logger.dart';
import 'text_to_speech_datasource.dart';

class TtsPlaybackQueue {
  final TextToSpeechDataSource _tts;
  final Queue<String> _queue = Queue<String>();
  final Logger _logger = Logger();

  // True from first enqueue() until the last sentence finishes playing.
  // No gaps between sentences — this is the key fix.
  bool _isPendingOrActive = false;

  TtsPlaybackQueue(this._tts);

  /// Add a new text chunk (sentence/phrase) to the playback queue.
  void enqueue(String text) {
    final cleaned = text.trim();
    if (cleaned.isEmpty) return;

    _logger.d('[TTS Queue] Enqueueing: "$cleaned"');
    _queue.add(cleaned);
    // Mark as active immediately so isSpeaking is true before _processQueue runs.
    _isPendingOrActive = true;
    _processQueue();
  }

  /// Process the queued items sequentially.
  Future<void> _processQueue() async {
    // Only one _processQueue loop should run at a time.
    // Additional calls while we are in the while-loop just add to _queue;
    // the running loop will pick them up.
    if (_tts.isSpeaking) return; // already inside speak(), let it complete

    while (_queue.isNotEmpty) {
      final chunk = _queue.removeFirst();
      _logger.d('[TTS Queue] Speaking: "$chunk"');
      try {
        // speakSequential awaits TTS completion before returning.
        await _tts.speakSequential(chunk);
      } catch (e) {
        _logger.e('[TTS Queue] Error: $e');
      }
    }

    // Queue is fully drained — now safe to signal completion.
    _isPendingOrActive = false;
  }

  /// Stop any active speech and clear all pending queue items.
  Future<void> clear() async {
    _logger.i('[TTS Queue] Clearing queue and stopping speech');
    _queue.clear();
    _isPendingOrActive = false;
    await _tts.stop();
  }

  /// True while the queue has items or TTS is actively speaking.
  /// Never has a false gap between sentences.
  bool get isSpeaking => _isPendingOrActive || _tts.isSpeaking;
}
