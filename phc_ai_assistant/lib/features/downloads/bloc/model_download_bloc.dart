// ============================================================
// PHC AI Assistant - Model Download BLoC
// ============================================================

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phc_ai_assistant/core/models/download_progress.dart';
import 'package:phc_ai_assistant/core/downloads/model_repository.dart';
import 'model_download_event.dart';
import 'model_download_state.dart';

class ModelDownloadBloc extends Bloc<ModelDownloadEvent, ModelDownloadState> {
  final ModelRepository _repository;
  StreamSubscription<dynamic>? _downloadSubscription;

  ModelDownloadBloc({required ModelRepository repository})
      : _repository = repository,
        super(const ModelDownloadState.initial()) {
    on<CheckModelEvent>(_onCheckModel);
    on<StartDownloadEvent>(_onStartDownload);
    on<PauseDownloadEvent>(_onPauseDownload);
    on<ResumeDownloadEvent>(_onResumeDownload);
    on<CancelDownloadEvent>(_onCancelDownload);
    on<RetryDownloadEvent>(_onRetryDownload);
    on<VerifyModelEvent>(_onVerifyModel);
    on<DeleteModelEvent>(_onDeleteModel);
    on<ProgressUpdateEvent>(_onProgressUpdate);
    on<DownloadCompleteEvent>(_onDownloadComplete);
    on<DownloadErrorEvent>(_onDownloadError);
  }

  Future<void> _onCheckModel(
    CheckModelEvent event,
    Emitter<ModelDownloadState> emit,
  ) async {
    emit(state.copyWith(phase: DownloadPhase.checking));
    // Use full model info so we can tell apart three cases instead of blindly
    // re-downloading:
    //   1. file present AND verified   -> ready (use it, no download)
    //   2. file present but unverified -> verify it (DON'T re-download)
    //   3. no file                     -> notDownloaded (a Start will auto-resume
    //                                      from any leftover .partial)
    final result = await _repository.getModelInfo();
    result.fold(
      (failure) => emit(state.copyWith(
        phase: DownloadPhase.error,
        errorMessage: failure.message,
      )),
      (info) {
        if (info.localPath != null && info.isVerified) {
          emit(state.copyWith(phase: DownloadPhase.ready));
        } else if (info.localPath != null) {
          add(const VerifyModelEvent()); // present but not verified -> verify only
        } else {
          emit(state.copyWith(phase: DownloadPhase.notDownloaded));
        }
      },
    );
  }

  Future<void> _onStartDownload(
    StartDownloadEvent event,
    Emitter<ModelDownloadState> emit,
  ) async {
    emit(state.copyWith(phase: DownloadPhase.downloading));
    await _downloadSubscription?.cancel();
    _downloadSubscription = _repository.downloadModel().listen(
      (either) {
        either.fold(
          (failure) => add(DownloadErrorEvent(failure.message)),
          (progress) {
            if (progress.status == DownloadStatus.verifying) {
              add(const DownloadCompleteEvent());
            } else {
              add(ProgressUpdateEvent(progress));
            }
          },
        );
      },
      onError: (e) => add(DownloadErrorEvent(e.toString())),
    );
  }

  Future<void> _onPauseDownload(
    PauseDownloadEvent event,
    Emitter<ModelDownloadState> emit,
  ) async {
    await _repository.pauseDownload();
    emit(state.copyWith(phase: DownloadPhase.paused));
  }

  Future<void> _onResumeDownload(
    ResumeDownloadEvent event,
    Emitter<ModelDownloadState> emit,
  ) async {
    emit(state.copyWith(phase: DownloadPhase.downloading));
    await _downloadSubscription?.cancel();
    _downloadSubscription = _repository.resumeDownload().listen(
      (either) {
        either.fold(
          (failure) => add(DownloadErrorEvent(failure.message)),
          (progress) {
            if (progress.status == DownloadStatus.verifying) {
              add(const DownloadCompleteEvent());
            } else {
              add(ProgressUpdateEvent(progress));
            }
          },
        );
      },
      onError: (e) => add(DownloadErrorEvent(e.toString())),
    );
  }

  Future<void> _onCancelDownload(
    CancelDownloadEvent event,
    Emitter<ModelDownloadState> emit,
  ) async {
    await _downloadSubscription?.cancel();
    await _repository.cancelDownload();
    emit(state.copyWith(phase: DownloadPhase.notDownloaded));
  }

  Future<void> _onRetryDownload(
    RetryDownloadEvent event,
    Emitter<ModelDownloadState> emit,
  ) async {
    emit(state.copyWith(
      phase: DownloadPhase.notDownloaded,
      errorMessage: null,
    ));
    add(const StartDownloadEvent());
  }

  Future<void> _onVerifyModel(
    VerifyModelEvent event,
    Emitter<ModelDownloadState> emit,
  ) async {
    emit(state.copyWith(phase: DownloadPhase.verifying));
    final result = await _repository.verifyModel(
      onProgress: (p) => emit(state.copyWith(verificationProgress: p)),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        phase: DownloadPhase.error,
        errorMessage: failure.message,
      )),
      (isValid) {
        if (isValid) {
          emit(state.copyWith(phase: DownloadPhase.ready));
        } else {
          emit(state.copyWith(
            phase: DownloadPhase.error,
            errorMessage:
                'Checksum mismatch. Model file is corrupted. Please re-download.',
          ));
        }
      },
    );
  }

  Future<void> _onDeleteModel(
    DeleteModelEvent event,
    Emitter<ModelDownloadState> emit,
  ) async {
    final result = await _repository.deleteModel();
    result.fold(
      (failure) => emit(state.copyWith(
        phase: DownloadPhase.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(phase: DownloadPhase.notDownloaded)),
    );
  }

  void _onProgressUpdate(
    ProgressUpdateEvent event,
    Emitter<ModelDownloadState> emit,
  ) {
    emit(state.copyWith(progress: event.progress));
  }

  void _onDownloadComplete(
    DownloadCompleteEvent event,
    Emitter<ModelDownloadState> emit,
  ) {
    add(const VerifyModelEvent());
  }

  void _onDownloadError(
    DownloadErrorEvent event,
    Emitter<ModelDownloadState> emit,
  ) {
    emit(state.copyWith(
      phase: DownloadPhase.error,
      errorMessage: event.message,
    ));
  }

  @override
  Future<void> close() async {
    await _downloadSubscription?.cancel();
    return super.close();
  }
}
