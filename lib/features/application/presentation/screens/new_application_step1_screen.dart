import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';

@RoutePage(name: 'NewApplicationStep1')
class NewApplicationStep1Screen extends StatefulWidget {
  const NewApplicationStep1Screen({super.key});

  @override
  State<NewApplicationStep1Screen> createState() =>
      _NewApplicationStep1ScreenState();
}

class _NewApplicationStep1ScreenState extends State<NewApplicationStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _ninController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedState;
  String? _selectedLG;
  final _villageController = TextEditingController();

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
    _fullNameController.dispose();
    _dobController.dispose();
    _villageController.dispose();
    super.dispose();
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
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          hint: 'As shown on NIN',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _dobController,
                          label: 'Date of Birth',
                          hint: 'mm/dd/yyyy',
                          suffixIcon: const Icon(Icons.calendar_today),
                          readOnly: true,
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
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _villageController,
                          label: 'Village/Town',
                          hint: 'Enter your village or town',
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
