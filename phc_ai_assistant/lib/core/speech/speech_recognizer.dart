// ============================================================
// PHC AI Assistant - Speech Recognizer Interface
// Common contract so the voice pipeline (AssistantBloc) can use either the
// Android system recognizer or the offline Whisper engine interchangeably.
// ============================================================

abstract class SpeechRecognizer {
  /// Prepare the engine (permissions, models). Returns true if usable.
  Future<bool> initialize();

  /// Set the recognition language (code like 'en', 'ta', 'hi').
  void setLanguage(String languageCode);

  /// Whether this engine can recognise [languageCode]. Whisper (multilingual)
  /// is always true; the system recognizer depends on installed packs.
  Future<bool> isLanguageAvailable(String languageCode);

  /// Begin capturing speech.
  /// [background] = true means this is a passive barge-in session while the
  /// AI is speaking. Errors and empty finals are suppressed; only non-empty
  /// finals (the user actually said something) are forwarded.
  Future<void> startListening({bool background = false});

  /// Stop capturing and finalise the transcript.
  Future<void> stopListening();

  /// Partial (live) transcripts as the user speaks. Whisper emits nothing here
  /// (it transcribes after the pause); the system recognizer streams words.
  Stream<String> get partialResults;

  /// Final transcript for an utterance.
  Stream<String> get finalResults;

  /// Recognition errors (e.g. 'no_match', 'model_not_ready').
  Stream<String> get errors;

  /// One-time model download progress (0.0–1.0), 1.0 when ready, -1.0 on error.
  /// The system recognizer needs no model, so it reports ready immediately.
  Stream<double> get modelDownloadProgress;

  /// Whether the engine is ready to recognise right now.
  bool get isReady;
}
