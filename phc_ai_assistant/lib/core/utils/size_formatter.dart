// ============================================================
// PHC AI Assistant - Size Formatter Utility
// Human-readable byte sizes and download speeds
// ============================================================

class SizeFormatter {
  SizeFormatter._();

  static const List<String> _units = ['B', 'KB', 'MB', 'GB', 'TB'];

  /// Format bytes to human-readable string.
  /// e.g., 840000000 → "801.3 MB"
  static String format(int bytes) {
    if (bytes <= 0) return '0 B';
    int i = 0;
    double value = bytes.toDouble();
    while (value >= 1024 && i < _units.length - 1) {
      value /= 1024;
      i++;
    }
    return '${value.toStringAsFixed(i == 0 ? 0 : 1)} ${_units[i]}';
  }

  /// Format bytes per second to download speed string.
  /// e.g., 2097152 → "2.0 MB/s"
  static String formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond <= 0) return '0 B/s';
    int i = 0;
    double value = bytesPerSecond;
    while (value >= 1024 && i < _units.length - 1) {
      value /= 1024;
      i++;
    }
    return '${value.toStringAsFixed(i == 0 ? 0 : 1)} ${_units[i]}/s';
  }

  /// Format seconds to human-readable ETA.
  /// e.g., 3725 → "1h 2m 5s"
  static String formatEta(int seconds) {
    if (seconds <= 0) return '--';
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) {
      final m = seconds ~/ 60;
      final s = seconds % 60;
      return s > 0 ? '${m}m ${s}s' : '${m}m';
    }
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  /// Format a percentage (0.0 to 1.0) to display string.
  static String formatPercent(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
}
