// ============================================================
// PHC AI Assistant - Model Download Events
// ============================================================

import 'package:equatable/equatable.dart';
import 'package:phc_ai_assistant/core/models/download_progress.dart';

abstract class ModelDownloadEvent extends Equatable {
  const ModelDownloadEvent();
  @override
  List<Object?> get props => [];
}

class CheckModelEvent extends ModelDownloadEvent {
  const CheckModelEvent();
}

class StartDownloadEvent extends ModelDownloadEvent {
  const StartDownloadEvent();
}

class PauseDownloadEvent extends ModelDownloadEvent {
  const PauseDownloadEvent();
}

class ResumeDownloadEvent extends ModelDownloadEvent {
  const ResumeDownloadEvent();
}

class CancelDownloadEvent extends ModelDownloadEvent {
  const CancelDownloadEvent();
}

class RetryDownloadEvent extends ModelDownloadEvent {
  const RetryDownloadEvent();
}

class VerifyModelEvent extends ModelDownloadEvent {
  const VerifyModelEvent();
}

class DeleteModelEvent extends ModelDownloadEvent {
  const DeleteModelEvent();
}

// Internal events (used within BLoC only — public so they can be 'on'd)
class ProgressUpdateEvent extends ModelDownloadEvent {
  final DownloadProgress progress;
  const ProgressUpdateEvent(this.progress);
  @override
  List<Object?> get props => [progress];
}

class DownloadCompleteEvent extends ModelDownloadEvent {
  const DownloadCompleteEvent();
}

class DownloadErrorEvent extends ModelDownloadEvent {
  final String message;
  const DownloadErrorEvent(this.message);
  @override
  List<Object?> get props => [message];
}
