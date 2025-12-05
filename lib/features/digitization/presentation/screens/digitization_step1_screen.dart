import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/digitization/presentation/providers/digitization_form_provider.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/features/application/data/models/states_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'DigitizationStep1')
class DigitizationStep1Screen extends ConsumerStatefulWidget {
  const DigitizationStep1Screen({super.key});

  @override
  ConsumerState<DigitizationStep1Screen> createState() =>
      _DigitizationStep1ScreenState();
}

class _DigitizationStep1ScreenState
    extends ConsumerState<DigitizationStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _ninController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();
  StateData? _selectedState;
  LocalGovernment? _selectedLG;

  List<StateData> _states = [];
  bool _isLoadingStates = false;

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  Future<void> _fetchStates() async {
    setState(() {
      _isLoadingStates = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final result = await applicationRepo.getAllStates();

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _states = response.data;
              _isLoadingStates = false;
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingStates = false;
            });
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
        setState(() {
          _isLoadingStates = false;
        });
        Toast.error('Failed to load states: ${e.toString()}', context);
      }
    }
  }

  @override
  void dispose() {
    _ninController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  List<LocalGovernment> get _selectedLocalGovernments {
    if (_selectedState == null) return [];
    return _selectedState!.localGovernments;
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
                child: _isLoadingStates
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'NIN is required';
                                  }
                                  if (value.length != 11) {
                                    return 'NIN must be 11 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _fullNameController,
                                label: 'Full Name',
                                hint: 'As shown on NIN',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Full Name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                hint: 'your.email@example.com',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                hint: '+234 800 000 0000',
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  final cleaned =
                                      value.replaceAll(RegExp(r'[\s+]'), '');
                                  if (cleaned.length < 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomDropdownField<StateData>(
                                label: 'State',
                                value: _selectedState,
                                items: _states,
                                hint: _isLoadingStates
                                    ? 'Loading states...'
                                    : 'Select state',
                                itemBuilder: (state) => state.name,
                                validator: (value) {
                                  if (value == null) {
                                    return 'State is required';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _selectedState = value;
                                    _selectedLG = null;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomDropdownField<LocalGovernment>(
                                label: 'Local Government',
                                value: _selectedLG,
                                items: _selectedLocalGovernments,
                                hint: _selectedState == null
                                    ? 'Select state first'
                                    : 'Select LG',
                                itemBuilder: (lg) => lg.name,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Local Government is required';
                                  }
                                  return null;
                                },
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
                    // Save Step 1 data to provider
                    final formData = ref.read(digitizationFormProvider);
                    formData.setStep1Data(
                      nin: _ninController.text.trim(),
                      email: _emailController.text.trim(),
                      phoneNumber: _phoneController.text.trim(),
                      stateValue: _selectedState!.name,
                      localGovernment: _selectedLG!.name,
                      fullName: _fullNameController.text.trim(),
                    );
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
