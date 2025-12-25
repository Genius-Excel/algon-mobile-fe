// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [AdminApplicationDetailScreen]
class AdminApplicationDetail extends PageRouteInfo<void> {
  const AdminApplicationDetail({List<PageRouteInfo>? children})
      : super(
          AdminApplicationDetail.name,
          initialChildren: children,
        );

  static const String name = 'AdminApplicationDetail';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdminApplicationDetailScreen();
    },
  );
}

/// generated route for
/// [AdminApplicationsScreen]
class AdminApplications extends PageRouteInfo<void> {
  const AdminApplications({List<PageRouteInfo>? children})
      : super(
          AdminApplications.name,
          initialChildren: children,
        );

  static const String name = 'AdminApplications';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdminApplicationsScreen();
    },
  );
}

/// generated route for
/// [AdminDashboardScreen]
class AdminDashboard extends PageRouteInfo<void> {
  const AdminDashboard({List<PageRouteInfo>? children})
      : super(
          AdminDashboard.name,
          initialChildren: children,
        );

  static const String name = 'AdminDashboard';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdminDashboardScreen();
    },
  );
}

/// generated route for
/// [AdminReportsScreen]
class AdminReports extends PageRouteInfo<void> {
  const AdminReports({List<PageRouteInfo>? children})
      : super(
          AdminReports.name,
          initialChildren: children,
        );

  static const String name = 'AdminReports';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdminReportsScreen();
    },
  );
}

/// generated route for
/// [AdminSettingsScreen]
class AdminSettings extends PageRouteInfo<AdminSettingsArgs> {
  AdminSettings({
    Key? key,
    bool isSuperAdmin = false,
    List<PageRouteInfo>? children,
  }) : super(
          AdminSettings.name,
          args: AdminSettingsArgs(
            key: key,
            isSuperAdmin: isSuperAdmin,
          ),
          initialChildren: children,
        );

  static const String name = 'AdminSettings';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminSettingsArgs>(
          orElse: () => const AdminSettingsArgs());
      return AdminSettingsScreen(
        key: args.key,
        isSuperAdmin: args.isSuperAdmin,
      );
    },
  );
}

class AdminSettingsArgs {
  const AdminSettingsArgs({
    this.key,
    this.isSuperAdmin = false,
  });

  final Key? key;

  final bool isSuperAdmin;

  @override
  String toString() {
    return 'AdminSettingsArgs{key: $key, isSuperAdmin: $isSuperAdmin}';
  }
}

/// generated route for
/// [AlertsScreen]
class Alerts extends PageRouteInfo<void> {
  const Alerts({List<PageRouteInfo>? children})
      : super(
          Alerts.name,
          initialChildren: children,
        );

  static const String name = 'Alerts';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AlertsScreen();
    },
  );
}

/// generated route for
/// [AuditLogScreen]
class AuditLog extends PageRouteInfo<void> {
  const AuditLog({List<PageRouteInfo>? children})
      : super(
          AuditLog.name,
          initialChildren: children,
        );

  static const String name = 'AuditLog';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuditLogScreen();
    },
  );
}

/// generated route for
/// [DigitizationStep1Screen]
class DigitizationStep1 extends PageRouteInfo<void> {
  const DigitizationStep1({List<PageRouteInfo>? children})
      : super(
          DigitizationStep1.name,
          initialChildren: children,
        );

  static const String name = 'DigitizationStep1';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DigitizationStep1Screen();
    },
  );
}

/// generated route for
/// [DigitizationStep2Screen]
class DigitizationStep2 extends PageRouteInfo<void> {
  const DigitizationStep2({List<PageRouteInfo>? children})
      : super(
          DigitizationStep2.name,
          initialChildren: children,
        );

  static const String name = 'DigitizationStep2';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DigitizationStep2Screen();
    },
  );
}

/// generated route for
/// [DigitizationStep3Screen]
class DigitizationStep3 extends PageRouteInfo<void> {
  const DigitizationStep3({List<PageRouteInfo>? children})
      : super(
          DigitizationStep3.name,
          initialChildren: children,
        );

  static const String name = 'DigitizationStep3';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DigitizationStep3Screen();
    },
  );
}

/// generated route for
/// [DigitizationStep4Screen]
class DigitizationStep4 extends PageRouteInfo<void> {
  const DigitizationStep4({List<PageRouteInfo>? children})
      : super(
          DigitizationStep4.name,
          initialChildren: children,
        );

  static const String name = 'DigitizationStep4';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DigitizationStep4Screen();
    },
  );
}

/// generated route for
/// [FirstOnboardingScreen]
class FirstOnboarding extends PageRouteInfo<void> {
  const FirstOnboarding({List<PageRouteInfo>? children})
      : super(
          FirstOnboarding.name,
          initialChildren: children,
        );

  static const String name = 'FirstOnboarding';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FirstOnboardingScreen();
    },
  );
}

/// generated route for
/// [ForgotPasswordStep1Screen]
class ForgotPasswordStep1 extends PageRouteInfo<void> {
  const ForgotPasswordStep1({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordStep1.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordStep1';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordStep1Screen();
    },
  );
}

/// generated route for
/// [ForgotPasswordStep2Screen]
class ForgotPasswordStep2 extends PageRouteInfo<ForgotPasswordStep2Args> {
  ForgotPasswordStep2({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
          ForgotPasswordStep2.name,
          args: ForgotPasswordStep2Args(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordStep2';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ForgotPasswordStep2Args>();
      return ForgotPasswordStep2Screen(
        key: args.key,
        email: args.email,
      );
    },
  );
}

class ForgotPasswordStep2Args {
  const ForgotPasswordStep2Args({
    this.key,
    required this.email,
  });

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'ForgotPasswordStep2Args{key: $key, email: $email}';
  }
}

/// generated route for
/// [ForgotPasswordStep3Screen]
class ForgotPasswordStep3 extends PageRouteInfo<ForgotPasswordStep3Args> {
  ForgotPasswordStep3({
    Key? key,
    required String email,
    required String otp,
    List<PageRouteInfo>? children,
  }) : super(
          ForgotPasswordStep3.name,
          args: ForgotPasswordStep3Args(
            key: key,
            email: email,
            otp: otp,
          ),
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordStep3';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ForgotPasswordStep3Args>();
      return ForgotPasswordStep3Screen(
        key: args.key,
        email: args.email,
        otp: args.otp,
      );
    },
  );
}

class ForgotPasswordStep3Args {
  const ForgotPasswordStep3Args({
    this.key,
    required this.email,
    required this.otp,
  });

  final Key? key;

  final String email;

  final String otp;

  @override
  String toString() {
    return 'ForgotPasswordStep3Args{key: $key, email: $email, otp: $otp}';
  }
}

/// generated route for
/// [FullScreenMapScreen]
class FullScreenMap extends PageRouteInfo<void> {
  const FullScreenMap({List<PageRouteInfo>? children})
      : super(
          FullScreenMap.name,
          initialChildren: children,
        );

  static const String name = 'FullScreenMap';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FullScreenMapScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class Home extends PageRouteInfo<void> {
  const Home({List<PageRouteInfo>? children})
      : super(
          Home.name,
          initialChildren: children,
        );

  static const String name = 'Home';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class Login extends PageRouteInfo<void> {
  const Login({List<PageRouteInfo>? children})
      : super(
          Login.name,
          initialChildren: children,
        );

  static const String name = 'Login';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [ManageLGAdminsScreen]
class ManageLGAdmins extends PageRouteInfo<void> {
  const ManageLGAdmins({List<PageRouteInfo>? children})
      : super(
          ManageLGAdmins.name,
          initialChildren: children,
        );

  static const String name = 'ManageLGAdmins';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManageLGAdminsScreen();
    },
  );
}

/// generated route for
/// [NewApplicationStep1Screen]
class NewApplicationStep1 extends PageRouteInfo<void> {
  const NewApplicationStep1({List<PageRouteInfo>? children})
      : super(
          NewApplicationStep1.name,
          initialChildren: children,
        );

  static const String name = 'NewApplicationStep1';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewApplicationStep1Screen();
    },
  );
}

/// generated route for
/// [NewApplicationStep2Screen]
class NewApplicationStep2 extends PageRouteInfo<void> {
  const NewApplicationStep2({List<PageRouteInfo>? children})
      : super(
          NewApplicationStep2.name,
          initialChildren: children,
        );

  static const String name = 'NewApplicationStep2';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewApplicationStep2Screen();
    },
  );
}

/// generated route for
/// [NewApplicationStep3Screen]
class NewApplicationStep3 extends PageRouteInfo<void> {
  const NewApplicationStep3({List<PageRouteInfo>? children})
      : super(
          NewApplicationStep3.name,
          initialChildren: children,
        );

  static const String name = 'NewApplicationStep3';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewApplicationStep3Screen();
    },
  );
}

/// generated route for
/// [NewApplicationStep4Screen]
class NewApplicationStep4 extends PageRouteInfo<void> {
  const NewApplicationStep4({List<PageRouteInfo>? children})
      : super(
          NewApplicationStep4.name,
          initialChildren: children,
        );

  static const String name = 'NewApplicationStep4';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewApplicationStep4Screen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class Profile extends PageRouteInfo<void> {
  const Profile({List<PageRouteInfo>? children})
      : super(
          Profile.name,
          initialChildren: children,
        );

  static const String name = 'Profile';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [SecondOnboardingScreen]
class SecondOnboarding extends PageRouteInfo<void> {
  const SecondOnboarding({List<PageRouteInfo>? children})
      : super(
          SecondOnboarding.name,
          initialChildren: children,
        );

  static const String name = 'SecondOnboarding';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SecondOnboardingScreen();
    },
  );
}

/// generated route for
/// [SignUpScreen]
class SignUp extends PageRouteInfo<void> {
  const SignUp({List<PageRouteInfo>? children})
      : super(
          SignUp.name,
          initialChildren: children,
        );

  static const String name = 'SignUp';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class Splash extends PageRouteInfo<void> {
  const Splash({List<PageRouteInfo>? children})
      : super(
          Splash.name,
          initialChildren: children,
        );

  static const String name = 'Splash';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [SuperAdminDashboardScreen]
class SuperAdminDashboard extends PageRouteInfo<void> {
  const SuperAdminDashboard({List<PageRouteInfo>? children})
      : super(
          SuperAdminDashboard.name,
          initialChildren: children,
        );

  static const String name = 'SuperAdminDashboard';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SuperAdminDashboardScreen();
    },
  );
}

/// generated route for
/// [SystemSettingsScreen]
class SystemSettings extends PageRouteInfo<void> {
  const SystemSettings({List<PageRouteInfo>? children})
      : super(
          SystemSettings.name,
          initialChildren: children,
        );

  static const String name = 'SystemSettings';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SystemSettingsScreen();
    },
  );
}

/// generated route for
/// [ThirdOnboardingScreen]
class ThirdOnboarding extends PageRouteInfo<void> {
  const ThirdOnboarding({List<PageRouteInfo>? children})
      : super(
          ThirdOnboarding.name,
          initialChildren: children,
        );

  static const String name = 'ThirdOnboarding';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ThirdOnboardingScreen();
    },
  );
}

/// generated route for
/// [TrackingScreen]
class Tracking extends PageRouteInfo<void> {
  const Tracking({List<PageRouteInfo>? children})
      : super(
          Tracking.name,
          initialChildren: children,
        );

  static const String name = 'Tracking';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TrackingScreen();
    },
  );
}

/// generated route for
/// [VerifyCertificateScreen]
class VerifyCertificate extends PageRouteInfo<void> {
  const VerifyCertificate({List<PageRouteInfo>? children})
      : super(
          VerifyCertificate.name,
          initialChildren: children,
        );

  static const String name = 'VerifyCertificate';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VerifyCertificateScreen();
    },
  );
}
