import 'dart:io';

import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/digitization/presentation/providers/digitization_form_provider.dart';
import 'package:algon_mobile/features/digitization/data/repository/digitization_repository.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'DigitizationStep2')
class DigitizationStep2Screen extends ConsumerStatefulWidget {
  const DigitizationStep2Screen({super.key});

  @override
  ConsumerState<DigitizationStep2Screen> createState() =>
      _DigitizationStep2ScreenState();
}

class _DigitizationStep2ScreenState
    extends ConsumerState<DigitizationStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _referenceNumberController = TextEditingController();
  String? _selectedCertificateFileName;
  String? _selectedCertificateFilePath;
  String? _selectedNinSlipFileName;
  String? _selectedNinSlipFilePath;
  String? _selectedProfilePhotoFileName;
  String? _selectedProfilePhotoFilePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _referenceNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitDigitization() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      Toast.formError(context);
      return;
    }

    if (_selectedCertificateFilePath == null) {
      Toast.error('Please upload your certificate', context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final formData = ref.read(digitizationFormProvider);
      final digitizationRepo = ref.read(digitizationRepositoryProvider);

      final apiFormData = <String, dynamic>{
        'nin': formData.nin!,
        'email': formData.email!,
        'full_name': formData.fullName ?? formData.email!.split('@')[0],
        'state': formData.stateValue!,
        'local_government': formData.localGovernment!,
        'phone_number': formData.phoneNumber!,
      };

      if (_referenceNumberController.text.trim().isNotEmpty) {
        apiFormData['certificate_reference_number'] =
            _referenceNumberController.text.trim();
      }

      // Prepare files
      final files = <MapEntry<String, String>>[];
      if (_selectedCertificateFilePath != null) {
        files.add(MapEntry('uploaded_files', _selectedCertificateFilePath!));
      }
      if (_selectedNinSlipFilePath != null) {
        files.add(MapEntry('nin_slip', _selectedNinSlipFilePath!));
      }
      if (_selectedProfilePhotoFilePath != null) {
        files.add(MapEntry('profile_photo', _selectedProfilePhotoFilePath!));
      }

      // Create digitization application
      final result = await digitizationRepo.createDigitizationApplication(
          apiFormData, files);

      result.when(
        success: (response) {
          // Save application ID and Step 2 data
          formData.setApplicationId(response.data.userData.id);
          formData.setStep2Data(
            certificateFilePath: _selectedCertificateFilePath,
            ninSlipFilePath: _selectedNinSlipFilePath,
            profilePhotoFilePath: _selectedProfilePhotoFilePath,
            certificateReferenceNumber:
                _referenceNumberController.text.trim().isNotEmpty
                    ? _referenceNumberController.text.trim()
                    : null,
          );

          if (mounted) {
            Toast.success(response.message, context);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.router.pushNamed('/digitization/step3');
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
                              'Certificate Photo/Scan (Required)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => _pickFile('certificate'),
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
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: _selectedCertificateFilePath != null &&
                                        _isImageFile(
                                            _selectedCertificateFilePath!)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(_selectedCertificateFilePath!),
                                          width: double.infinity,
                                          height: 300,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return _buildPlaceholder();
                                          },
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Icon(
                                            _selectedCertificateFilePath !=
                                                        null &&
                                                    _isPdfFile(
                                                        _selectedCertificateFilePath!)
                                                ? Icons.picture_as_pdf
                                                : Icons.description,
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
                                            onTap: () =>
                                                _pickFile('certificate'),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.upload,
                                                      size: 20,
                                                      color:
                                                          AppColors.blackColor),
                                                  SizedBox(width: 10),
                                                  Text('Choose File',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackColor,
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
                                          if (_selectedCertificateFileName !=
                                              null) ...[
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
                                                  Flexible(
                                                    child: Text(
                                                      _selectedCertificateFileName!,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF065F46),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _referenceNumberController,
                          label: 'Certificate Reference Number (Optional)',
                          hint: 'e.g LG/2020/12345',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a certificate reference number';
                            }
                            return null;
                          },
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
                                      style: AppStyles.textStyle
                                          .copyWith(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Ensure your certificate includes your name, LG seal, and issue date',
                                      style: AppStyles.textStyle.copyWith(
                                          color: AppColors.greyDark
                                              .withOpacity(0.6),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
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
                      onPressed:
                          _isLoading ? null : () => context.router.maybePop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: _isLoading ? 'Submitting...' : 'Next',
                      iconData: _isLoading ? null : Icons.arrow_forward,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _submitDigitization,
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

  bool _isImageFile(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    return extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'png' ||
        extension == 'gif';
  }

  bool _isPdfFile(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    return extension == 'pdf';
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.greyDark.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load image',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (type == 'certificate') {
          _selectedCertificateFileName = result.files.single.name;
          _selectedCertificateFilePath = result.files.single.path!;
        } else if (type == 'nin') {
          _selectedNinSlipFileName = result.files.single.name;
          _selectedNinSlipFilePath = result.files.single.path!;
        } else if (type == 'profile') {
          _selectedProfilePhotoFileName = result.files.single.name;
          _selectedProfilePhotoFilePath = result.files.single.path!;
        }
      });
    }
  }
}
