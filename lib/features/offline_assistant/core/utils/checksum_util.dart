// ============================================================
// PHC AI Assistant - Checksum Utility
// SHA-256 file verification for downloaded model integrity
// ============================================================

import 'dart:io';
import 'dart:isolate';
import 'package:crypto/crypto.dart';

class ChecksumUtil {
  ChecksumUtil._();

  /// Compute SHA-256 checksum of a file.
  /// Runs inside a background Isolate so it never blocks the main UI thread.
  static Future<String> computeFileSha256(
    String filePath, {
    void Function(double progress)? onProgress,
  }) async {
    return Isolate.run(() async {
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileSystemException('File not found', filePath);
      }
      final digest = await sha256.bind(file.openRead()).first;
      return digest.toString();
    });
  }

  /// Verify a file against a known SHA-256 checksum.
  /// Returns true if checksum matches, false otherwise.
  static Future<bool> verifyFile(
    String filePath,
    String expectedChecksum, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final actualChecksum = await computeFileSha256(
        filePath,
        onProgress: onProgress,
      );
      // Normalize: strip "sha256:" prefix if present
      final expected = expectedChecksum
          .replaceFirst('sha256:', '')
          .toLowerCase()
          .trim();
      final actual = actualChecksum.toLowerCase().trim();
      return expected == actual;
    } catch (_) {
      return false;
    }
  }
}
