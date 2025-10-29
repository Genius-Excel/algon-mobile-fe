import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../models/verify_account_models.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Ref ref;
  AuthRepositoryImpl(this.ref);

  @override
  Future<ApiResult<VerifyAccountResponse>> verifyAccount(
    VerifyAccountRequest request,
  ) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final Response<dynamic> response = await apiClient.post(
        '/verify',
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

final authRepositoryImplProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref);
});
