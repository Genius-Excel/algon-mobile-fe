import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';

@RoutePage(name: 'NewApplicationStep2')
class NewApplicationStep2Screen extends StatefulWidget {
  const NewApplicationStep2Screen({super.key});

  @override
  State<NewApplicationStep2Screen> createState() =>
      _NewApplicationStep2ScreenState();
}

class _NewApplicationStep2ScreenState extends State<NewApplicationStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  String? _selectedFile;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
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
              currentStep: 2,
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
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const ColSpacing(16),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'your.email@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const ColSpacing(16),
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: '+234 800 000 0000',
                          keyboardType: TextInputType.phone,
                        ),
                        const ColSpacing(16),
                        CustomTextField(
                          controller: _addressController,
                          label: 'Residential Address',
                          hint: 'Full address in the local government',
                        ),
                        const ColSpacing(16),
                        CustomTextField(
                          controller: _landmarkController,
                          label: 'Nearest Landmark',
                          hint: 'E.g., Next to primary school',
                        ),
                        const ColSpacing(16),
                        const Text(
                          'Upload Supporting Letter',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const ColSpacing(16),
                        GestureDetector(
                          onTap: _pickFile,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                                style: BorderStyle.solid,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Upload letter from village head',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                if (_selectedFile != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    _selectedFile!,
                                    style: const TextStyle(
                                      color: Color(0xFF065F46),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Next',
                      iconData: Icons.arrow_forward,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.router.pushNamed('/application/step3');
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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single.name;
      });
    }
  }
}
