// ============================================================
// PHC AI Assistant - Model Repository Interface
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/download_progress.dart';
import '../entities/model_info.dart';

abstract class ModelRepository {
  /// Check if the model exists and is verified locally
  Future<Either<Failure, bool>> checkModelExists();

  /// Get current model metadata
  Future<Either<Failure, ModelInfo>> getModelInfo();

  /// Download the model with real-time progress stream
  Stream<Either<Failure, DownloadProgress>> downloadModel();

  /// Pause active download
  Future<Either<Failure, void>> pauseDownload();

  /// Resume paused download
  Stream<Either<Failure, DownloadProgress>> resumeDownload();

  /// Cancel download and cleanup partial file
  Future<Either<Failure, void>> cancelDownload();

  /// Verify model checksum after download
  Future<Either<Failure, bool>> verifyModel({
    void Function(double progress)? onProgress,
  });

  /// Delete model file and clear metadata
  Future<Either<Failure, void>> deleteModel();

  /// Check for model updates from remote
  Future<Either<Failure, ModelInfo?>> checkForUpdate();

  /// Get available storage in bytes
  Future<Either<Failure, int>> getAvailableStorage();
}
