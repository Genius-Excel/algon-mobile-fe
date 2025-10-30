import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';

@RoutePage(name: 'NewApplicationStep3')
class NewApplicationStep3Screen extends StatefulWidget {
  const NewApplicationStep3Screen({super.key});

  @override
  State<NewApplicationStep3Screen> createState() =>
      _NewApplicationStep3ScreenState();
}

class _NewApplicationStep3ScreenState extends State<NewApplicationStep3Screen> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StepHeader(
              title: 'New Application',
              currentStep: 3,
              totalSteps: 4,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const ColSpacing(16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Application Fee',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.greyDark,
                              ),
                            ),
                            ColSpacing(16),
                            Text(
                              '₦5,000',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _PaymentOption(
                        title: 'Pay with Card',
                        subtitle: 'Paystack / Flutterwave',
                        icon: Icons.credit_card,
                        isSelected: _selectedPaymentMethod == 'card',
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'card';
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _PaymentOption(
                        title: 'Bank Transfer',
                        subtitle: 'Direct bank payment',
                        icon: Icons.account_balance,
                        isSelected: _selectedPaymentMethod == 'bank',
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'bank';
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          'Your payment is secure and encrypted',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Back',
                      variant: ButtonVariant.outline,
                      onPressed: () => context.router.maybePop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Next',
                      iconData: Icons.arrow_forward,
                      onPressed: () {
                        if (_selectedPaymentMethod != null) {
                          context.router.pushNamed('/application/step4');
                        }
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

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF065F46) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[100]!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.green[900], size: 24),
            ),
            const RowSpacing(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.greyDark,
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
