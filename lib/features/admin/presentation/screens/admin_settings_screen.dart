import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/admin_bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/super_admin_bottom_nav_bar.dart';

@RoutePage(name: 'AdminSettings')
class AdminSettingsScreen extends StatelessWidget {
  final bool isSuperAdmin;

  const AdminSettingsScreen({
    super.key,
    this.isSuperAdmin = false,
  });

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
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    isSuperAdmin ? 'LGCIVS Super Admin' : 'LGCIVS Admin',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _SettingsItem(
                              title: 'System Configuration',
                              subtitle: 'Configure global settings',
                              icon: Icons.settings,
                              onTap: () => context.router.pushNamed('/super-admin/system-settings'),
                            ),
                            const Divider(),
                            _SettingsItem(
                              title: 'Audit Logs',
                              subtitle: 'View system activity',
                              icon: Icons.description,
                              onTap: () => context.router.pushNamed('/super-admin/audit-log'),
                            ),
                            const Divider(),
                            _SettingsItem(
                              title: 'Backup & Security',
                              subtitle: 'Manage system backups',
                              icon: Icons.backup,
                              onTap: () {},
                            ),
                            const Divider(),
                            _SettingsItem(
                              title: 'Logout',
                              subtitle: 'Sign out of admin panel',
                              icon: Icons.logout,
                              textColor: const Color(0xFFEF4444),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isSuperAdmin
          ? const SuperAdminBottomNavBar(currentIndex: 3)
          : const AdminBottomNavBar(currentIndex: 3),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color textColor;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.textColor = const Color(0xFF1F2937),
    required this.onTap,
  });

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
                color: const Color(0xFFE8F5E3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF065F46), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
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
