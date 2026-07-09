// ============================================================
// PHC AI Assistant - Model Download State
// ============================================================

import 'package:equatable/equatable.dart';
import 'package:phc_ai_assistant/core/models/download_progress.dart';

enum DownloadPhase {
  initial,
  checking,
  notDownloaded,
  downloading,
  paused,
  verifying,
  ready,
  error,
}

class ModelDownloadState extends Equatable {
  final DownloadPhase phase;
  final DownloadProgress? progress;
  final double verificationProgress;
  final String? errorMessage;

  const ModelDownloadState({
    required this.phase,
    this.progress,
    this.verificationProgress = 0.0,
    this.errorMessage,
  });

  const ModelDownloadState.initial()
      : this(phase: DownloadPhase.initial);

  bool get isModelReady => phase == DownloadPhase.ready;
  bool get isDownloading => phase == DownloadPhase.downloading;
  bool get isPaused => phase == DownloadPhase.paused;
  bool get isVerifying => phase == DownloadPhase.verifying;
  bool get hasError => phase == DownloadPhase.error;

  ModelDownloadState copyWith({
    DownloadPhase? phase,
    DownloadProgress? progress,
    double? verificationProgress,
    String? errorMessage,
  }) {
    return ModelDownloadState(
      phase: phase ?? this.phase,
      progress: progress ?? this.progress,
      verificationProgress: verificationProgress ?? this.verificationProgress,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        progress,
        verificationProgress,
        errorMessage,
      ];
}
