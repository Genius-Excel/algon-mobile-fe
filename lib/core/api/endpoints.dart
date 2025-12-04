class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static String register(String role) => '/register/$role';
  static const String verify = '/verify';
}
