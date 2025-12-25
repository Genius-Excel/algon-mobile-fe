import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/admin/presentation/screens/admin_application_detail_screen.dart';
import '../../features/admin/presentation/screens/admin_applications_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_reports_screen.dart';
import '../../features/admin/presentation/screens/admin_settings_screen.dart';
import '../../features/super_admin/presentation/screens/super_admin_screens.dart';
import '../../features/super_admin/presentation/screens/full_screen_map_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/application/presentation/screens/new_application_step1_screen.dart';
import '../../features/application/presentation/screens/new_application_step2_screen.dart';
import '../../features/application/presentation/screens/new_application_step3_screen.dart';
import '../../features/application/presentation/screens/new_application_step4_screen.dart';
import '../../features/auth/presentation/screens/screens.dart';
import '../../features/digitization/presentation/screens/digitization_screens.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/verify/presentation/screens/verify_screens.dart';
import '../../features/onboarding/presentation/screens/onboarding_screens.dart';
import '../../features/onboarding/presentation/screens/first_onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/tracking/presentation/screens/tracking_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class HelperrRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(page: Splash.page, path: '/', initial: true),
        AutoRoute(page: FirstOnboarding.page, path: '/onboarding/first'),
        AutoRoute(page: SecondOnboarding.page, path: '/onboarding/second'),
        AutoRoute(page: ThirdOnboarding.page, path: '/onboarding/third'),
        AutoRoute(page: Login.page, path: '/login'),
        AutoRoute(page: SignUp.page, path: '/signup'),
        AutoRoute(
            page: ForgotPasswordStep1.page, path: '/forgot-password/step1'),
        AutoRoute(
            page: ForgotPasswordStep2.page, path: '/forgot-password/step2'),
        AutoRoute(
            page: ForgotPasswordStep3.page, path: '/forgot-password/step3'),
        AutoRoute(page: Home.page, path: '/home'),
        AutoRoute(page: Tracking.page, path: '/tracking'),
        AutoRoute(page: Alerts.page, path: '/alerts'),
        AutoRoute(page: Profile.page, path: '/profile'),
        AutoRoute(page: NewApplicationStep1.page, path: '/application/step1'),
        AutoRoute(page: NewApplicationStep2.page, path: '/application/step2'),
        AutoRoute(page: NewApplicationStep3.page, path: '/application/step3'),
        AutoRoute(page: NewApplicationStep4.page, path: '/application/step4'),
        AutoRoute(page: DigitizationStep1.page, path: '/digitization/step1'),
        AutoRoute(page: DigitizationStep2.page, path: '/digitization/step2'),
        AutoRoute(page: DigitizationStep3.page, path: '/digitization/step3'),
        AutoRoute(page: DigitizationStep4.page, path: '/digitization/step4'),
        AutoRoute(page: VerifyCertificate.page, path: '/verify/certificate'),
        AutoRoute(page: AdminDashboard.page, path: '/admin/dashboard'),
        AutoRoute(page: AdminApplications.page, path: '/admin/applications'),
        AutoRoute(
            page: AdminApplicationDetail.page,
            path: '/admin/application/detail'),
        AutoRoute(page: AdminReports.page, path: '/admin/reports'),
        AutoRoute(page: AdminSettings.page, path: '/admin/settings'),
        AutoRoute(
            page: SuperAdminDashboard.page, path: '/super-admin/dashboard'),
        AutoRoute(
            page: SystemSettings.page, path: '/super-admin/system-settings'),
        AutoRoute(page: ManageLGAdmins.page, path: '/super-admin/manage-lgas'),
        AutoRoute(page: AuditLog.page, path: '/super-admin/audit-log'),
        AutoRoute(page: FullScreenMap.page, path: '/super-admin/map'),
      ];
}
