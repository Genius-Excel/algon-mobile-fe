import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service_result/api_result.dart';
import '../models/admin_dashboard_models.dart';
import '../models/lga_fee_models.dart';
import 'admin_repository_impl.dart';

abstract class AdminRepository {
  Future<ApiResult<AdminDashboardResponse>> getDashboard();
  Future<ApiResult<LGAFeeResponse>> getLgaFee();
  Future<ApiResult<LGAFeeData>> createOrUpdateLgaFee(
    CreateLGAFeeRequest request,
  );
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref);
});

