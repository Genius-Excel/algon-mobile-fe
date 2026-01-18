import 'dart:io';

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
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String? _selectedLetterFileName;
  String? _selectedLetterFilePath;
  bool _isLoading = false;

  @override
  void dispose() {
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

      if (formData.applicationId == null) {
        Toast.error(
            'Application ID not found. Please go back to Step 1.', context);
        setState(() => _isLoading = false);
        return;
      }

      // Prepare form data for PATCH request (Step 2)
      final apiFormData = <String, dynamic>{};

      if (_addressController.text.trim().isNotEmpty) {
        apiFormData['residential_address'] = _addressController.text.trim();
      }

      if (_landmarkController.text.trim().isNotEmpty) {
        apiFormData['landmark'] = _landmarkController.text.trim();
      }

      // Prepare extra_fields (if local government requires dynamic fields)
      // For now, we'll leave it empty unless the API tells us what fields are needed
      final extraFields = <Map<String, dynamic>>[];
      if (extraFields.isNotEmpty) {
        apiFormData['extra_fields'] = extraFields;
      }

      // Prepare files - only letter from traditional ruler is needed here.
      // NIN slip and profile photo were already uploaded in Step 1.
      final files = <MapEntry<String, String>>[];

      if (_selectedLetterFilePath == null) {
        Toast.error('Please upload letter from traditional ruler', context);
        setState(() => _isLoading = false);
        return;
      }

      files.add(
          MapEntry('letter_from_traditional_ruler', _selectedLetterFilePath!));

      // Update application via PATCH (Step 2)
      final result = await applicationRepo.updateCertificateApplication(
        formData.applicationId!,
        apiFormData,
        files,
      );

      result.when(
        success: (response) {
          // Save Step 2 data and fees (reuse email/phone from Step 1)
          formData.setStep2Data(
            email: formData.email ?? '',
            phoneNumber: formData.phoneNumber ?? '',
            residentialAddress: _addressController.text.trim().isNotEmpty
                ? _addressController.text.trim()
                : null,
            landmark: _landmarkController.text.trim().isNotEmpty
                ? _landmarkController.text.trim()
                : null,
            letterFromTraditionalRulerPath: _selectedLetterFilePath,
          );

          // Store fees for Step 3
          formData.setFees(
            applicationFee: response.data.fee.applicationFee?.toInt(),
            verificationFee: response.data.verificationFee?.toInt(),
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
                          'Residential Information',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
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
                          'Required Documents',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const ColSpacing(16),
                        _buildFileUploader(
                          label: 'Letter from Traditional Ruler',
                          fileName: _selectedLetterFileName,
                          onTap: _pickLetterFile,
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

  Widget _buildFileUploader({
    required String label,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: fileName != null ? AppColors.green : Colors.grey[300]!,
                style: BorderStyle.solid,
                width: fileName != null ? 1.5 : 0.5,
              ),
              borderRadius: BorderRadius.circular(12),
              color:
                  fileName != null ? AppColors.green.withOpacity(0.05) : null,
            ),
            child: Row(
              children: [
                Icon(
                  fileName != null ? Icons.check_circle : Icons.upload,
                  size: 24,
                  color: fileName != null ? AppColors.green : Colors.grey[400],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName != null ? 'File selected' : 'Tap to upload',
                        style: TextStyle(
                          color: fileName != null
                              ? AppColors.green
                              : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: fileName != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                      if (fileName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          fileName,
                          style: const TextStyle(
                            color: AppColors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickLetterFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileSize =
          await _checkFileSize(filePath, 'Letter from Traditional Ruler');
      if (fileSize != null) {
        setState(() {
          _selectedLetterFileName = result.files.single.name;
          _selectedLetterFilePath = filePath;
        });
      }
    }
  }

  /// Check file size and return file path if valid, null if too large
  /// Returns file size in MB for display, or null if file is too large
  Future<double?> _checkFileSize(String filePath, String fileName) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final fileSize = await file.length();
        final fileSizeInMB = fileSize / (1024 * 1024); // Convert to MB

        // Maximum file size: 10MB per file
        const maxSizeMB = 10.0;

        if (fileSizeInMB > maxSizeMB) {
          if (mounted) {
            Toast.error(
              '$fileName is too large (${fileSizeInMB.toStringAsFixed(2)}MB). Maximum size is ${maxSizeMB}MB per file. Please compress or use a smaller file.',
              context,
              duration: 8,
            );
          }
          return null;
        }

        return fileSizeInMB;
      }
    } catch (e) {
      if (mounted) {
        Toast.error('Error reading file: ${e.toString()}', context);
      }
    }
    return null;
  }
}
