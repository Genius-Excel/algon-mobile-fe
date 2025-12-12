import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/dependency_injection/di_providers.dart';
import '../../../../core/service_exceptions/api_exceptions.dart';
import '../../../../core/service_result/api_result.dart';
import '../models/audit_log_models.dart';
import '../models/dashboard_models.dart';
import '../models/invite_lg_admin_models.dart';
import '../models/lg_admin_list_models.dart';
import 'super_admin_repository.dart';

class SuperAdminRepositoryImpl implements SuperAdminRepository {
  final Ref ref;

  SuperAdminRepositoryImpl(this.ref);

  @override
  Future<ApiResult<InviteLGAdminResponse>> inviteLGAdmin(
    InviteLGAdminRequest request,
  ) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Invite LG Admin API Call:');
      print('   Endpoint: ${ApiEndpoints.inviteLGAdmin}');
      print('   State: ${request.state}');
      print('   LGA: ${request.lga}');
      print('   Full Name: ${request.fullName}');
      print('   Email: ${request.email}');

      final response = await apiClient.post(
        ApiEndpoints.inviteLGAdmin,
        data: request.toJson(),
      );

      print('✅ Invite LG Admin Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: InviteLGAdminResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Invite LG Admin Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Invite LG Admin Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<LGAdminListResponse>> getLGAdmins({
    String? search,
    String? state,
    String? lga,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (state != null && state.isNotEmpty) {
        queryParams['state'] = state;
      }
      if (lga != null && lga.isNotEmpty) {
        queryParams['lga'] = lga;
      }

      print('🚀 Get LG Admins API Call:');
      print('   Endpoint: ${ApiEndpoints.listLGAdmins}');
      print('   Query Params: $queryParams');

      final response = await apiClient.get(
        ApiEndpoints.listLGAdmins,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      print('✅ Get LG Admins Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: LGAdminListResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get LG Admins Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get LG Admins Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<AuditLogListResponse>> getAuditLogs({
    int? page,
    int? pageSize,
    String? actionType,
    String? tableName,
    String? user,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['page_size'] = pageSize;
      if (actionType != null) queryParams['action_type'] = actionType;
      if (tableName != null) queryParams['table_name'] = tableName;
      if (user != null) queryParams['user'] = user;

      print('🚀 Get Audit Logs API Call:');
      print('   Endpoint: ${ApiEndpoints.auditLogs}');
      print('   Query Params: $queryParams');

      final response = await apiClient.get(
        ApiEndpoints.auditLogs,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      print('✅ Get Audit Logs Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: AuditLogListResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get Audit Logs Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get Audit Logs Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<AuditLogItem>> getAuditLogById(String id) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get Audit Log by ID API Call:');
      print('   Endpoint: ${ApiEndpoints.auditLog(id)}');
      print('   ID: $id');

      final response = await apiClient.get(ApiEndpoints.auditLog(id));

      print('✅ Get Audit Log by ID Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: AuditLogItem.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get Audit Log by ID Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get Audit Log by ID Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ApiResult<DashboardResponse>> getDashboard() async {
    try {
      final apiClient = ref.read(apiClientProvider);

      print('🚀 Get Super Admin Dashboard API Call:');
      print('   Endpoint: ${ApiEndpoints.superAdminDashboard}');

      final response = await apiClient.get(ApiEndpoints.superAdminDashboard);

      print('✅ Get Dashboard Response Status: ${response.statusCode}');
      print('   Response Data: ${response.data}');

      return Success(
        data: DashboardResponse.fromJson(
            response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('❌ Get Dashboard Error:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');

      return ApiFailure(
        error: ApiExceptions.getDioException(e)!,
        statusCode: e.response?.statusCode ?? -1,
      );
    } catch (e, stackTrace) {
      print('❌ Unexpected Get Dashboard Error:');
      print('   Error: $e');
      print('   StackTrace: $stackTrace');
      rethrow;
    }
  }
}

