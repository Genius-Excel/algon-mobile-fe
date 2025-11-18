import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';

@RoutePage(name: 'DigitizationStep4')
class DigitizationStep4Screen extends StatelessWidget {
  const DigitizationStep4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StepHeader(
              title: 'Certificate Digitization',
              currentStep: 4,
              totalSteps: 4,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                AppColors.greenLight.withOpacity(0.1),
                            child: const Icon(
                              Icons.check_circle,
                              color: AppColors.greenLight,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Certificate Digitized',
                            style: AppStyles.textStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Your certificate has been digitized successfully.',
                              textAlign: TextAlign.center,
                              style: AppStyles.textStyle.copyWith(
                                  fontSize: 16,
                                  color: AppColors.greyDark.withOpacity(0.6),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.greenLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: AppColors.greenLight.withOpacity(0.6),
                              width: 1),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Digitized Copy',
                                  style: AppStyles.textStyle.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  AppColors.greenLight.withOpacity(0.1),
                              child: const Icon(
                                Icons.check_circle,
                                color: AppColors.greenLight,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'CERTIFICATE OF INDIGENE',
                              style: AppStyles.textStyle.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.green),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ikeja LGA, Lagos State',
                              style: AppStyles.textStyle.copyWith(
                                fontSize: 14,
                                color: AppColors.greyDark.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Issued to',
                                    style: AppStyles.textStyle.copyWith(
                                      fontSize: 14,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'John Doe',
                                    style: AppStyles.textStyle.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Certificate ID: DIGI-2025-647',
                                    style: AppStyles.textStyle.copyWith(
                                      fontSize: 14,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.greyDark.withOpacity(0.6),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.qr_code_2,
                                size: 100,
                                color: AppColors.greyDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'QR Code for Verification',
                              style: AppStyles.textStyle.copyWith(
                                fontSize: 14,
                                color: AppColors.greyDark.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Download Digital Certificate',
                    iconData: Icons.download,
                    onPressed: () {},
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Share Verification ID',
                    iconData: Icons.share,
                    variant: ButtonVariant.outline,
                    onPressed: () {},
                    isFullWidth: true,
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
