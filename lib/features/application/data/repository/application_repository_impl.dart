import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../models/application_list_models.dart';
import '../models/certificate_application_models.dart';
import '../models/states_models.dart';
import '../models/update_application_models.dart';
import 'application_repository.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final Ref ref;

  ApplicationRepositoryImpl(this.ref);

  @override
  Future<ApiResult<CertificateApplicationResponse>>
      createCertificateApplication(
    Map<String, dynamic> formData,
    List<MapEntry<String, String>> files,
  ) async {
    try {
      final dio = ref.read(dioProvider);

      final formDataToSend = FormData.fromMap(formData);

      // Add files to FormData
      for (final fileEntry in files) {
        final filePath = fileEntry.value;
        final fileName = filePath.split('/').last;
        final file = File(filePath);
        if (await file.exists()) {
          formDataToSend.files.add(
            MapEntry(
              fileEntry.key,
              await MultipartFile.fromFile(filePath, filename: fileName),
            ),
          );
        }
      }

      print('🚀 Create Certificate Application API Call:');
      print('   Endpoint: ${ApiEndpoints.certificateApplication}');
      print('   FormData keys: ${formData.keys}');
      print('   Files: ${files.map((e) => e.key).toList()}');

      final response = await dio.post(
        ApiEndpoints.certificateApplication,
        data: formDataToSend,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print('✅ Create Application Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: CertificateApplicationResponse.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      print('❌ Create Application Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Create Application Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<UpdateApplicationResponse>> updateCertificateApplication(
    String applicationId,
    Map<String, dynamic> formData,
    List<MapEntry<String, String>> files,
  ) async {
    try {
      final dio = ref.read(dioProvider);

      final formDataToSend = FormData.fromMap(formData);

      // Add files to FormData
      for (final fileEntry in files) {
        final filePath = fileEntry.value;
        final fileName = filePath.split('/').last;
        final file = File(filePath);
        if (await file.exists()) {
          formDataToSend.files.add(
            MapEntry(
              fileEntry.key,
              await MultipartFile.fromFile(filePath, filename: fileName),
            ),
          );
        }
      }

      print('🚀 Update Certificate Application API Call:');
      print('   Endpoint: ${ApiEndpoints.updateCertificateApplication(applicationId)}');
      print('   Application ID: $applicationId');
      print('   FormData keys: ${formData.keys}');
      print('   Files: ${files.map((e) => e.key).toList()}');

      final response = await dio.patch(
        ApiEndpoints.updateCertificateApplication(applicationId),
        data: formDataToSend,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print('✅ Update Application Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: UpdateApplicationResponse.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      print('❌ Update Application Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Update Application Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<ApplicationListResponse>> getMyApplications({
    String? applicationType,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      final queryParams = <String, dynamic>{};
      if (applicationType != null) {
        queryParams['application_type'] = applicationType;
      }

      print('🚀 Get My Applications API Call:');
      print('   Endpoint: ${ApiEndpoints.myApplications}');
      print('   Query Params: $queryParams');

      final response = await apiClient.get(
        ApiEndpoints.myApplications,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      print('✅ Get Applications Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: ApplicationListResponse.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      print('❌ Get Applications Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get Applications Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<void>> verifyNin(String id, String type) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Verify NIN API Call:');
      print('   Endpoint: ${ApiEndpoints.verifyNin(id)}');
      print('   Type: $type');

      final response = await apiClient.get(
        ApiEndpoints.verifyNin(id),
        queryParameters: {'type': type},
      );

      print('✅ Verify NIN Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return const Success(data: null);
    } on DioException catch (e) {
      print('❌ Verify NIN Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Verify NIN Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<StatesResponse>> getAllStates() async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get All States API Call:');
      print('   Endpoint: ${ApiEndpoints.allStates}');

      final response = await apiClient.get(ApiEndpoints.allStates);

      print('✅ Get All States Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: StatesResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get All States Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get All States Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }
}

final applicationRepositoryImplProvider =
    Provider<ApplicationRepository>((ref) {
  return ApplicationRepositoryImpl(ref);
});

