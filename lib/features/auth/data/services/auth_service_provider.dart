import 'package:algon_mobile/features/auth/data/repository/auth_repository_impl.dart';
import 'package:algon_mobile/features/auth/data/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthService(authRepository);
});

