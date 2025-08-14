import 'package:dio/dio.dart';
import 'package:mersin_map_follow_app/model/token_response_model.dart';


class AuthApi {
  final Dio _dio;

  AuthApi({required String baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ));

  Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post('/users/login', data: {
        'email': email,
        'password': password,
      });
      return TokenResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final msg = e.response?.data is Map
          ? (e.response?.data['detail']?.toString() ?? 'Login failed')
          : e.message ?? 'Login failed';
      throw ApiException(code: code, message: msg);
    } catch (e) {
      throw ApiException(code: 0, message: e.toString());
    }
  }
}

class ApiException implements Exception {
  final int code;
  final String message;
  ApiException({required this.code, required this.message});
  @override
  String toString() => 'ApiException($code): $message';
}
