import 'package:algon_mobile/core/router/router.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';

@RoutePage(name: 'ForgotPasswordStep2')
class ForgotPasswordStep2Screen extends ConsumerStatefulWidget {
  final String email;

  const ForgotPasswordStep2Screen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ForgotPasswordStep2Screen> createState() =>
      _ForgotPasswordStep2ScreenState();
}

class _ForgotPasswordStep2ScreenState
    extends ConsumerState<ForgotPasswordStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final bool _isLoading = false;

  // Pin theme for Pinput
  PinTheme get _pinTheme => PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent),
        ),
      );

  PinTheme get _focusedPinTheme => PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF0D9488),
            width: 2,
          ),
        ),
      );

  PinTheme get _errorPinTheme => PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red, width: 1),
        ),
      );

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _proceedToPasswordReset() {
    // Validate OTP length
    if (_otpController.text.trim().length != 6) {
      Toast.error('Please enter a valid 6-digit OTP', context);
      return;
    }

    if (mounted) {
      context.router.push(
        ForgotPasswordStep3(
          email: widget.email,
          otp: _otpController.text.trim().toUpperCase(),
        ),
      );
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
          'Enter OTP',
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
                    'We\'ve sent an OTP to ${widget.email}. Please enter it below.',
                    style: AppStyles.textStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const ColSpacing(40),
                  // OTP field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OTP Code',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Pinput(
                        controller: _otpController,
                        length: 6,
                        defaultPinTheme: _pinTheme,
                        focusedPinTheme: _focusedPinTheme,
                        errorPinTheme: _errorPinTheme,
                        showCursor: true,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9]')),
                        ],
                        textCapitalization: TextCapitalization.characters,
                        onCompleted: (pin) {
                          // Auto-submit when OTP is complete
                          _proceedToPasswordReset();
                        },
                      ),
                    ],
                  ),
                  const ColSpacing(32),
                  // Submit button
                  CustomButton(
                    text: 'Verify OTP',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _proceedToPasswordReset,
                    isFullWidth: true,
                  ),
                  const ColSpacing(16),
                  // Resend OTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the code? ',
                        style: AppStyles.textStyle.copyWith(
                          color: AppColors.greyDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.router.maybePop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Resend',
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
