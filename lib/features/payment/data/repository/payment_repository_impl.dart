import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../models/payment_models.dart';
import 'payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final Ref ref;

  PaymentRepositoryImpl(this.ref);

  @override
  Future<ApiResult<InitiatePaymentResponse>> initiatePayment(
    String applicationId,
    String paymentType, {
    int? amount,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      final request = InitiatePaymentRequest(
        paymentType: paymentType,
        applicationId: applicationId,
        amount: amount,
      );

      print('🚀 Initiate Payment API Call:');
      print('   Endpoint: ${ApiEndpoints.initiatePayment}');
      print('   Application ID: $applicationId');
      print('   Payment Type: $paymentType');
      if (amount != null) print('   Amount: $amount');

      final response = await apiClient.post(
        ApiEndpoints.initiatePayment,
        data: request.toJson(),
      );

      print('✅ Initiate Payment Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: InitiatePaymentResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Initiate Payment Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Initiate Payment Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }
}

