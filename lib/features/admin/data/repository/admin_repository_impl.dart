import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../../../application/data/models/application_list_models.dart';
import '../models/admin_dashboard_models.dart';
import '../models/lga_fee_models.dart';
import '../models/admin_application_models.dart';
import 'admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final Ref ref;

  AdminRepositoryImpl(this.ref);

  @override
  Future<ApiResult<AdminDashboardResponse>> getDashboard() async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get Admin Dashboard API Call:');
      print('   Endpoint: ${ApiEndpoints.adminDashboard}');

      final response = await apiClient.get(ApiEndpoints.adminDashboard);

      print('✅ Get Admin Dashboard Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: AdminDashboardResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get Admin Dashboard Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get Admin Dashboard Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<LGAFeeResponse>> getLgaFee() async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get LGA Fee API Call:');
      print('   Endpoint: ${ApiEndpoints.lgaFee}');

      final response = await apiClient.get(ApiEndpoints.lgaFee);

      print('✅ Get LGA Fee Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: LGAFeeResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get LGA Fee Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get LGA Fee Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<LGAFeeData>> createOrUpdateLgaFee(
    CreateLGAFeeRequest request,
  ) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Create/Update LGA Fee API Call:');
      print('   Endpoint: ${ApiEndpoints.lgaFee}');
      print('   Application Fee: ${request.applicationFee}');
      print('   Digitization Fee: ${request.digitizationFee}');
      print('   Regeneration Fee: ${request.regenerationFee}');

      final response = await apiClient.post(
        ApiEndpoints.lgaFee,
        data: request.toJson(),
      );

      print('✅ Create/Update LGA Fee Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      // Response can be either a single object or wrapped in a response
      final responseData = response.data as Map<String, dynamic>;
      LGAFeeData feeData;

      // Check if response has a 'data' field (wrapped) or is the data directly
      if (responseData.containsKey('data')) {
        final dataField = responseData['data'];
        if (dataField is List && dataField.isNotEmpty) {
          feeData = LGAFeeData.fromJson(dataField[0] as Map<String, dynamic>);
        } else if (dataField is Map<String, dynamic>) {
          feeData = LGAFeeData.fromJson(dataField);
        } else {
          feeData = LGAFeeData.fromJson(responseData);
        }
      } else {
        feeData = LGAFeeData.fromJson(responseData);
      }

      return Success(data: feeData);
    } on DioException catch (e) {
      print('❌ Create/Update LGA Fee Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Create/Update LGA Fee Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<ApplicationListResponse>> getApplications({
    required String applicationType,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get Admin Applications API Call:');
      print('   Endpoint: ${ApiEndpoints.adminApplications(applicationType)}');
      print('   Limit: $limit, Offset: $offset');

      final response = await apiClient.get(
        ApiEndpoints.adminApplications(applicationType),
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      print('✅ Get Admin Applications Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: ApplicationListResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get Admin Applications Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get Admin Applications Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<UpdateApplicationStatusResponse>> updateApplicationStatus({
    required String applicationId,
    required String applicationType,
    required String action,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Update Application Status API Call:');
      print('   Endpoint: ${ApiEndpoints.updateApplicationStatus(applicationId, applicationType)}');
      print('   Action: $action');

      final request = UpdateApplicationStatusRequest(
        applicationType: applicationType,
        action: action,
      );

      final response = await apiClient.patch(
        ApiEndpoints.updateApplicationStatus(applicationId, applicationType),
        data: request.toJson(),
      );

      print('✅ Update Application Status Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: UpdateApplicationStatusResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Update Application Status Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Update Application Status Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }
}

