import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/features/auth/data/models/forgot_password_models.dart';
import 'package:algon_mobile/features/auth/data/repository/auth_repository_impl.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';

@RoutePage(name: 'ForgotPasswordStep3')
class ForgotPasswordStep3Screen extends ConsumerStatefulWidget {
  final String email;
  final String otp;

  const ForgotPasswordStep3Screen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  ConsumerState<ForgotPasswordStep3Screen> createState() =>
      _ForgotPasswordStep3ScreenState();
}

class _ForgotPasswordStep3ScreenState
    extends ConsumerState<ForgotPasswordStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      Toast.formError(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final request = PasswordResetRequest(
        email: widget.email,
        otp: widget.otp,
        password1: _passwordController.text.trim(),
        password2: _confirmPasswordController.text.trim(),
      );

      final result = await authRepository.resetPassword(request);

      result.when(
        success: (response) {
          if (mounted) {
            Toast.success(response.message, context);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                // Navigate back to login
                context.router.popUntilRouteWithName('Login');
              }
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            if (error is ApiExceptions) {
              Toast.apiError(error, context);
            } else {
              Toast.error(error.toString(), context);
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        Toast.error('An unexpected error occurred: ${e.toString()}', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Reset Password',
          style: AppStyles.textStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter your new password below.',
                    style: AppStyles.textStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const ColSpacing(40),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'New Password',
                    hint: 'Enter new password',
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const ColSpacing(24),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm New Password',
                    hint: 'Confirm new password',
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const ColSpacing(32),
                  CustomButton(
                    text: 'Reset Password',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _resetPassword,
                    isFullWidth: true,
                  ),
                  const ColSpacing(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password? ',
                        style: AppStyles.textStyle.copyWith(
                          color: AppColors.greyDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.router.popUntilRouteWithName('Login');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Login',
                          style: AppStyles.textStyle.copyWith(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
