import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service_result/api_result.dart';
import '../models/audit_log_models.dart';
import '../models/dashboard_models.dart';
import '../models/invite_lg_admin_models.dart';
import 'super_admin_repository_impl.dart';

abstract class SuperAdminRepository {
  Future<ApiResult<InviteLGAdminResponse>> inviteLGAdmin(
    InviteLGAdminRequest request,
  );

  Future<ApiResult<AuditLogListResponse>> getAuditLogs({
    int? page,
    int? pageSize,
    String? actionType,
    String? tableName,
    String? user,
  });

  Future<ApiResult<AuditLogItem>> getAuditLogById(String id);

  Future<ApiResult<DashboardResponse>> getDashboard();
}

final superAdminRepositoryProvider = Provider<SuperAdminRepository>((ref) {
  return SuperAdminRepositoryImpl(ref);
});
