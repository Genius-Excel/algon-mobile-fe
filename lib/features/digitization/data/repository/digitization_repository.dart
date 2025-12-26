import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service_result/api_result.dart';
import '../models/digitization_application_models.dart';
import 'digitization_repository_impl.dart';

abstract class DigitizationRepository {
  Future<ApiResult<DigitizationApplicationResponse>>
      createDigitizationApplication(
    Map<String, dynamic> formData,
    List<MapEntry<String, String>> files,
  );
  
  Future<ApiResult<void>> verifyNin(
    String id,
    String type,
  );
}

final digitizationRepositoryProvider = Provider<DigitizationRepository>((ref) {
  return DigitizationRepositoryImpl(ref);
});

