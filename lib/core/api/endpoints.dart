class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static String register(String role) => '/register/$role';
  static const String verify = '/verify';

  // Certificate Application endpoints
  static const String certificateApplication =
      '/certificates/applications/apply';
  static String updateCertificateApplication(String applicationId) =>
      '/certificates/applications/apply/$applicationId';
  static const String myApplications = '/certificates/my-applications';

  // Digitization endpoints
  static const String digitizationApplication =
      '/certificate/digitizations/apply';

  // NIN Verification
  static String verifyNin(String id) => '/verify-nin/$id';

  // States and Local Governments
  static const String allStates = '/all-states';

  // Payment endpoints
  static const String initiatePayment = '/certificate/initiate-payment';

  // Super Admin endpoints
  static const String inviteLGAdmin = '/admin/super/invite-lg';
  static const String auditLogs = '/admin/super/audit-logs';
  static String auditLog(String id) => '/admin/super/audit-log/$id';
  static const String superAdminDashboard = '/admin/super/dashboard';
}
