import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';

@RoutePage(name: 'DigitizationStep2')
class DigitizationStep2Screen extends StatefulWidget {
  const DigitizationStep2Screen({super.key});

  @override
  State<DigitizationStep2Screen> createState() =>
      _DigitizationStep2ScreenState();
}

class _DigitizationStep2ScreenState extends State<DigitizationStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _referenceNumberController = TextEditingController();
  String? _selectedFile;

  @override
  void dispose() {
    _referenceNumberController.dispose();
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
                          'Upload Certificate',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload your existing paper certificate',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Certificate Photo/Scan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: _pickFile,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.greyDark.withOpacity(0.1),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.description,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Upload a clear photo or PDF scan of your certificate',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        context.router
                                            .pushNamed('/digitization/step1');
                                      },
                                      child: Container(
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              color: AppColors.orange,
                                              width: 0.1),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.upload,
                                                size: 20,
                                                color: AppColors.blackColor),
                                            SizedBox(width: 10),
                                            Text('Choose File',
                                                style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Supported formats: JPG, PNG, PDF (Max 5MB)',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (_selectedFile != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E3),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF065F46),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _selectedFile!,
                                              style: const TextStyle(
                                                color: Color(0xFF065F46),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _referenceNumberController,
                          label: 'Certificate Reference Number (Optional)',
                          hint: 'e.g., LG/2020/12345',
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Enter if available on your certificate',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.greenLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE8F5E3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.description,
                                color: Color(0xFF065F46),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(
                                      'Sample Old Certificate',
                                      style:AppStyles.textStyle.copyWith(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Ensure your certificate includes your name, LG seal, and issue date',
                                      style: AppStyles.textStyle
                                          .copyWith(color: AppColors.greyDark.withOpacity(0.6),fontSize: 12,fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
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
                          context.router.pushNamed('/digitization/step3');
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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single.name;
      });
    }
  }
}
