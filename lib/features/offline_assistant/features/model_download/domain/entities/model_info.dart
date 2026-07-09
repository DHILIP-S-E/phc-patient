// ============================================================
// PHC AI Assistant - Model Info Entity
// ============================================================

import 'package:equatable/equatable.dart';

class ModelInfo extends Equatable {
  final String name;
  final String version;
  final String fileName;
  final String downloadUrl;
  final String checksum;
  final int sizeBytes;
  final DateTime? downloadedAt;
  final String? localPath;
  final bool isVerified;

  const ModelInfo({
    required this.name,
    required this.version,
    required this.fileName,
    required this.downloadUrl,
    required this.checksum,
    required this.sizeBytes,
    this.downloadedAt,
    this.localPath,
    this.isVerified = false,
  });

  bool get isAvailable => localPath != null && isVerified;

  ModelInfo copyWith({
    String? name,
    String? version,
    String? fileName,
    String? downloadUrl,
    String? checksum,
    int? sizeBytes,
    DateTime? downloadedAt,
    String? localPath,
    bool? isVerified,
  }) {
    return ModelInfo(
      name: name ?? this.name,
      version: version ?? this.version,
      fileName: fileName ?? this.fileName,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      checksum: checksum ?? this.checksum,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      localPath: localPath ?? this.localPath,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => [
        name,
        version,
        fileName,
        downloadUrl,
        checksum,
        sizeBytes,
        downloadedAt,
        localPath,
        isVerified,
      ];
}
