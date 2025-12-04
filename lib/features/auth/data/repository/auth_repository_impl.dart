import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../models/login_models.dart';
import '../models/register_models.dart';
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
      return Success(
        data: LoginResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
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
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref);
});

