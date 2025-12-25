import '../../../../core/service_result/api_result.dart';
import '../models/forgot_password_models.dart';
import '../models/login_models.dart';
import '../models/register_models.dart';
import '../models/user_profile_models.dart';
import '../models/verify_account_models.dart';

abstract class AuthRepository {
  Future<ApiResult<LoginResponse>> login(LoginRequest request);

  Future<ApiResult<LoginResponse>> refreshToken(String refreshToken);

  Future<ApiResult<RegisterResponse>> register(
    RegisterRequest request,
    String role,
  );

  Future<ApiResult<VerifyAccountResponse>> verifyAccount(
    VerifyAccountRequest request,
  );

  Future<ApiResult<UserProfileResponse>> getUserProfile();

  Future<ApiResult<ResetEmailResponse>> resetEmail(ResetEmailRequest request);

  Future<ApiResult<PasswordResetResponse>> resetPassword(
    PasswordResetRequest request,
  );
}
