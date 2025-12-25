import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../models/forgot_password_models.dart';
import '../models/login_models.dart';
import '../models/register_models.dart';
import '../models/user_profile_models.dart';
import '../models/verify_account_models.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Ref ref;
  AuthRepositoryImpl(this.ref);

  @override
  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      // Convert to form-urlencoded format
      final formData = {
        'email': request.email,
        'password': request.password,
      };

      final Response<dynamic> response = await apiClient.post(
        ApiEndpoints.login,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // Handle response structure: {message: "...", data: {...}}
      final responseData = response.data as Map<String, dynamic>;
      return Success(
        data: LoginResponse.fromJson(responseData),
      );
    } on DioException catch (e) {
      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    }
  }

  @override
  Future<ApiResult<LoginResponse>> refreshToken(String refreshToken) async {
    try {
      // Create a Dio instance without AuthInterceptor to avoid infinite loops
      final config = ref.read(appConfigProvider);
      final dioWithoutAuth = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      // Try both possible formats: form-data with refresh_token field or Bearer token
      final formData = {
        'refresh_token': refreshToken,
      };

      print('🔄 Refresh Token API Call');

      final Response<dynamic> response = await dioWithoutAuth.post(
        ApiEndpoints.refreshToken,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      print('✅ Refresh Token Response Status: ${response.statusCode}');

      final responseData = response.data as Map<String, dynamic>;
      return Success(
        data: LoginResponse.fromJson(responseData),
      );
    } on DioException catch (e) {
      print('❌ Refresh Token Error:');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> register(
    RegisterRequest request,
    String role,
  ) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final endpoint = ApiEndpoints.register(role);

      // Convert to form-urlencoded format
      final formData = <String, dynamic>{
        'email': request.email,
        'phone_number': request.phoneNumber,
        'password': request.password,
      };

      if (request.nin != null && request.nin!.isNotEmpty) {
        formData['nin'] = request.nin!;
      }

      print('🚀 Register API Call:');
      print('   Endpoint: $endpoint');
      print('   Role: $role');
      print('   Data: ${formData.keys}');

      final Response<dynamic> response = await apiClient.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print('✅ Register Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: RegisterResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Register Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Register Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<VerifyAccountResponse>> verifyAccount(
    VerifyAccountRequest request,
  ) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final Response<dynamic> response = await apiClient.post(
        ApiEndpoints.verify,
        data: request.toJson(),
      );
      return Success(
        data: VerifyAccountResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    }
  }

  @override
  Future<ApiResult<UserProfileResponse>> getUserProfile() async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get User Profile API Call:');
      print('   Endpoint: ${ApiEndpoints.userProfile}');

      final response = await apiClient.get(ApiEndpoints.userProfile);

      print('✅ Get User Profile Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: UserProfileResponse.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      print('❌ Get User Profile Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get User Profile Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');

      return ApiFailure(
        error: ApiExceptions.errorResponse(
          error: 'Failed to fetch user profile: ${e.toString()}',
        ),
        statusCode: -1,
      );
    }
  }

  @override
  Future<ApiResult<ResetEmailResponse>> resetEmail(
    ResetEmailRequest request,
  ) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Reset Email API Call:');
      print('   Endpoint: ${ApiEndpoints.resetEmail}');
      print('   Email: ${request.email}');

      final response = await apiClient.post(
        ApiEndpoints.resetEmail,
        data: request.toJson(),
      );

      print('✅ Reset Email Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: ResetEmailResponse.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      print('❌ Reset Email Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Reset Email Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');

      return ApiFailure(
        error: ApiExceptions.errorResponse(
          error: 'Failed to send reset email: ${e.toString()}',
        ),
        statusCode: -1,
      );
    }
  }

  @override
  Future<ApiResult<PasswordResetResponse>> resetPassword(
    PasswordResetRequest request,
  ) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Password Reset API Call:');
      print('   Endpoint: ${ApiEndpoints.passwordReset}');
      print('   Email: ${request.email}');

      final response = await apiClient.post(
        ApiEndpoints.passwordReset,
        data: request.toJson(),
      );

      print('✅ Password Reset Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: PasswordResetResponse.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      print('❌ Password Reset Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Password Reset Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');

      return ApiFailure(
        error: ApiExceptions.errorResponse(
          error: 'Failed to reset password: ${e.toString()}',
        ),
        statusCode: -1,
      );
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref);
});
