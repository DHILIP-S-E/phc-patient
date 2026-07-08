/// Thrown whenever the backend's `{success: false, message: ...}` envelope
/// is returned, or a network-level failure occurs. Repositories let this
/// propagate; UI code catches it to show `message` directly (it's already
/// the backend's own human-readable error text).
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
