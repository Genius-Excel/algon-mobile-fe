import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service_result/api_result.dart';
import '../../../application/data/models/application_list_models.dart';
import '../models/admin_dashboard_models.dart';
import '../models/lga_fee_models.dart';
import '../models/admin_application_models.dart';
import '../models/admin_reports_models.dart';
import 'admin_repository_impl.dart';

abstract class AdminRepository {
  Future<ApiResult<AdminDashboardResponse>> getDashboard();
  Future<ApiResult<LGAFeeResponse>> getLgaFee();
  Future<ApiResult<LGAFeeData>> createOrUpdateLgaFee(
    CreateLGAFeeRequest request,
  );
  Future<ApiResult<ApplicationListResponse>> getApplications({
    required String applicationType,
    int limit = 20,
    int offset = 0,
  });

  // Make sure this method is declared here:
  Future<ApiResult<ApplicationItem>> getApplicationDetails({
    required String applicationId,
    required String applicationType,
  });

  Future<ApiResult<UpdateApplicationStatusResponse>> updateApplicationStatus({
    required String applicationId,
    required String applicationType,
    required String action,
  });

  Future<ApiResult<AdminReportsResponse>> getReportAnalytics();

  Future<ApiResult<String>> exportCsv({required String type});
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref);
});
