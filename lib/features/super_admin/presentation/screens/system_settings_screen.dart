import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/super_admin_bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/admin_bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/auth/data/services/auth_service.dart';
import 'package:algon_mobile/features/admin/data/repository/admin_repository.dart';
import 'package:algon_mobile/features/admin/data/models/lga_fee_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'SystemSettings')
class SystemSettingsScreen extends ConsumerStatefulWidget {
  final bool isSuperAdmin;

  const SystemSettingsScreen({
    super.key,
    this.isSuperAdmin = false,
  });

  @override
  ConsumerState<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  final _certificateTitleController =
      TextEditingController(text: 'Certificate of Indigeneship');
  final _validityPeriodController = TextEditingController(text: '5');
  final _applicationFeeController = TextEditingController();
  final _digitizationFeeController = TextEditingController();
  final _regenerationFeeController = TextEditingController();

  bool _onlinePaymentEnabled = true;
  bool _qrCodeVerificationEnabled = true;
  bool _publicVerificationPortalEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _smsNotificationsEnabled = true;
  bool _isLoading = false;
  bool _isLoadingFees = true;

  @override
  void initState() {
    super.initState();
    _loadLgaFees();
  }

  @override
  void dispose() {
    _certificateTitleController.dispose();
    _validityPeriodController.dispose();
    _applicationFeeController.dispose();
    _digitizationFeeController.dispose();
    _regenerationFeeController.dispose();
    super.dispose();
  }

  Future<void> _loadLgaFees() async {
    try {
      final adminRepo = ref.read(adminRepositoryProvider);
      final result = await adminRepo.getLgaFee();

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _isLoadingFees = false;
              // If there's existing fee data, populate the fields
              if (response.data.isNotEmpty) {
                final feeData = response.data.first;
                _applicationFeeController.text = feeData.applicationFee;
                _digitizationFeeController.text = feeData.digitizationFee;
                _regenerationFeeController.text = feeData.regenerationFee;
              } else {
                // Set default values
                _applicationFeeController.text = '0';
                _digitizationFeeController.text = '0';
                _regenerationFeeController.text = '0';
              }
            });
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingFees = false;
              // Set default values on error
              _applicationFeeController.text = '0';
              _digitizationFeeController.text = '0';
              _regenerationFeeController.text = '0';
            });
            if (error is ApiExceptions) {
              Toast.apiError(error, context);
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFees = false;
          _applicationFeeController.text = '0';
          _digitizationFeeController.text = '0';
          _regenerationFeeController.text = '0';
        });
      }
    }
  }

  Future<void> _saveLgaFees() async {
    // Validate input
    final applicationFeeText = _applicationFeeController.text.trim();
    final digitizationFeeText = _digitizationFeeController.text.trim();
    final regenerationFeeText = _regenerationFeeController.text.trim();

    if (applicationFeeText.isEmpty) {
      Toast.error('Please enter an application fee', context);
      return;
    }

    final applicationFee = double.tryParse(applicationFeeText);
    final digitizationFee = double.tryParse(
        digitizationFeeText.isEmpty ? '0' : digitizationFeeText);
    final regenerationFee = double.tryParse(
        regenerationFeeText.isEmpty ? '0' : regenerationFeeText);

    if (applicationFee == null) {
      Toast.error('Please enter a valid application fee', context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final adminRepo = ref.read(adminRepositoryProvider);
      final request = CreateLGAFeeRequest(
        applicationFee: applicationFee,
        digitizationFee: digitizationFee ?? 0.0,
        regenerationFee: regenerationFee ?? 0.0,
      );

      final result = await adminRepo.createOrUpdateLgaFee(request);

      result.when(
        success: (feeData) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            Toast.success('Fee configuration saved successfully', context);
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoading = false;
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
          _isLoading = false;
        });
        Toast.error('Failed to save fees: ${e.toString()}', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.router.maybePop(),
                  ),
                  const Text(
                    'System Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF9FAFB),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SettingsSection(
                        title: 'Certificate Template',
                        children: [
                          CustomTextField(
                            controller: _certificateTitleController,
                            label: 'Certificate Title',
                            hint: 'Enter certificate title',
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _validityPeriodController,
                            label: 'Validity Period (years)',
                            hint: 'Enter validity period',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SettingsSection(
                        title: 'Payment Configuration',
                        children: [
                          if (_isLoadingFees)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else ...[
                            CustomTextField(
                              controller: _applicationFeeController,
                              label: 'Application Fee (₦)',
                              hint: 'Enter application fee',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _digitizationFeeController,
                              label: 'Digitization Fee (₦)',
                              hint: 'Enter digitization fee',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _regenerationFeeController,
                              label: 'Regeneration Fee (₦)',
                              hint: 'Enter regeneration fee',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                            const SizedBox(height: 16),
                            _ToggleSetting(
                              title: 'Enable Online Payment',
                              description: 'Allow card and bank payments',
                              value: _onlinePaymentEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _onlinePaymentEnabled = value;
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SettingsSection(
                        title: 'Verification Settings',
                        children: [
                          _ToggleSetting(
                            title: 'QR Code Verification',
                            description: 'Enable QR code scanning',
                            value: _qrCodeVerificationEnabled,
                            onChanged: (value) {
                              setState(() {
                                _qrCodeVerificationEnabled = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _ToggleSetting(
                            title: 'Public Verification Portal',
                            description: 'Allow public access to verify',
                            value: _publicVerificationPortalEnabled,
                            onChanged: (value) {
                              setState(() {
                                _publicVerificationPortalEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SettingsSection(
                        title: 'Notifications',
                        children: [
                          _ToggleSetting(
                            title: 'Email Notifications',
                            description: 'Send email updates',
                            value: _emailNotificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _emailNotificationsEnabled = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _ToggleSetting(
                            title: 'SMS Notifications',
                            description: 'Send SMS alerts',
                            value: _smsNotificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _smsNotificationsEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SettingsSection(
                        title: 'Account',
                        children: [
                          _LogoutButton(
                            onTap: () async {
                              // Show confirmation dialog
                              final shouldLogout = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                    'Are you sure you want to logout?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              );

                              if (shouldLogout == true && context.mounted) {
                                await AuthService.logout();
                                if (context.mounted) {
                                  context.router.replaceNamed('/login');
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: _isLoading ? 'Saving...' : 'Save Changes',
                onPressed: (_isLoading || _isLoadingFees) ? null : _saveLgaFees,
                isLoading: _isLoading,
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.isSuperAdmin
          ? const SuperAdminBottomNavBar(currentIndex: 3)
          : const AdminBottomNavBar(currentIndex: 3),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSetting({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.green,
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout,
                color: Color(0xFFEF4444),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sign out of super admin panel',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
