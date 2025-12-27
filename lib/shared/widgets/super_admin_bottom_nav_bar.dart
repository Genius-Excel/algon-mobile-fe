import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import '../../core/router/router.dart';

class SuperAdminBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const SuperAdminBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
                isActive: currentIndex == 0,
                onTap: () {
                  if (currentIndex != 0) {
                    context.router.pushNamed('/super-admin/dashboard');
                  }
                },
              ),
              _NavItem(
                icon: Icons.group,
                label: 'LGAs',
                isActive: currentIndex == 1,
                onTap: () {
                  if (currentIndex != 1) {
                    context.router.pushNamed('/super-admin/manage-lgas');
                  }
                },
              ),
              _NavItem(
                icon: Icons.description,
                label: 'Logs',
                isActive: currentIndex == 2,
                onTap: () {
                  if (currentIndex != 2) {
                    context.router.pushNamed('/super-admin/audit-log');
                  }
                },
              ),
              _NavItem(
                icon: Icons.settings,
                label: 'Settings',
                isActive: currentIndex == 3,
                onTap: () {
                  if (currentIndex != 3) {
                    context.router.push(SystemSettings(isSuperAdmin: true));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.green : const Color(0xFF9CA3AF),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? AppColors.green : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
