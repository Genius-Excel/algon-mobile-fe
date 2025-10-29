import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';

@RoutePage(name: 'FirstOnboarding')
class FirstOnboardingScreen extends StatelessWidget {
  const FirstOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF5E8),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.router.pushNamed('/login'),
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Color(0xFF666666)),
                ),
              ),
            ),
            const Spacer(),
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF90E8A7),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.description,
                size: 64,
                color: Color(0xFF0D9488),
              ),
            ),
            const SizedBox(height: 32),
            // Title
            Text(
              'Apply for YourCertificate',
              textAlign: TextAlign.center,
              style: AppStyles.textStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Submit your indigene certificate application digitally with ease and track its progress in real-time.',
                textAlign: TextAlign.center,
                style: AppStyles.textStyle.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
            const Spacer(),
            // Progress indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1D5DB),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1D5DB),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: 'Next',
                onPressed: () => context.router.pushNamed(
                  '/onboarding/second',
                ),
                isFullWidth: true,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
