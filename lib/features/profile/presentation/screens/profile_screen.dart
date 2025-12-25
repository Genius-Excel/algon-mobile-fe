import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/features/auth/data/services/auth_service.dart';
import 'package:algon_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:algon_mobile/features/auth/data/models/user_profile_models.dart';

@RoutePage(name: 'Profile')
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: const EdgeInsets.all(24),
              child: const Row(
                children: [
                  Text(
                    'ALGON',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Profile content
            Expanded(
              child: profileAsync.when(
                data: (UserProfileResponse? profileResponse) {
                  if (profileResponse == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Failed to load profile',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'Retry',
                            onPressed: () {
                              ref.invalidate(userProfileProvider);
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  final profile = profileResponse.data;
                  return SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Avatar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F5E3),
                              shape: BoxShape.circle,
                            ),
                            child: profile.profileImage != null &&
                                    profile.profileImage!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      profile.profileImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Color(0xFF065F46),
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Color(0xFF065F46),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            profile.fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Email
                          Text(
                            profile.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Info card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (profile.nin != null && profile.nin!.isNotEmpty)
                                  _InfoRow(label: 'NIN', value: profile.nin!),
                                if (profile.nin != null && profile.nin!.isNotEmpty)
                                  const Divider(height: 24),
                                if (profile.phoneNumber != null &&
                                    profile.phoneNumber!.isNotEmpty)
                                  _InfoRow(
                                    label: 'Phone',
                                    value: profile.phoneNumber!,
                                  ),
                                if (profile.phoneNumber != null &&
                                    profile.phoneNumber!.isNotEmpty)
                                  const Divider(height: 24),
                                _InfoRow(
                                  label: 'Username',
                                  value: profile.username,
                                ),
                                const Divider(height: 24),
                                _InfoRow(
                                  label: 'Account Status',
                                  value: profile.accountStatus.toUpperCase(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Edit Profile button
                          CustomButton(
                            text: 'Edit Profile',
                            variant: ButtonVariant.outline,
                            backgroundColor: const Color(0xFFF9FAFB),
                            textColor: const Color(0xFF1F2937),
                            onPressed: () {},
                            isFullWidth: true,
                          ),
                          const SizedBox(height: 16),
                          // Logout button
                          CustomButton(
                            text: 'Logout',
                            variant: ButtonVariant.primary,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            onPressed: () async {
                              // Show confirmation dialog
                              final shouldLogout = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Logout'),
                                    content: const Text(
                                      'Are you sure you want to logout?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop(false);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop(true);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldLogout == true && context.mounted) {
                                await AuthService.logoutAndNavigate(context);
                              }
                            },
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading profile: ${error.toString()}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Retry',
                          onPressed: () {
                            ref.invalidate(userProfileProvider);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
