import 'package:auto_route/auto_route.dart';

import '../../features/admin/presentation/screens/admin_application_detail_screen.dart';
import '../../features/admin/presentation/screens/admin_applications_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_reports_screen.dart';
import '../../features/admin/presentation/screens/admin_settings_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/application/presentation/screens/new_application_step1_screen.dart';
import '../../features/application/presentation/screens/new_application_step2_screen.dart';
import '../../features/application/presentation/screens/new_application_step3_screen.dart';
import '../../features/application/presentation/screens/new_application_step4_screen.dart';
import '../../features/auth/presentation/screens/screens.dart';
import '../../features/home/presentation/screens/home_screen.dart';
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
        // Splash (Initial)
        AutoRoute(page: Splash.page, path: '/', initial: true),

        // Onboarding
        AutoRoute(page: FirstOnboarding.page, path: '/onboarding/first'),
        AutoRoute(page: SecondOnboarding.page, path: '/onboarding/second'),
        AutoRoute(page: ThirdOnboarding.page, path: '/onboarding/third'),

        // Auth
        AutoRoute(page: Login.page, path: '/login'),
        AutoRoute(page: SignUp.page, path: '/signup'),

        // Main tabs
        AutoRoute(page: Home.page, path: '/home'),
        AutoRoute(page: Tracking.page, path: '/tracking'),
        AutoRoute(page: Alerts.page, path: '/alerts'),
        AutoRoute(page: Profile.page, path: '/profile'),

        // Application flow
        AutoRoute(
          page: NewApplicationStep1.page,
          path: '/application/step1',
        ),
        AutoRoute(
          page: NewApplicationStep2.page,
          path: '/application/step2',
        ),
        AutoRoute(
          page: NewApplicationStep3.page,
          path: '/application/step3',
        ),
        AutoRoute(
          page: NewApplicationStep4.page,
          path: '/application/step4',
        ),

        // LG Admin routes
        AutoRoute(
          page: AdminDashboard.page,
          path: '/admin/dashboard',
        ),
        AutoRoute(
          page: AdminApplications.page,
          path: '/admin/applications',
        ),
        AutoRoute(
          page: AdminApplicationDetail.page,
          path: '/admin/application/detail',
        ),
        AutoRoute(
          page: AdminReports.page,
          path: '/admin/reports',
        ),
        AutoRoute(
          page: AdminSettings.page,
          path: '/admin/settings',
        ),
      ];
}
