// ============================================================
// PHC AI Assistant - AI Repository Interface
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ai_response.dart';

abstract class AiRepository {
  /// Load the AI model into memory. Idempotent — safe to call multiple times.
  Future<Either<Failure, void>> loadModel();

  /// Unload model from memory (called under memory pressure).
  Future<Either<Failure, void>> unloadModel();

  /// Check if model is currently loaded.
  bool get isModelLoaded;

  /// Generate a healthcare response for the given input.
  Future<Either<Failure, AiResponse>> generateResponse({
    required String userMessage,
    required String languageCode,
    required List<Map<String, String>> conversationHistory,
  });

  /// Streaming generation. Emits the CLEANED cumulative reply text as it grows
  /// (each event contains the full text so far), so the UI can render tokens
  /// live. The final event is the complete cleaned reply. Emits a [Failure] if
  /// generation fails.
  Stream<Either<Failure, String>> generateResponseStream({
    required String userMessage,
    required String languageCode,
    required List<Map<String, String>> conversationHistory,
  });

  /// Clear conversation context.
  Future<Either<Failure, void>> clearContext();

  /// Abort an in-flight generation (barge-in / stop).
  void cancelGeneration();
}
