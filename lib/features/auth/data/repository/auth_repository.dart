import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service_result/api_result.dart';
import '../models/verify_account_models.dart';

abstract class AuthRepository {
  Future<ApiResult<VerifyAccountResponse>> verifyAccount(
    VerifyAccountRequest request,
  );
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('AuthRepository provider not overridden');
});
