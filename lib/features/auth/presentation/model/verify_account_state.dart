import '../../../auth/data/models/verify_account_models.dart';

class VerifyAccountState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final VerifyAccountResponse? response;

  const VerifyAccountState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.response,
  });

  VerifyAccountState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    VerifyAccountResponse? response,
  }) {
    return VerifyAccountState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      response: response ?? this.response,
    );
  }
}
