// ============================================================
// PHC AI Assistant - Failures
// Typed error hierarchy using dartz Either pattern
// ============================================================

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

// ── Network Failures ──────────────────────────────────────
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class NoInternetFailure extends Failure {
  const NoInternetFailure()
      : super(message: 'No internet connection available');
}

// ── Download Failures ─────────────────────────────────────
class DownloadFailure extends Failure {
  const DownloadFailure({required super.message, super.code});
}

class DownloadCancelledFailure extends Failure {
  const DownloadCancelledFailure()
      : super(message: 'Download was cancelled');
}

class ChecksumFailure extends Failure {
  const ChecksumFailure({required super.message})
      : super(code: 'CHECKSUM_MISMATCH');
}

// ── Storage Failures ──────────────────────────────────────
class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});
}

class InsufficientStorageFailure extends Failure {
  final int requiredBytes;
  final int availableBytes;

  const InsufficientStorageFailure({
    required this.requiredBytes,
    required this.availableBytes,
  }) : super(
          message:
              'Insufficient storage. Required: $requiredBytes bytes, Available: $availableBytes bytes',
          code: 'INSUFFICIENT_STORAGE',
        );

  @override
  List<Object?> get props => [...super.props, requiredBytes, availableBytes];
}

// ── AI Engine Failures ────────────────────────────────────
class ModelNotFoundFailure extends Failure {
  const ModelNotFoundFailure()
      : super(message: 'AI model not found. Please download it first.', code: 'MODEL_NOT_FOUND');
}

class ModelLoadFailure extends Failure {
  const ModelLoadFailure({required super.message, super.code});
}

class InferenceFailure extends Failure {
  const InferenceFailure({required super.message, super.code});
}

class ContextLengthFailure extends Failure {
  const ContextLengthFailure()
      : super(message: 'Conversation too long. Starting fresh.', code: 'CONTEXT_OVERFLOW');
}

// ── Voice Failures ────────────────────────────────────────
class MicrophonePermissionFailure extends Failure {
  const MicrophonePermissionFailure()
      : super(message: 'Microphone permission denied', code: 'MIC_PERMISSION_DENIED');
}

class SpeechRecognitionFailure extends Failure {
  const SpeechRecognitionFailure({required super.message, super.code});
}

class TtsFailure extends Failure {
  const TtsFailure({required super.message, super.code});
}

// ── General Failures ──────────────────────────────────────
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message})
      : super(code: 'UNKNOWN');
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}
