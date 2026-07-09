import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/failures.dart';
import 'model_repository.dart';
import 'model_download_datasource.dart';
import 'package:phc_ai_assistant/core/models/download_progress.dart';

class ModelRepositoryImpl implements ModelRepository {
  final ModelDownloadDataSource _dataSource;
  final SharedPreferences _prefs;

  ModelRepositoryImpl({required ModelDownloadDataSource dataSource, required SharedPreferences prefs}) : _dataSource = dataSource, _prefs = prefs;

  @override
  Future<Either<Failure, ModelInfo>> getModelInfo() async {
    try {
      final exists = await _dataSource.modelExists();
      if (!exists) return const Right(ModelInfo(localPath: null, isVerified: false));
      final path = await _dataSource.modelFilePath;
      final verified = _prefs.getBool('model_verified') ?? false;
      return Right(ModelInfo(localPath: path, isVerified: verified));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, DownloadProgress>> downloadModel() async* {
    try {
      await for (final progress in _dataSource.downloadModel()) {
        yield Right(progress);
      }
    } catch (e) {
      yield Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<void> pauseDownload() async => _dataSource.pause();

  @override
  Stream<Either<Failure, DownloadProgress>> resumeDownload() async* {
    try {
      await for (final progress in _dataSource.resume()) {
        yield Right(progress);
      }
    } catch (e) {
      yield Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<void> cancelDownload() => _dataSource.cancel();

  @override
  Future<Either<Failure, bool>> verifyModel({required void Function(double) onProgress}) async {
    try {
      // Fake verification for now or implement real checksum
      onProgress(1.0);
      await _prefs.setBool('model_verified', true);
      return const Right(true);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteModel() async {
    try {
      await _dataSource.deleteModel();
      await _prefs.setBool('model_verified', false);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
