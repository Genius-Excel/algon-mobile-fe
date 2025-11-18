import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/core/enums/user_role.dart';

@RoutePage(name: 'VerifyCertificate')
class VerifyCertificateScreen extends StatefulWidget {
  const VerifyCertificateScreen({super.key});

  @override
  State<VerifyCertificateScreen> createState() =>
      _VerifyCertificateScreenState();
}

enum VerificationState {
  idle,
  verifying,
  success,
  error,
}

class _VerifyCertificateScreenState extends State<VerifyCertificateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _certificateIdController = TextEditingController();
  VerificationState _verificationState = VerificationState.idle;
  bool _isImmigrationOfficer = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleName = prefs.getString('user_role');
    if (roleName != null) {
      final role = UserRole.values.firstWhere(
        (r) => r.name == roleName,
        orElse: () => UserRole.applicant,
      );
      if (mounted) {
        setState(() {
          _isImmigrationOfficer = role == UserRole.immigrationOfficer;
        });
      }
    }
  }

  @override
  void dispose() {
    _certificateIdController.dispose();
    super.dispose();
  }

  Future<void> _verifyCertificate() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _verificationState = VerificationState.verifying;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace with actual API call
      // For demo, showing error state
      if (mounted) {
        setState(() {
          _verificationState = VerificationState.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation for Immigration Officers
        if (_isImmigrationOfficer) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_isImmigrationOfficer)
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => context.router.maybePop(),
                          ),
                        ],
                      ),
                    ),
                  if (_isImmigrationOfficer) const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify Certificate',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Check certificate authenticity',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: AppColors.greyDark.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.greyDark.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(
                                      controller: _certificateIdController,
                                      label: 'Enter Certificate ID',
                                      hint: 'e.g., CERT-2025-001',
                                    ),
                                    const SizedBox(height: 16),
                                    CustomButton(
                                      text: _verificationState ==
                                              VerificationState.verifying
                                          ? 'Verifying...'
                                          : 'Verify Now',
                                      iconData: _verificationState ==
                                              VerificationState.verifying
                                          ? null
                                          : Icons.search,
                                      iconPosition: IconPosition.left,
                                      isLoading: _verificationState ==
                                          VerificationState.verifying,
                                      onPressed: _verificationState ==
                                              VerificationState.verifying
                                          ? null
                                          : _verifyCertificate,
                                      isFullWidth: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: AppColors.greyDark.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.greyDark.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E3),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.qr_code_scanner,
                                        size: 70,
                                        color: Color(0xFF065F46),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Scan QR Code',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Use your device camera to scan the certificate QR code',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Implement QR code scanner
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'QR scanner will be implemented soon'),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                            color: AppColors.greyDark
                                                .withOpacity(0.6),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          'Open Camera',
                                          style: AppStyles.textStyle.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blackColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_verificationState ==
                                  VerificationState.error) ...[
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFEF4444),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Invalid Certificate',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFDC2626),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'This certificate ID was not found in our system. Please verify the ID and try again.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
