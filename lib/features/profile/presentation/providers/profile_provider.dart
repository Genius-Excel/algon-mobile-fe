import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/models/user_profile_models.dart';
import '../../../auth/data/repository/auth_repository_impl.dart';

final userProfileProvider = FutureProvider<UserProfileResponse?>((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  final result = await authRepository.getUserProfile();
  
  return result.when(
    success: (response) => response,
    apiFailure: (error, statusCode) {
      print('❌ Failed to fetch user profile: $error');
      return null;
    },
  );
});

