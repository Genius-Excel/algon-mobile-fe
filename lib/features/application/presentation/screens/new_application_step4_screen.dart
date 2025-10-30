import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';

@RoutePage(name: 'NewApplicationStep4')
class NewApplicationStep4Screen extends StatelessWidget {
  const NewApplicationStep4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepHeader(
              title: 'New Application',
              currentStep: 4,
              totalSteps: 4,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Review & Submit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _ReviewCard(
                        title: 'Personal Information',
                        items: [
                          'John Doe',
                          'NIN: 12345678901',
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _ReviewCard(
                        title: 'Location',
                        items: [
                          'Sample Village',
                          'Ikeja LGA, Lagos State',
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _ReviewCard(
                        title: 'Contact',
                        items: [
                          'john.doe@email.com',
                          '+234 801 234 5678',
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[100]!.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.green[500]!.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Color(0xFF065F46),
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'By submitting this application, you confirm that all information provided is accurate and truthful.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.blackColor,
                                ),
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
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Back',
                      variant: ButtonVariant.outline,
                      onPressed: () => context.router.maybePop(),
                    ),
                  ),
                  const RowSpacing(16),
                  Expanded(
                    child: CustomButton(
                      text: 'Submit Application',
                      onPressed: () {
                        context.router.pushNamed('/tracking');
                      },
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

class _ReviewCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const _ReviewCard({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green[100]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const ColSpacing(8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
