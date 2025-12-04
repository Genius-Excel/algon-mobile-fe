import '../../../../core/service_result/api_result.dart';
import '../models/login_models.dart';
import '../models/register_models.dart';
import '../models/verify_account_models.dart';

abstract class AuthRepository {
  Future<ApiResult<LoginResponse>> login(LoginRequest request);
  
  Future<ApiResult<RegisterResponse>> register(
    RegisterRequest request,
    String role,
  );
  
  Future<ApiResult<VerifyAccountResponse>> verifyAccount(
    VerifyAccountRequest request,
  );
}
