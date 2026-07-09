// ============================================================
// PHC AI Assistant - Chat Cubit Unit Tests
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phc_ai_assistant/features/chat/chat_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:phc_ai_assistant/core/ai/ai_repository.dart';
import 'package:phc_ai_assistant/core/errors/failures.dart';
import 'package:phc_ai_assistant/core/models/ai_response.dart';

class MockAiRepository implements AiRepository {
  bool wasCancelled = false;
  bool isLoaded = true;
  String stubbedResponse = "Mock response";

  @override
  bool get isModelLoaded => isLoaded;

  @override
  Future<Either<Failure, void>> loadModel() async => const Right(null);

  @override
  Future<Either<Failure, void>> unloadModel() async => const Right(null);

  @override
  Future<Either<Failure, AiResponse>> generateResponse({
    required String userMessage,
    required String languageCode,
    required List<Map<String, String>> conversationHistory,
  }) async {
    return Right(AiResponse(
      text: stubbedResponse,
      languageCode: languageCode,
      inferenceTime: Duration.zero,
      detectedKeywords: const [],
    ));
  }

  @override
  Stream<Either<Failure, String>> generateResponseStream({
    required String userMessage,
    required String languageCode,
    required List<Map<String, String>> conversationHistory,
  }) async* {
    wasCancelled = false;
    final words = stubbedResponse.split(' ');
    String current = '';
    for (final word in words) {
      if (wasCancelled) break;
      current = current.isEmpty ? word : '$current $word';
      yield Right(current);
      await Future.delayed(const Duration(milliseconds: 5));
    }
  }

  @override
  Future<Either<Failure, void>> clearContext() async => const Right(null);

  @override
  void cancelGeneration() {
    wasCancelled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatCubit Tests', () {
    late MockAiRepository mockAi;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      mockAi = MockAiRepository();
    });

    test('should initialize with empty messages if no history exists', () {
      final cubit = ChatCubit(mockAi, prefs);
      expect(cubit.state.messages, isEmpty);
      expect(cubit.state.isGenerating, isFalse);
    });

    test('should load history from SharedPreferences on initialization', () async {
      SharedPreferences.setMockInitialValues({
        'chat_history': '[{"role":"user","content":"Hi"},{"role":"assistant","content":"Hello"}]'
      });
      prefs = await SharedPreferences.getInstance();

      final cubit = ChatCubit(mockAi, prefs);
      expect(cubit.state.messages.length, 2);
      expect(cubit.state.messages[0], const ChatMessage(role: 'user', content: 'Hi'));
      expect(cubit.state.messages[1], const ChatMessage(role: 'assistant', content: 'Hello'));
    });

    test('should send message, stream response, and save to SharedPreferences', () async {
      final cubit = ChatCubit(mockAi, prefs);
      mockAi.stubbedResponse = "Hello patient";

      await cubit.send("I have fever");

      expect(cubit.state.messages.length, 2);
      expect(cubit.state.messages[0], const ChatMessage(role: 'user', content: 'I have fever'));
      expect(cubit.state.messages[1], const ChatMessage(role: 'assistant', content: 'Hello patient'));

      final savedHistory = prefs.getString('chat_history');
      expect(savedHistory, contains('I have fever'));
      expect(savedHistory, contains('Hello patient'));
    });

    test('should cancel response stream generation', () async {
      final cubit = ChatCubit(mockAi, prefs);
      mockAi.stubbedResponse = "Hello this is a long text response";

      final future = cubit.send("Hi");
      // Give it a tiny bit to start generating
      await Future.delayed(const Duration(milliseconds: 2));
      cubit.cancel();
      await future;

      expect(mockAi.wasCancelled, isTrue);
    });

    test('should regenerate last response', () async {
      final cubit = ChatCubit(mockAi, prefs);
      mockAi.stubbedResponse = "First response";
      await cubit.send("Hello");

      expect(cubit.state.messages.length, 2);
      expect(cubit.state.messages[1].content, "First response");

      mockAi.stubbedResponse = "Second response";
      await cubit.regenerate();

      expect(cubit.state.messages.length, 2);
      expect(cubit.state.messages[0].content, "Hello");
      expect(cubit.state.messages[1].content, "Second response");

      final savedHistory = prefs.getString('chat_history');
      expect(savedHistory, contains('Second response'));
      expect(savedHistory, isNot(contains('First response')));
    });

    test('should clear history and remove from SharedPreferences', () async {
      final cubit = ChatCubit(mockAi, prefs);
      mockAi.stubbedResponse = "Test";
      await cubit.send("Hello");

      expect(prefs.getString('chat_history'), isNotNull);

      cubit.clear();
      expect(cubit.state.messages, isEmpty);
      expect(prefs.getString('chat_history'), equals('[]'));
    });
  });
}
