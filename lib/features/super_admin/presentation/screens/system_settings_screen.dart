import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/custom_text_field.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';

@RoutePage(name: 'SystemSettings')
class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  final _certificateTitleController = TextEditingController(text: 'Certificate of Indigeneship');
  final _validityPeriodController = TextEditingController(text: '5');
  final _applicationFeeController = TextEditingController(text: '5000');

  bool _onlinePaymentEnabled = true;
  bool _qrCodeVerificationEnabled = true;
  bool _publicVerificationPortalEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _smsNotificationsEnabled = true;

  @override
  void dispose() {
    _certificateTitleController.dispose();
    _validityPeriodController.dispose();
    _applicationFeeController.dispose();
    super.dispose();
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
                          CustomTextField(
                            controller: _applicationFeeController,
                            label: 'Application Fee (₦)',
                            hint: 'Enter application fee',
                            keyboardType: TextInputType.number,
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: 'Save Changes',
                onPressed: () {
                  // TODO: Implement save logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully'),
                    ),
                  );
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
          activeColor: AppColors.green,
        ),
      ],
    );
  }
}

