import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/models/verify_account_models.dart';
import '../../../auth/domain/usecase/verify_account_usecase.dart';
import '../model/verify_account_state.dart';

class VerifyAccountViewModel extends StateNotifier<VerifyAccountState> {
  final VerifyAccountUseCase useCase;

  VerifyAccountViewModel(this.useCase) : super(const VerifyAccountState());

  Future<void> verifyAccount(VerifyAccountRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await useCase.execute(request);
    state = result.when(
      success: (data) => state.copyWith(
        isLoading: false,
        isSuccess: true,
        response: data,
      ),
      apiFailure: (error, statusCode) => state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      ),
    );
  }
}
