import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';

@RoutePage(name: 'VerifyCertificate')
class VerifyCertificateScreen extends StatefulWidget {
  const VerifyCertificateScreen({super.key});

  @override
  State<VerifyCertificateScreen> createState() =>
      _VerifyCertificateScreenState();
}

class _VerifyCertificateScreenState extends State<VerifyCertificateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _certificateIdController = TextEditingController();

  @override
  void dispose() {
    _certificateIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.router.maybePop(),
                      ),
                    ],
                  ),
                ),
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
                                    color: AppColors.greyDark.withOpacity(0.1),
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
                                    text: 'Verify Now',
                                    iconData: Icons.search,
                                    iconPosition: IconPosition.left,
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Verifying certificate...'),
                                          ),
                                        );
                                      }
                                    },
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
                                    color: AppColors.greyDark.withOpacity(0.1),
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
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(25),
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
                                      )),
                                ],
                              ),
                            ),
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
    );
  }
}
