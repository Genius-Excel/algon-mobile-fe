import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/shared/widgets/payment_webview_sheet.dart';
import 'package:algon_mobile/features/application/presentation/providers/application_form_provider.dart';
import 'package:algon_mobile/features/payment/data/repository/payment_repository.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'NewApplicationStep3')
class NewApplicationStep3Screen extends ConsumerStatefulWidget {
  const NewApplicationStep3Screen({super.key});

  @override
  ConsumerState<NewApplicationStep3Screen> createState() =>
      _NewApplicationStep3ScreenState();
}

class _NewApplicationStep3ScreenState
    extends ConsumerState<NewApplicationStep3Screen> {
  String? _selectedPaymentMethod;
  bool _isLoading = false;

  Future<void> _initiatePayment() async {
    if (_selectedPaymentMethod == null) {
      Toast.error('Please select a payment method', context);
      return;
    }

    final formData = ref.read(applicationFormProvider);

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

      // Calculate total fee
      final applicationFee = formData.applicationFee ?? 0;
      final verificationFee = formData.verificationFee ?? 0;
      final totalFee = applicationFee + verificationFee;

      if (totalFee <= 0) {
        Toast.error(
            'Fee information not available. Please go back and try again.',
            context);
        setState(() => _isLoading = false);
        return;
      }

      // Initiate payment
      final result = await paymentRepo.initiatePayment(
        formData.applicationId!,
        'certificate',
        amount: totalFee,
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
                        context.router.pushNamed('/application/step4');
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
                      Consumer(
                        builder: (context, ref, _) {
                          final formData = ref.watch(applicationFormProvider);
                          final applicationFee = formData.applicationFee ?? 0;
                          final verificationFee = formData.verificationFee ?? 0;
                          final totalFee = applicationFee + verificationFee;

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Application Fee',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.greyDark,
                                  ),
                                ),
                                const ColSpacing(16),
                                if (applicationFee > 0 &&
                                    verificationFee > 0) ...[
                                  Text(
                                    'Application Fee: ₦${applicationFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Verification Fee: ₦${verificationFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                ],
                                Text(
                                  'Total: ₦${totalFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
                      onPressed:
                          _isLoading ? null : () => context.router.maybePop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: _isLoading ? 'Processing...' : 'Pay Now',
                      iconData: _isLoading ? null : Icons.arrow_forward,
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
