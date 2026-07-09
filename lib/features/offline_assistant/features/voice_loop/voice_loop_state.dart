// ============================================================
// PHC AI Assistant - Voice Loop State
// ============================================================

import 'package:equatable/equatable.dart';

enum VoiceLoopPhase {
  initializing,
  idle,
  listening,
  thinking,
  speaking,
  error,
}

class VoiceMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  final DateTime timestamp;

  VoiceMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, String> toContextMap() => {'role': role, 'content': content};
}

class VoiceLoopState extends Equatable {
  final VoiceLoopPhase phase;
  final String partialSpeechText;
  final String currentSubtitle;
  final List<VoiceMessage> conversation;
  final String languageCode;
  final String? errorMessage;
  final bool isModelLoaded;
  final String? voicePackPrompt;
  final double sttDownloadProgress;
  final bool showCheckmark;

  const VoiceLoopState({
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

  const VoiceLoopState.initial() : this(phase: VoiceLoopPhase.initializing);

  bool get isListening => phase == VoiceLoopPhase.listening;
  bool get isThinking => phase == VoiceLoopPhase.thinking;
  bool get isSpeaking => phase == VoiceLoopPhase.speaking;
  bool get isIdle => phase == VoiceLoopPhase.idle;

  VoiceLoopState copyWith({
    VoiceLoopPhase? phase,
    String? partialSpeechText,
    String? currentSubtitle,
    List<VoiceMessage>? conversation,
    String? languageCode,
    String? errorMessage,
    bool? isModelLoaded,
    String? voicePackPrompt,
    double? sttDownloadProgress,
    bool? showCheckmark,
  }) {
    return VoiceLoopState(
      phase: phase ?? this.phase,
      partialSpeechText: partialSpeechText ?? this.partialSpeechText,
      currentSubtitle: currentSubtitle ?? this.currentSubtitle,
      conversation: conversation ?? this.conversation,
      languageCode: languageCode ?? this.languageCode,
      errorMessage: errorMessage,
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
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
