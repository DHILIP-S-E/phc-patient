// ============================================================
// PHC AI Assistant - Assistant State
// ============================================================

import 'package:equatable/equatable.dart';

enum AssistantPhase {
  initializing,
  idle,
  listening,
  processing,
  speaking,
  error,
}

class ConversationMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  final DateTime timestamp;

  ConversationMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, String> toContextMap() => {'role': role, 'content': content};
}

class AssistantState extends Equatable {
  final AssistantPhase phase;
  final String partialSpeechText;
  final String currentSubtitle;
  final List<ConversationMessage> conversation;
  final String languageCode;
  final String? errorMessage;
  final bool isModelLoaded;

  /// Transient prompt shown when the selected language's voice/speech pack is
  /// not installed. The UI shows it as a banner with an "Install" action instead
  /// of auto-redirecting to system settings.
  final String? voicePackPrompt;

  /// Offline speech-model download progress (0.0–1.0). 1.0 = ready/no download,
  /// -1.0 = failed. Shown as a progress banner during first-run setup.
  final double sttDownloadProgress;

  /// Whether the manual submit checkmark button should be displayed in the UI.
  final bool showCheckmark;

  const AssistantState({
    required this.phase,
    this.partialSpeechText = '',
    this.currentSubtitle = '',
    this.conversation = const [],
    this.languageCode = 'en',
    this.errorMessage,
    this.isModelLoaded = false,
    this.voicePackPrompt,
    this.sttDownloadProgress = 1.0,
    this.showCheckmark = false,
  });

  const AssistantState.initial()
      : this(phase: AssistantPhase.initializing);

  bool get isListening => phase == AssistantPhase.listening;
  bool get isProcessing => phase == AssistantPhase.processing;
  bool get isSpeaking => phase == AssistantPhase.speaking;
  bool get isIdle => phase == AssistantPhase.idle;

  AssistantState copyWith({
    AssistantPhase? phase,
    String? partialSpeechText,
    String? currentSubtitle,
    List<ConversationMessage>? conversation,
    String? languageCode,
    String? errorMessage,
    bool? isModelLoaded,
    String? voicePackPrompt,
    double? sttDownloadProgress,
    bool? showCheckmark,
  }) {
    return AssistantState(
      phase: phase ?? this.phase,
      partialSpeechText: partialSpeechText ?? this.partialSpeechText,
      currentSubtitle: currentSubtitle ?? this.currentSubtitle,
      conversation: conversation ?? this.conversation,
      languageCode: languageCode ?? this.languageCode,
      errorMessage: errorMessage,
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
      // Transient: not carried forward unless explicitly set, so the banner
      // shows once then clears on the next state update.
      voicePackPrompt: voicePackPrompt,
      sttDownloadProgress: sttDownloadProgress ?? this.sttDownloadProgress,
      showCheckmark: showCheckmark ?? this.showCheckmark,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        partialSpeechText,
        currentSubtitle,
        conversation,
        languageCode,
        errorMessage,
        isModelLoaded,
        voicePackPrompt,
        sttDownloadProgress,
        showCheckmark,
      ];
}
