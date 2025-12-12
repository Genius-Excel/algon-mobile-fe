import 'package:algon_mobile/core/enums/user_role.dart';
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
            return ApiFailure(
              error: const ApiExceptions.errorResponse(error: 'Registration failed: No user data returned'),
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
              await prefs.setString('refresh_token', loginResponse.refreshToken);
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
        error: ApiExceptions.errorResponse(error: 'Unexpected error: ${e.toString()}'),
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
        error: ApiExceptions.errorResponse(error: 'Unexpected error: ${e.toString()}'),
        statusCode: -1,
      );
    }
  }

  /// Navigate to appropriate screen based on user role
  static void navigateToRoleScreen(UserRole role, BuildContext context) {
    if (role == UserRole.superAdmin) {
      context.router.pushNamed('/super-admin/dashboard');
    } else if (role == UserRole.lgAdmin) {
      context.router.pushNamed('/admin/dashboard');
    } else if (role == UserRole.immigrationOfficer) {
      context.router.pushNamed('/verify/certificate');
    } else {
      context.router.pushNamed('/home');
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

