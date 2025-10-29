import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../services/api/api_client.dart';

final currentEnvProvider = Provider<AppEnv>((ref) => AppEnv.dev);

final appConfigProvider = Provider<AppConfig>((ref) {
  final env = ref.watch(currentEnvProvider);
  return configFor(env);
});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(LogInterceptor(responseBody: false));
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
