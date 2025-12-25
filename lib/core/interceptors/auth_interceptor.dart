import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/endpoints.dart';

class AuthInterceptor extends Interceptor {
  // List of endpoints that should NOT have Authorization header
  static const List<String> _publicEndpoints = [
    ApiEndpoints.login,
    ApiEndpoints.verify,
  ];

  // Check if endpoint is a registration endpoint (they follow pattern /register/{role})
  static bool _isRegisterEndpoint(String path) {
    return path.startsWith('/register/');
  }

  // Check if endpoint should skip Authorization header
  static bool _shouldSkipAuth(String path) {
    return _publicEndpoints.contains(path) || _isRegisterEndpoint(path);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding Authorization header for public endpoints
    if (_shouldSkipAuth(options.path)) {
      handler.next(options);
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // If we can't get the token, proceed without it
      // The API will return 401 if auth is required
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if this is a 401 error and we're not already on a public/auth endpoint
    if (err.response?.statusCode == 401 &&
        !_shouldSkipAuth(err.requestOptions.path)) {
      // Token expired or invalid - clear session and logout user
      print('🔒 Token expired or invalid - logging out user');
      await _clearSession();
      handler.reject(err);
    } else {
      // Not a 401 or public endpoint, pass through the error
      handler.reject(err);
    }
  }

  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_id');
      await prefs.remove('user_role');
      await prefs.setBool('isLoggedIn', false);
    } catch (e) {
      // Ignore errors during cleanup
    }
  }
}
