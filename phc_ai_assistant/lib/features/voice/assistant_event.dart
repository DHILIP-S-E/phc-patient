// ============================================================
// PHC AI Assistant - Assistant BLoC Events
// ============================================================

import 'package:equatable/equatable.dart';

abstract class AssistantEvent extends Equatable {
  const AssistantEvent();
  @override
  List<Object?> get props => [];
}

class InitializeAssistantEvent extends AssistantEvent {
  const InitializeAssistantEvent();
}

class StartListeningEvent extends AssistantEvent {
  const StartListeningEvent();
}

class StopListeningEvent extends AssistantEvent {
  const StopListeningEvent();
}

class SpeechPartialEvent extends AssistantEvent {
  final String text;
  const SpeechPartialEvent(this.text);
  @override
  List<Object?> get props => [text];
}

class SpeechFinalEvent extends AssistantEvent {
  final String text;
  const SpeechFinalEvent(this.text);
  @override
  List<Object?> get props => [text];
}

class GenerateResponseEvent extends AssistantEvent {
  final String userMessage;

  /// Whether to speak the reply via TTS after generating. Voice screen = true;
  /// the text-only Chat screen passes false so it just shows text.
  final bool speak;

  const GenerateResponseEvent(this.userMessage, {this.speak = true});
  @override
  List<Object?> get props => [userMessage, speak];
}

class SpeakResponseEvent extends AssistantEvent {
  final String text;
  const SpeakResponseEvent(this.text);
  @override
  List<Object?> get props => [text];
}

class SpeakingCompleteEvent extends AssistantEvent {
  const SpeakingCompleteEvent();
}

class ChangeLanguageEvent extends AssistantEvent {
  final String languageCode;
  const ChangeLanguageEvent(this.languageCode);
  @override
  List<Object?> get props => [languageCode];
}

class ClearConversationEvent extends AssistantEvent {
  const ClearConversationEvent();
}

class StopSpeakingEvent extends AssistantEvent {
  const StopSpeakingEvent();
}

/// Abort an in-flight model generation (barge-in / stop button).
class CancelGenerationEvent extends AssistantEvent {
  const CancelGenerationEvent();
}

/// User tapped "Install" on the missing-voice-pack banner.
class InstallVoicePacksEvent extends AssistantEvent {
  const InstallVoicePacksEvent();
}

/// A speech-recognition error surfaced (e.g. no match, timeout).
class SpeechErrorEvent extends AssistantEvent {
  final String errorId;
  const SpeechErrorEvent(this.errorId);
  @override
  List<Object?> get props => [errorId];
}

/// Offline speech-model download progress update (0.0–1.0, -1.0 = error).
class SttDownloadProgressEvent extends AssistantEvent {
  final double progress;
  const SttDownloadProgressEvent(this.progress);
  @override
  List<Object?> get props => [progress];
}

/// Trigger the manual submit checkmark button visibility.
class ShowCheckmarkEvent extends AssistantEvent {
  const ShowCheckmarkEvent();
}
