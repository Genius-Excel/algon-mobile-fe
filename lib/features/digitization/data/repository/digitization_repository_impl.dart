import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../models/digitization_application_models.dart';
import 'digitization_repository.dart';

class DigitizationRepositoryImpl implements DigitizationRepository {
  final Ref ref;

  DigitizationRepositoryImpl(this.ref);

  @override
  Future<ApiResult<DigitizationApplicationResponse>>
      createDigitizationApplication(
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

      print('🚀 Create Digitization Application API Call:');
      print('   Endpoint: ${ApiEndpoints.digitizationApplication}');
      print('   FormData keys: ${formData.keys}');
      print('   Files: ${files.map((e) => e.key).toList()}');

      final response = await dio.post(
        ApiEndpoints.digitizationApplication,
        data: formDataToSend,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print('✅ Create Digitization Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: DigitizationApplicationResponse.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      print('❌ Create Digitization Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Create Digitization Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }
}

final digitizationRepositoryImplProvider =
    Provider<DigitizationRepository>((ref) {
  return DigitizationRepositoryImpl(ref);
});

