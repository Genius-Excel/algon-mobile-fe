import 'package:algon_mobile/core/router/router.dart';
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

@RoutePage(name: 'ForgotPasswordStep1')
class ForgotPasswordStep1Screen extends ConsumerStatefulWidget {
  const ForgotPasswordStep1Screen({super.key});

  @override
  ConsumerState<ForgotPasswordStep1Screen> createState() =>
      _ForgotPasswordStep1ScreenState();
}

class _ForgotPasswordStep1ScreenState
    extends ConsumerState<ForgotPasswordStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      Toast.formError(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final request = ResetEmailRequest(
        email: _emailController.text.trim(),
      );

      final result = await authRepository.resetEmail(request);

      result.when(
        success: (response) {
          if (mounted) {
            Toast.success(response.message, context);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.router.push(
                  ForgotPasswordStep2(email: _emailController.text.trim()),
                );
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
          'Forgot Password',
          style: AppStyles.textStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        centerTitle: true,
        leadingWidth: 0,
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
                  const ColSpacing(16),

                  Text(
                    'Enter your email address and we\'ll send you an OTP to reset your password.',
                    style: AppStyles.textStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const ColSpacing(40),
                  // Email field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const ColSpacing(32),
                  // Submit button
                  CustomButton(
                    text: 'Send OTP',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _sendResetEmail,
                    isFullWidth: true,
                  ),
                  const ColSpacing(25),
                  // Back to login
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
                        onPressed: () => context.router.maybePop(),
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
