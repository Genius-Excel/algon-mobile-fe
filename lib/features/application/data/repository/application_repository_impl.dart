import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../models/application_list_models.dart';
import '../models/certificate_application_models.dart';
import '../models/states_models.dart' as states_models;
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

      final formDataToSend = FormData();

      // Add regular form fields
      for (final entry in formData.entries) {
        if (entry.key == 'extra_fields' && entry.value is List) {
          // Convert extra_fields list to JSON string
          final extraFieldsJson = jsonEncode(entry.value);
          formDataToSend.fields.add(MapEntry(entry.key, extraFieldsJson));
        } else {
          formDataToSend.fields
              .add(MapEntry(entry.key, entry.value.toString()));
        }
      }

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
      print(
          '   Endpoint: ${ApiEndpoints.updateCertificateApplication(applicationId)}');
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

  Future<ApiResult<ApplicationItem>> getApplicationDetails({
    required String applicationId,
    required String applicationType,
  }) async {
    try {
      print('🚀 Get Application Details API Call:');
      print('   Application ID: $applicationId');
      print('   Application Type: $applicationType');

 
      final apiClient = ref.read(apiClientProvider);

      final response = await apiClient.get(
        '/admin/applications/$applicationId',
        queryParameters: {'application_type': applicationType},
      );

      print(
          '✅ Get Application Details Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      final responseData = response.data as Map<String, dynamic>;

      // Parse the response
      ApplicationItem application;

      if (responseData.containsKey('data')) {
        // Response has {message, data} structure
        application = ApplicationItem.fromJson(responseData['data']);
      } else {
        // Direct application object
        application = ApplicationItem.fromJson(responseData);
      }

       return Success(data: application);
    } on DioException catch (e) {
      print('❌ Get Application Details Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get Application Details Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: -1,
      );
    }
  }

  @override
  Future<ApiResult<ApplicationListResponse>> getMyApplications({
    String? applicationType,
    int? limit,
    int? offset,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get My Applications API Call:');
      print('   Endpoint: ${ApiEndpoints.myApplications}');
      print('   Limit: $limit, Offset: $offset');

      final response = await apiClient.get(
        ApiEndpoints.myApplications,
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (applicationType != null) 'application_type': applicationType,
        },
      );

      print('✅ Get My Applications Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: ApplicationListResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get My Applications Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get My Applications Error:');
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
  Future<ApiResult<states_models.StatesResponse>> getAllStates() async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get All States API Call:');
      print('   Endpoint: ${ApiEndpoints.allStates}');

      // Fetch all states by requesting a large page size or all pages
      final response = await apiClient.get(
        ApiEndpoints.allStates,
        queryParameters: {
          'page_size': 1000, // Request a large page size to get all states
        },
      );

      print('✅ Get All States Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');
      print('   Response Data Type: ${response.data.runtimeType}');

      final responseData = response.data as Map<String, dynamic>;
      List<Map<String, dynamic>> allStatesJson = [];

      // Handle paginated response structure: {message: "...", data: {count, next, previous, results: [...]}}
      if (responseData.containsKey('data')) {
        final dataValue = responseData['data'];

        if (dataValue is Map) {
          final dataMap = dataValue as Map<String, dynamic>;
          print('   Data is a Map, checking for pagination structure...');
          print('   Data Map Keys: ${dataMap.keys.toList()}');
          print('   Count: ${dataMap['count']}');
          print('   Next: ${dataMap['next']}');
          print('   Previous: ${dataMap['previous']}');

          // Check for paginated response with 'results' key (most common)
          if (dataMap.containsKey('results') && dataMap['results'] is List) {
            final results = dataMap['results'] as List;
            print('   Found ${results.length} states in results');

            // Store first page results as raw JSON maps (don't parse yet)
            for (final item in results) {
              if (item is Map<String, dynamic>) {
                allStatesJson.add(item);
              }
            }

            // If there's a next page, fetch all remaining pages
            String? nextUrl = dataMap['next']?.toString();
            int page = 2; // Start from page 2 since we already have page 1

            while (nextUrl != null && nextUrl.isNotEmpty) {
              print('   Fetching page $page: $nextUrl');
              try {
                // Use Dio directly to handle full URLs or relative paths
                final dio = ref.read(dioProvider);
                final nextResponse = await dio.get(nextUrl);
                final nextData = nextResponse.data as Map<String, dynamic>;

                if (nextData.containsKey('data')) {
                  final nextDataValue = nextData['data'];
                  if (nextDataValue is Map) {
                    final nextDataMap = nextDataValue as Map<String, dynamic>;
                    if (nextDataMap.containsKey('results') &&
                        nextDataMap['results'] is List) {
                      final nextResults = nextDataMap['results'] as List;
                      print('   Found ${nextResults.length} more states');

                      // Store next page results as raw JSON maps (don't parse yet)
                      for (final item in nextResults) {
                        if (item is Map<String, dynamic>) {
                          allStatesJson.add(item);
                        }
                      }
                    }
                    nextUrl = nextDataMap['next']?.toString();
                    page++;

                    // Safety check: limit to 50 pages max (should be more than enough for all Nigerian states)
                    if (page > 50) {
                      print(
                          '   ⚠️ Reached maximum page limit (50), stopping pagination');
                      break;
                    }
                  } else {
                    break;
                  }
                } else {
                  break;
                }
              } catch (e) {
                print('   ⚠️ Error fetching next page: $e');
                break;
              }
            }

            responseData['data'] = allStatesJson;
            print('   Total states fetched: ${allStatesJson.length}');
          }
          // Check if there's a nested 'states' key
          else if (dataMap.containsKey('states') && dataMap['states'] is List) {
            responseData['data'] = dataMap['states'];
            print('   Found nested "states" key, using it as data');
          }
          // Check if there's a nested 'data' key
          else if (dataMap.containsKey('data') && dataMap['data'] is List) {
            responseData['data'] = dataMap['data'];
            print('   Found nested "data" key, using it as data');
          }
          // If data is a single state object, wrap it in a list
          else if (dataMap.containsKey('id') && dataMap.containsKey('name')) {
            responseData['data'] = [dataMap];
            print(
                '   Data appears to be a single state object, wrapping in list');
          }
          // Fallback: wrap the whole object (shouldn't happen)
          else {
            responseData['data'] = [dataMap];
            print('   ⚠️ Unknown structure, wrapping data map in list');
          }
        } else if (dataValue is List) {
          // Data is already a list, use it directly
          print('   Data is already a List, using directly');
          responseData['data'] = dataValue;
        } else {
          print('   ⚠️ Data is neither Map nor List: ${dataValue.runtimeType}');
          // Try to convert to list if possible
          responseData['data'] = [dataValue];
        }
      }

      try {
        return Success(
          data: states_models.StatesResponse.fromJson(responseData),
        );
      } catch (e, stackTrace) {
        print('❌ Error parsing StatesResponse:');
        print('   Error: $e');
        print('   Response Data Structure: $responseData');
        print('   StackTrace: $stackTrace');
        rethrow;
      }
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
