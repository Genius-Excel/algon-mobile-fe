import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/application/presentation/providers/application_form_provider.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/features/application/data/models/states_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:file_picker/file_picker.dart';

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
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  StateData? _selectedState;
  LocalGovernment? _selectedLG;
  final _villageController = TextEditingController();
  String? _selectedNinSlipFileName;
  String? _selectedNinSlipFilePath;
  String? _selectedProfilePhotoFileName;
  String? _selectedProfilePhotoFilePath;

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
    _emailController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  List<LocalGovernment> get _selectedLocalGovernments {
    if (_selectedState == null) return [];
    return _selectedState!.localGovernments;
  }

  Future<void> _verifyNinAndNavigate(String applicationId) async {
    final applicationRepo = ref.read(applicationRepositoryProvider);

    final verifyResult = await applicationRepo.verifyNin(
      applicationId,
      'certificate',
    );

    verifyResult.when(
      success: (_) {
        if (mounted) {
          context.router.pushNamed('/application/step2');
        }
      },
      apiFailure: (error, statusCode) {
        if (mounted) {
          Toast.info('NIN verification had issues, but proceeding...', context);
          context.router.pushNamed('/application/step2');
        }
      },
    );
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
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ShimmerContainer(width: 150, height: 24),
                            const SizedBox(height: 24),
                            ...List.generate(
                                9,
                                (index) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: index < 8 ? 16 : 24),
                                      child: const ShimmerFormField(),
                                    )),
                            const ShimmerContainer(width: 150, height: 14),
                            const SizedBox(height: 16),
                            ...List.generate(
                                2,
                                (index) => const Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: ShimmerContainer(
                                        width: double.infinity,
                                        height: 56,
                                      ),
                                    )),
                          ],
                        ),
                      )
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
                                  // Remove + and spaces for validation
                                  final cleaned =
                                      value.replaceAll(RegExp(r'[\s+]'), '');
                                  if (cleaned.length < 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Required Documents',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildFileUploader(
                                label: 'NIN Slip',
                                fileName: _selectedNinSlipFileName,
                                onTap: _pickNinSlipFile,
                              ),
                              const SizedBox(height: 16),
                              _buildFileUploader(
                                label: 'Profile Photo',
                                fileName: _selectedProfilePhotoFileName,
                                onTap: _pickProfilePhotoFile,
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
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Validate required files
                    if (_selectedNinSlipFilePath == null) {
                      Toast.error('Please upload NIN slip', context);
                      return;
                    }
                    if (_selectedProfilePhotoFilePath == null) {
                      Toast.error('Please upload profile photo', context);
                      return;
                    }

                    // Verify NIN first
                    final formData = ref.read(applicationFormProvider);
                    final applicationRepo =
                        ref.read(applicationRepositoryProvider);

                    // Create application with Step 1 data
                    final apiFormData = <String, dynamic>{
                      'date_of_birth':
                          DateFormatter.toApiFormat(_dobController.text),
                      'full_name': _fullNameController.text.trim(),
                      'local_government': _selectedLG!.name,
                      'phone_number': _phoneController.text.trim(),
                      'state': _selectedState!.name,
                      'village': _villageController.text.trim(),
                      'nin': _ninController.text.trim(),
                      'email': _emailController.text.trim(),
                      'landmark': '', // Will be updated in Step 2
                    };

                    // Prepare files for Step 1
                    final files = <MapEntry<String, String>>[];
                    files.add(MapEntry('nin_slip', _selectedNinSlipFilePath!));
                    files.add(MapEntry(
                        'profile_photo', _selectedProfilePhotoFilePath!));

                    // Show loading
                    if (mounted) {
                      Toast.info('Creating application...', context);
                    }

                    final result =
                        await applicationRepo.createCertificateApplication(
                      apiFormData,
                      files,
                    );

                    result.when(
                      success: (response) {
                        // Save Step 1 data and application ID
                        formData.setStep1Data(
                          nin: _ninController.text.trim(),
                          fullName: _fullNameController.text.trim(),
                          dateOfBirth:
                              DateFormatter.toApiFormat(_dobController.text),
                          stateValue: _selectedState!.name,
                          localGovernment: _selectedLG!.name,
                          village: _villageController.text.trim(),
                        );
                        // Also save email and phone from Step 1
                        formData.setStep2Data(
                          email: _emailController.text.trim(),
                          phoneNumber: _phoneController.text.trim(),
                        );
                        formData.setApplicationId(response.data.applicationId);

                        // Verify NIN
                        _verifyNinAndNavigate(response.data.applicationId);
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

  Future<void> _pickNinSlipFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileSize = await _checkFileSize(filePath, 'NIN Slip');
      if (fileSize != null) {
        setState(() {
          _selectedNinSlipFileName = result.files.single.name;
          _selectedNinSlipFilePath = filePath;
        });
      }
    }
  }

  Future<void> _pickProfilePhotoFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileSize = await _checkFileSize(filePath, 'Profile Photo');
      if (fileSize != null) {
        setState(() {
          _selectedProfilePhotoFileName = result.files.single.name;
          _selectedProfilePhotoFilePath = filePath;
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
