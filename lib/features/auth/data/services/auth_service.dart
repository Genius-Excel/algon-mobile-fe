import 'package:algon_mobile/core/enums/user_role.dart';
import 'package:algon_mobile/core/router/router.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/core/service_result/api_result.dart';
import 'package:algon_mobile/features/auth/data/models/login_models.dart';
import 'package:algon_mobile/features/auth/data/models/register_models.dart';
import 'package:algon_mobile/features/auth/data/repository/auth_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  /// Handles complete registration flow: register -> auto-login -> store tokens
  Future<ApiResult<AuthResult>> registerAndLogin({
    required RegisterRequest request,
    required String role,
  }) async {
    try {
      // Step 1: Register user
      final registerResult = await _authRepository.register(request, role);

      return registerResult.when(
        success: (RegisterResponse response) async {
          if (response.data.isEmpty) {
            return const ApiFailure(
              error: ApiExceptions.errorResponse(
                  error: 'Registration failed: No user data returned'),
              statusCode: -1,
            );
          }

          final registerData = response.data.first;
          final userRole = UserRole.fromApiRole(registerData.role);

          // Step 2: Auto-login after registration
          final loginRequest = LoginRequest(
            email: request.email,
            password: request.password,
          );

          final loginResult = await _authRepository.login(loginRequest);

          return loginResult.when(
            success: (LoginResponse loginResponse) async {
              // Step 3: Store tokens and user info
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('access_token', loginResponse.accessToken);
              await prefs.setString(
                  'refresh_token', loginResponse.refreshToken);
              await prefs.setString('user_id', loginResponse.userId);
              await prefs.setString('user_role', loginResponse.role);
              await prefs.setBool('isLoggedIn', true);

              // Step 4: Return success with navigation info
              return Success(
                data: AuthResult(
                  userRole: userRole,
                  message: response.message,
                ),
              );
            },
            apiFailure: (error, statusCode) {
              return ApiFailure(
                error: error,
                statusCode: statusCode,
              );
            },
          );
        },
        apiFailure: (error, statusCode) {
          return ApiFailure(
            error: error,
            statusCode: statusCode,
          );
        },
      );
    } catch (e) {
      return ApiFailure(
        error: ApiExceptions.errorResponse(
            error: 'Unexpected error: ${e.toString()}'),
        statusCode: -1,
      );
    }
  }

  /// Handles login flow: login -> store tokens -> return navigation info
  Future<ApiResult<AuthResult>> loginAndStore({
    required LoginRequest request,
  }) async {
    try {
      final loginResult = await _authRepository.login(request);

      return loginResult.when(
        success: (LoginResponse response) async {
          // Store tokens and user info
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', response.accessToken);
          await prefs.setString('refresh_token', response.refreshToken);
          await prefs.setString('user_id', response.userId);
          await prefs.setString('user_role', response.role);
          await prefs.setBool('isLoggedIn', true);

          final userRole = UserRole.fromApiRole(response.role);

          return Success(
            data: AuthResult(
              userRole: userRole,
              message: response.message,
            ),
          );
        },
        apiFailure: (error, statusCode) {
          return ApiFailure(
            error: error,
            statusCode: statusCode,
          );
        },
      );
    } catch (e) {
      return ApiFailure(
        error: ApiExceptions.errorResponse(
            error: 'Unexpected error: ${e.toString()}'),
        statusCode: -1,
      );
    }
  }

  /// Check if user is logged in by checking stored tokens
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final accessToken = prefs.getString('access_token');

      // User is logged in if flag is true AND token exists
      return isLoggedIn && accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get stored user role
  static Future<UserRole?> getStoredUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roleString = prefs.getString('user_role');

      if (roleString != null && roleString.isNotEmpty) {
        return UserRole.fromApiRole(roleString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Clear all stored authentication data (logout)
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_id');
      await prefs.remove('user_role');
      await prefs.setBool('isLoggedIn', false);
    } catch (e) {
      // Ignore errors during logout
    }
  }

  /// Logout and navigate to login screen
  static Future<void> logoutAndNavigate(BuildContext context) async {
    await logout();
    if (context.mounted) {
      context.router.replace(const Login());
    }
  }

  /// Navigate to appropriate screen based on user role
  static void navigateToRoleScreen(UserRole role, BuildContext context,
      {bool replace = false}) {
    if (role == UserRole.superAdmin) {
      if (replace) {
        context.router.replaceNamed('/super-admin/dashboard');
      } else {
        context.router.pushNamed('/super-admin/dashboard');
      }
    } else if (role == UserRole.lgAdmin) {
      if (replace) {
        context.router.replaceNamed('/admin/dashboard');
      } else {
        context.router.pushNamed('/admin/dashboard');
      }
    } else if (role == UserRole.immigrationOfficer) {
      if (replace) {
        context.router.replaceNamed('/verify/certificate');
      } else {
        context.router.pushNamed('/verify/certificate');
      }
    } else {
      if (replace) {
        context.router.replaceNamed('/home');
      } else {
        context.router.pushNamed('/home');
      }
    }
  }

  static Future<void> checkLoginAndNavigate(BuildContext context) async {
    final loggedIn = await isLoggedIn();

    if (loggedIn) {
      // User is logged in, get their role and navigate
      final userRole = await getStoredUserRole();

      if (userRole != null && context.mounted) {
        // Use replace=true to prevent back navigation to splash/login
        navigateToRoleScreen(userRole, context, replace: true);
      } else {
        // Role not found, clear invalid session and go to login
        await logout();
        if (context.mounted) {
          context.router.replace(const Login());
        }
      }
    } else {
      // User is not logged in, go to login screen
      if (context.mounted) {
        context.router.replace(const Login());
      }
    }
  }
}

/// Result object containing user role and message after auth operations
class AuthResult {
  final UserRole userRole;
  final String message;

  AuthResult({
    required this.userRole,
    required this.message,
  });
}
