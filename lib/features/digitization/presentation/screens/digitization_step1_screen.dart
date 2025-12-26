import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_dropdown_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:algon_mobile/shared/widgets/step_header.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/features/digitization/presentation/providers/digitization_form_provider.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/features/application/data/models/states_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/features/profile/presentation/providers/profile_provider.dart';

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

  String? _selectedNinSlipFileName;
  String? _selectedNinSlipFilePath;
  String? _selectedProfilePhotoFileName;
  String? _selectedProfilePhotoFilePath;

  @override
  void initState() {
    super.initState();
    _fetchStates();
    _prefillUserData();
  }

  void _prefillUserData() {
    // Prefill email and NIN from user profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileAsync = ref.read(userProfileProvider);
      profileAsync.whenData((profile) {
        if (profile != null && mounted) {
          final email = profile.data.email;
          final nin = profile.data.nin;
          if (email.isNotEmpty) {
            _emailController.text = email;
          }
          if (nin != null && nin.isNotEmpty) {
            _ninController.text = nin;
          }
        }
      });
    });
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
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ShimmerContainer(width: 150, height: 24),
                            const SizedBox(height: 8),
                            const ShimmerContainer(width: 200, height: 14),
                            const SizedBox(height: 24),
                            ...List.generate(
                                6,
                                (index) => const Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: ShimmerFormField(),
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
                              const SizedBox(height: 24),
                              const Text(
                                'Required Documents',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildFileUploader(
                                label: 'NIN Slip (Required)',
                                fileName: _selectedNinSlipFileName,
                                filePath: _selectedNinSlipFilePath,
                                onTap: () => _pickFile('nin'),
                              ),
                              const SizedBox(height: 16),
                              _buildFileUploader(
                                label: 'Profile Photo (Required)',
                                fileName: _selectedProfilePhotoFileName,
                                filePath: _selectedProfilePhotoFilePath,
                                onTap: () => _pickFile('profile'),
                                isImage: true,
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
                    if (_selectedNinSlipFilePath == null) {
                      Toast.error('Please upload your NIN slip', context);
                      return;
                    }
                    if (_selectedProfilePhotoFilePath == null) {
                      Toast.error('Please upload your profile photo', context);
                      return;
                    }
                    // Save Step 1 data to provider
                    final formData = ref.read(digitizationFormProvider);
                    formData.setStep1Data(
                      nin: _ninController.text.trim(),
                      email: _emailController.text.trim(),
                      phoneNumber: _phoneController.text.trim(),
                      stateValue: _selectedState!.name,
                      localGovernment: _selectedLG!.name,
                      fullName: _fullNameController.text.trim(),
                      ninSlipFilePath: _selectedNinSlipFilePath,
                      profilePhotoFilePath: _selectedProfilePhotoFilePath,
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

  Widget _buildFileUploader({
    required String label,
    String? fileName,
    String? filePath,
    required VoidCallback onTap,
    bool isImage = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
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
            child: filePath != null && isImage && _isImageFile(filePath)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(filePath),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFileUploadContent(fileName, onTap);
                      },
                    ),
                  )
                : _buildFileUploadContent(fileName, onTap),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadContent(String? fileName, VoidCallback onTap) {
    return Row(
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
                  color: fileName != null ? AppColors.green : Colors.grey[600],
                  fontSize: 14,
                  fontWeight:
                      fileName != null ? FontWeight.w500 : FontWeight.normal,
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
    );
  }

  bool _isImageFile(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    return extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'png' ||
        extension == 'gif';
  }

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type == 'profile'
          ? ['jpg', 'jpeg', 'png']
          : ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final file = File(filePath);
      if (await file.exists()) {
        final fileSize = await file.length();
        final fileSizeInMB = fileSize / (1024 * 1024);
        const maxSizeMB = 10.0;

        if (fileSizeInMB > maxSizeMB) {
          if (mounted) {
            Toast.error(
              'File is too large (${fileSizeInMB.toStringAsFixed(2)}MB). Maximum size is ${maxSizeMB}MB. Please compress or use a smaller file.',
              context,
              duration: 8,
            );
          }
          return;
        }

        setState(() {
          if (type == 'nin') {
            _selectedNinSlipFileName = result.files.single.name;
            _selectedNinSlipFilePath = filePath;
          } else if (type == 'profile') {
            _selectedProfilePhotoFileName = result.files.single.name;
            _selectedProfilePhotoFilePath = filePath;
          }
        });
      }
    }
  }
}
