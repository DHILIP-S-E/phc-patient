// ============================================================
// PHC AI Assistant - TTS Playback Queue Unit Tests
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:phc_ai_assistant/features/voice/data/datasources/text_to_speech_datasource.dart';
import 'package:phc_ai_assistant/features/voice/data/datasources/tts_playback_queue.dart';

class MockTextToSpeechDataSource extends TextToSpeechDataSource {
  final List<String> spokenChunks = [];
  bool wasStopped = false;
  bool isTtsSpeaking = false;

  @override
  bool get isSpeaking => isTtsSpeaking;

  @override
  Future<void> speakSequential(String text) async {
    spokenChunks.add(text);
    isTtsSpeaking = true;
    await Future.delayed(const Duration(milliseconds: 10));
    isTtsSpeaking = false;
  }

  @override
  Future<void> stop() async {
    wasStopped = true;
    isTtsSpeaking = false;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TtsPlaybackQueue Tests', () {
    late MockTextToSpeechDataSource mockTts;
    late TtsPlaybackQueue queue;

    setUp(() {
      mockTts = MockTextToSpeechDataSource();
      queue = TtsPlaybackQueue(mockTts);
    });

    test('should speak enqueued chunks sequentially', () async {
      queue.enqueue('Hello');
      queue.enqueue('How are you');

      // Allow async queue processing to run
      await Future.delayed(const Duration(milliseconds: 50));

      expect(mockTts.spokenChunks, equals(['Hello', 'How are you']));
    });

    test('should clear queue and stop tts on clear', () async {
      queue.enqueue('Hello');
      await queue.clear();

      expect(mockTts.wasStopped, isTrue);
      expect(queue.isSpeaking, isFalse);
    });
  });
}
