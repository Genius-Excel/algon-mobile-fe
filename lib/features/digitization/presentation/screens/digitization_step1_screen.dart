import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';

@RoutePage(name: 'DigitizationStep1')
class DigitizationStep1Screen extends StatefulWidget {
  const DigitizationStep1Screen({super.key});

  @override
  State<DigitizationStep1Screen> createState() =>
      _DigitizationStep1ScreenState();
}

class _DigitizationStep1ScreenState extends State<DigitizationStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _ninController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedState;
  String? _selectedLG;

  final List<String> _states = ['Lagos', 'Abuja', 'Kano', 'Rivers'];
  final Map<String, List<String>> _localGovernments = {
    'Lagos': ['Ikeja', 'Lagos Island', 'Mushin', 'Surulere'],
    'Abuja': ['Abuja Municipal', 'Bwari', 'Gwagwalada'],
    'Kano': ['Kano Municipal', 'Dala', 'Fagge'],
    'Rivers': ['Port Harcourt', 'Obio-Akpor', 'Ikwerre'],
  };

  @override
  void dispose() {
    _ninController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StepHeader(
              title: 'Certificate Digitization',
              currentStep: 1,
              totalSteps: 4,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Verify Your Identity',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Confirm your details to begin digitization',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _ninController,
                          label: 'National Identity Number (NIN)',
                          hint: 'Enter your NIN',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'your.email@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: '+234 800 000 0000',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        CustomDropdownField<String>(
                          label: 'State',
                          value: _selectedState,
                          items: _states,
                          hint: 'Select state',
                          onChanged: (value) {
                            setState(() {
                              _selectedState = value;
                              _selectedLG = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdownField<String>(
                          label: 'Local Government',
                          value: _selectedLG,
                          items: _selectedState != null
                              ? _localGovernments[_selectedState] ?? []
                              : [],
                          hint: 'Select LG',
                          onChanged: (value) {
                            setState(() {
                              _selectedLG = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: CustomButton(
                text: 'Next',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.router.pushNamed('/digitization/step2');
                  }
                },
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
