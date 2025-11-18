import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/super_admin_bottom_nav_bar.dart';

@RoutePage(name: 'AuditLog')
class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Audit Log',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'System activity history',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF9FAFB),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _AuditLogItem(
                      icon: Icons.check_circle,
                      iconColor: AppColors.green,
                      title: 'Certificate Approved',
                      actor: 'Abubakar Ibrahim',
                      location: 'Ikeja LGA',
                      timestamp: '2 hours ago',
                      role: 'LG Admin',
                      roleColor: const Color(0xFFDBEAFE),
                      roleTextColor: const Color(0xFF1E40AF),
                    ),
                    const SizedBox(height: 12),
                    _AuditLogItem(
                      icon: Icons.shield,
                      iconColor: const Color(0xFF3B82F6),
                      title: 'Admin Created',
                      actor: 'System Administrator',
                      location: 'All Nigeria',
                      timestamp: '5 hours ago',
                      role: 'Super Admin',
                      roleColor: const Color(0xFFE9D5FF),
                      roleTextColor: const Color(0xFF7C3AED),
                    ),
                    const SizedBox(height: 12),
                    _AuditLogItem(
                      icon: Icons.check_circle,
                      iconColor: AppColors.green,
                      title: 'Certificate Approved',
                      actor: 'Chidinma Okafor',
                      location: 'Owerri Municipal',
                      timestamp: '1 day ago',
                      role: 'LG Admin',
                      roleColor: const Color(0xFFDBEAFE),
                      roleTextColor: const Color(0xFF1E40AF),
                    ),
                    const SizedBox(height: 12),
                    _AuditLogItem(
                      icon: Icons.settings,
                      iconColor: Colors.grey,
                      title: 'Settings Updated',
                      actor: 'System Administrator',
                      location: 'All Nigeria',
                      timestamp: '1 day ago',
                      role: 'Super Admin',
                      roleColor: const Color(0xFFE9D5FF),
                      roleTextColor: const Color(0xFF7C3AED),
                    ),
                    const SizedBox(height: 12),
                    _AuditLogItem(
                      icon: Icons.cancel,
                      iconColor: const Color(0xFFEF4444),
                      title: 'Certificate Rejected',
                      actor: 'Mohammed Yusuf',
                      location: 'Kano Municipal',
                      timestamp: '2 days ago',
                      role: 'LG Admin',
                      roleColor: const Color(0xFFDBEAFE),
                      roleTextColor: const Color(0xFF1E40AF),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SuperAdminBottomNavBar(currentIndex: 2),
    );
  }
}

class _AuditLogItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String actor;
  final String location;
  final String timestamp;
  final String role;
  final Color roleColor;
  final Color roleTextColor;

  const _AuditLogItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.actor,
    required this.location,
    required this.timestamp,
    required this.role,
    required this.roleColor,
    required this.roleTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
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
                  actor,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: roleColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: roleTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

