import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service_result/api_result.dart';
import '../models/application_list_models.dart';
import '../models/certificate_application_models.dart';
import '../models/states_models.dart';
import '../models/update_application_models.dart';
import 'application_repository_impl.dart';

abstract class ApplicationRepository {
  Future<ApiResult<CertificateApplicationResponse>> createCertificateApplication(
    Map<String, dynamic> formData,
    List<MapEntry<String, String>> files,
  );

  Future<ApiResult<UpdateApplicationResponse>> updateCertificateApplication(
    String applicationId,
    Map<String, dynamic> formData,
    List<MapEntry<String, String>> files,
  );

  Future<ApiResult<ApplicationListResponse>> getMyApplications({
    String? applicationType,
  });

  Future<ApiResult<void>> verifyNin(
    String id,
    String type,
  );

  Future<ApiResult<StatesResponse>> getAllStates();
}

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepositoryImpl(ref);
});

