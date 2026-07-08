import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'api_exception.dart';
import 'token_storage.dart';

/// Thin wrapper around Dio: attaches the patient bearer token to every
/// request and unwraps the backend's `{success, message, data}` envelope
/// (see phc_api/schemas/response.py::APIResponse) into either the raw
/// `data` payload or an [ApiException].
class ApiClient {
  final Dio dio;
  final TokenStorage tokenStorage;

  ApiClient({required this.tokenStorage}) : dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  /// Runs [request], unwraps the envelope, and returns `data` transformed by
  /// [fromJson]. `data` may legitimately be null (e.g. GET /patients/me/pregnancy
  /// for a patient with no pregnancy record) — callers pass a [fromJson] that
  /// tolerates a null input when that's a valid response shape.
  Future<T> unwrap<T>(
    Future<Response> Function() request,
    T Function(dynamic json) fromJson,
  ) async {
    try {
      final response = await request();
      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ApiException(body['message'] as String? ?? 'Request failed');
      }
      return fromJson(body['data']);
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map<String, dynamic> && body['message'] != null) {
        throw ApiException(body['message'] as String, statusCode: e.response?.statusCode);
      }
      throw ApiException(e.message ?? 'Network error', statusCode: e.response?.statusCode);
    }
  }
}
