import 'package:dartz/dartz.dart';
import 'package:phc_ai_assistant/core/errors/failures.dart';
import 'package:phc_ai_assistant/core/models/download_progress.dart';

abstract class ModelRepository {
  Future<Either<Failure, ModelInfo>> getModelInfo();
  Stream<Either<Failure, DownloadProgress>> downloadModel();
  Future<void> pauseDownload();
  Stream<Either<Failure, DownloadProgress>> resumeDownload();
  Future<void> cancelDownload();
  Future<Either<Failure, bool>> verifyModel({required void Function(double) onProgress});
  Future<Either<Failure, void>> deleteModel();
}
