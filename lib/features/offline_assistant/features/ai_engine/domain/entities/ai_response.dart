// ============================================================
// PHC AI Assistant - AI Response Entity
// ============================================================

import 'package:equatable/equatable.dart';

class AiResponse extends Equatable {
  final String text;
  final String languageCode;
  final int inputTokens;
  final int outputTokens;
  final Duration inferenceTime;
  final List<String> detectedKeywords;

  const AiResponse({
    required this.text,
    required this.languageCode,
    required this.inferenceTime,
    this.inputTokens = 0,
    this.outputTokens = 0,
    this.detectedKeywords = const [],
  });

  @override
  List<Object?> get props => [
        text,
        languageCode,
        inputTokens,
        outputTokens,
        inferenceTime,
        detectedKeywords,
      ];
}
