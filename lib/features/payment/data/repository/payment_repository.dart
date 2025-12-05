import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service_result/api_result.dart';
import '../models/payment_models.dart';
import 'payment_repository_impl.dart';

abstract class PaymentRepository {
  Future<ApiResult<InitiatePaymentResponse>> initiatePayment(
    String applicationId,
    String paymentType, {
    int? amount,
  });
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(ref);
});

