import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/shared/widgets/payment_webview_sheet.dart';
import 'package:algon_mobile/features/digitization/presentation/providers/digitization_form_provider.dart';
import 'package:algon_mobile/features/payment/data/repository/payment_repository.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'DigitizationStep3')
class DigitizationStep3Screen extends ConsumerStatefulWidget {
  const DigitizationStep3Screen({super.key});

  @override
  ConsumerState<DigitizationStep3Screen> createState() =>
      _DigitizationStep3ScreenState();
}

class _DigitizationStep3ScreenState
    extends ConsumerState<DigitizationStep3Screen> {
  String? _selectedPaymentMethod;
  bool _isLoading = false;

  Future<void> _initiatePayment() async {
    if (_selectedPaymentMethod == null) {
      Toast.error('Please select a payment method', context);
      return;
    }

    final formData = ref.read(digitizationFormProvider);

    if (formData.applicationId == null) {
      Toast.error(
          'Application ID not found. Please go back and complete the previous steps.',
          context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final paymentRepo = ref.read(paymentRepositoryProvider);

      // Get digitization fee from form data
      final digitizationFee = formData.digitizationFee;
      if (digitizationFee == null || digitizationFee <= 0) {
        Toast.error(
          'Fee information not available. Please go back and try again.',
          context,
        );
        setState(() => _isLoading = false);
        return;
      }

      // Initiate payment
      final result = await paymentRepo.initiatePayment(
        formData.applicationId!,
        'digitization',
        amount: digitizationFee,
      );

      result.when(
        success: (response) {
          if (mounted) {
            // Save payment method to provider
            formData.paymentMethod = _selectedPaymentMethod;

            // Show payment WebView in bottom sheet
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => PaymentWebViewSheet(
                paymentUrl: response.data.data.authorizationUrl,
                onPaymentComplete: () {
                  // Navigate to step 4 after payment completion
                  if (mounted) {
                    Toast.success('Payment completed successfully!', context);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        context.router.pushNamed('/digitization/step4');
                      }
                    });
                  }
                },
              ),
            );
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
        Toast.error('Failed to initiate payment: ${e.toString()}', context);
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
      body: SafeArea(
        child: Column(
          children: [
            const StepHeader(
              title: 'Certificate Digitization',
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Consumer(
                        builder: (context, ref, _) {
                          final formData = ref.watch(digitizationFormProvider);
                          final digitizationFee = formData.digitizationFee ?? 0;

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: AppColors.greenLight.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: AppColors.greenLight.withOpacity(0.1),
                                  width: 1),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Digitization Fee',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '₦${digitizationFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF065F46),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    '60% less than standard application fee',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF065F46),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.greenLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.greenLight.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Secure Payment Processing',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF065F46),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your payment information is encrypted and secure',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green[900],
                                    ),
                                  ),
                                ],
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
                      onPressed:
                          _isLoading ? null : () => context.router.maybePop(),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: CustomButton(
                      text: _isLoading ? 'Processing...' : 'Complete Payment',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _initiatePayment,
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
            width: isSelected ? 1 : 0.5,
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
            const SizedBox(width: 16),
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
