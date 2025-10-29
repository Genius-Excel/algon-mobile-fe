import '../../../auth/data/models/verify_account_models.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../../../core/service_result/api_result.dart';

class VerifyAccountUseCase {
  final AuthRepository repository;
  VerifyAccountUseCase(this.repository);

  Future<ApiResult<VerifyAccountResponse>> execute(
    VerifyAccountRequest request,
  ) {
    return repository.verifyAccount(request);
  }
}
