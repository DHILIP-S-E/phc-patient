// ============================================================
// PHC AI Assistant - Download Progress Entity
// ============================================================

import 'package:equatable/equatable.dart';

enum DownloadStatus {
  idle,
  downloading,
  paused,
  verifying,
  completed,
  failed,
  cancelled,
}

class DownloadProgress extends Equatable {
  final DownloadStatus status;
  final int downloadedBytes;
  final int totalBytes;
  final double speedBytesPerSecond;
  final int etaSeconds;
  final String? errorMessage;

  const DownloadProgress({
    required this.status,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.speedBytesPerSecond = 0,
    this.etaSeconds = 0,
    this.errorMessage,
  });

  double get progress =>
      totalBytes > 0 ? downloadedBytes / totalBytes : 0.0;

  int get remainingBytes => totalBytes - downloadedBytes;

  const DownloadProgress.initial()
      : this(status: DownloadStatus.idle);

  DownloadProgress copyWith({
    DownloadStatus? status,
    int? downloadedBytes,
    int? totalBytes,
    double? speedBytesPerSecond,
    int? etaSeconds,
    String? errorMessage,
  }) {
    return DownloadProgress(
      status: status ?? this.status,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      speedBytesPerSecond: speedBytesPerSecond ?? this.speedBytesPerSecond,
      etaSeconds: etaSeconds ?? this.etaSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        downloadedBytes,
        totalBytes,
        speedBytesPerSecond,
        etaSeconds,
        errorMessage,
      ];
}
class ModelInfo {
  final String? localPath;
  final bool isVerified;
  const ModelInfo({this.localPath, this.isVerified = false});
}
