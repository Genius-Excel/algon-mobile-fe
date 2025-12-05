import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/application/presentation/providers/application_form_provider.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'NewApplicationStep2')
class NewApplicationStep2Screen extends ConsumerStatefulWidget {
  const NewApplicationStep2Screen({super.key});

  @override
  ConsumerState<NewApplicationStep2Screen> createState() =>
      _NewApplicationStep2ScreenState();
}

class _NewApplicationStep2ScreenState
    extends ConsumerState<NewApplicationStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  String? _selectedFileName;
  String? _selectedFilePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      Toast.formError(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final formData = ref.read(applicationFormProvider);
      final applicationRepo = ref.read(applicationRepositoryProvider);

      // Prepare form data for API
      final apiFormData = <String, dynamic>{
        'date_of_birth': formData.dateOfBirth!,
        'email': _emailController.text.trim(),
        'full_name': formData.fullName!,
        'local_government': formData.localGovernment!,
        'phone_number': _phoneController.text.trim(),
        'state': formData.stateValue!,
        'village': formData.village!,
        'nin': formData.nin!,
      };

      if (_landmarkController.text.trim().isNotEmpty) {
        apiFormData['landmark'] = _landmarkController.text.trim();
      }

      if (_addressController.text.trim().isNotEmpty) {
        apiFormData['residential_address'] = _addressController.text.trim();
      }

      // Prepare files
      final files = <MapEntry<String, String>>[];
      if (_selectedFilePath != null) {
        files.add(MapEntry('letter_from_traditional_ruler', _selectedFilePath!));
      }

      // Create application
      final result = await applicationRepo.createCertificateApplication(
        apiFormData,
        files,
      );

      result.when(
        success: (response) {
          // Save application ID and Step 2 data
          formData.setApplicationId(response.data.applicationId);
          formData.setStep2Data(
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            residentialAddress: _addressController.text.trim().isNotEmpty
                ? _addressController.text.trim()
                : null,
            landmark: _landmarkController.text.trim().isNotEmpty
                ? _landmarkController.text.trim()
                : null,
            letterFromTraditionalRulerPath: _selectedFilePath,
          );

          if (mounted) {
            Toast.success(response.message, context);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.router.pushNamed('/application/step3');
              }
            });
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
        Toast.error('An unexpected error occurred: ${e.toString()}', context);
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
                        const ColSpacing(16),
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: '+234 800 000 0000',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            // Remove + and spaces for validation
                            final cleaned = value.replaceAll(RegExp(r'[\s+]'), '');
                            if (cleaned.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const ColSpacing(16),
                        CustomTextField(
                          controller: _addressController,
                          label: 'Residential Address',
                          hint: 'Full address in the local government',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Residential address is required';
                            }
                            return null;
                          },
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
                                if (_selectedFileName != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    _selectedFileName!,
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
                      onPressed: _isLoading ? null : () => context.router.maybePop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: _isLoading ? 'Submitting...' : 'Next',
                      iconData: _isLoading ? null : Icons.arrow_forward,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _submitApplication,
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
      type: FileType.any,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
        _selectedFilePath = result.files.single.path!;
      });
    }
  }
}
