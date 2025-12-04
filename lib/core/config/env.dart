enum AppEnv { dev, prod }

class AppConfig {
  final String baseUrl;

  const AppConfig({required this.baseUrl});
}

AppConfig configFor(AppEnv env) {
  switch (env) {
    case AppEnv.dev:
      return const AppConfig(baseUrl: 'https://algon-be.geniusexcel.tech/api/');
    case AppEnv.prod:
      return const AppConfig(baseUrl: 'https://algon-be.geniusexcel.tech/api/');
  }
}
