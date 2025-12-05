import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/application/presentation/providers/application_form_provider.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/features/application/data/models/states_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';

@RoutePage(name: 'NewApplicationStep1')
class NewApplicationStep1Screen extends ConsumerStatefulWidget {
  const NewApplicationStep1Screen({super.key});

  @override
  ConsumerState<NewApplicationStep1Screen> createState() =>
      _NewApplicationStep1ScreenState();
}

class _NewApplicationStep1ScreenState
    extends ConsumerState<NewApplicationStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _ninController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  StateData? _selectedState;
  LocalGovernment? _selectedLG;
  final _villageController = TextEditingController();

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
    _fullNameController.dispose();
    _dobController.dispose();
    _villageController.dispose();
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
              title: 'New Application',
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
                                'Personal Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
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
                                    return 'Full name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _dobController,
                                label: 'Date of Birth',
                                hint: 'mm/dd/yyyy',
                                suffixIcon: const Icon(Icons.calendar_today),
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Date of birth is required';
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    _dobController.text =
                                        '${date.month}/${date.day}/${date.year}';
                                  }
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
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _villageController,
                                label: 'Village/Town',
                                hint: 'Enter your village or town',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Village/Town is required';
                                  }
                                  return null;
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
                iconData: Icons.arrow_forward,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Save Step 1 data to provider
                    final formData = ref.read(applicationFormProvider);
                    formData.setStep1Data(
                      nin: _ninController.text.trim(),
                      fullName: _fullNameController.text.trim(),
                      dateOfBirth:
                          DateFormatter.toApiFormat(_dobController.text),
                      stateValue: _selectedState!.name,
                      localGovernment: _selectedLG!.name,
                      village: _villageController.text.trim(),
                    );
                    context.router.pushNamed('/application/step2');
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
