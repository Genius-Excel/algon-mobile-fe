class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String userProfile = '/auth/me';
  static const String resetEmail = '/auth/reset-mail';
  static const String passwordReset = '/auth/mobile/password-reset/';
  static String register(String role) => '/register/$role';
  static const String verify = '/verify';

  static const String certificateApplication =
      '/certificates/applications/apply';
  static String updateCertificateApplication(String applicationId) =>
      '/certificates/applications/apply/$applicationId';
  static const String myApplications = '/certificates/my-applications';

  static const String digitizationApplication =
      '/certificate/digitizations/apply';

  static String verifyNin(String id) => '/verify-nin/$id';

  static const String allStates = '/all-states';

  static const String initiatePayment = '/certificate/initiate-payment';

  static const String inviteLGAdmin = '/admin/super/invite-lg';
  static const String listLGAdmins = '/admin/super/lgas';
  static const String auditLogs = '/admin/super/audit-logs';
  static String auditLog(String id) => '/admin/super/audit-log/$id';
  static const String superAdminDashboard = '/admin/super/dashboard';

  // LG Admin endpoints
  static const String adminDashboard = '/admin/dashboard';
  static const String lgaFee = '/application-fees/local-government';
  static const String adminReportAnalytics = '/admin/report-analytics';
  static String adminApplications(String applicationType) =>
      '/admin/applications?application_type=$applicationType';
  static String updateApplicationStatus(
          String applicationId, String applicationType) =>
      '/admin/applications/$applicationId?application_type=$applicationType';
}
