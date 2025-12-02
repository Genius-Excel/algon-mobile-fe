import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/admin_bottom_nav_bar.dart';

import '../../../../shared/widgets/margin.dart';

@RoutePage(name: 'AdminDashboard')
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'ALGON Admin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Dashboard',
                      style: AppStyles.textStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const ColSpacing(8),
                    Text(
                      'Ikeja LGA, Lagos State',
                      style: AppStyles.textStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.greyDark,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Metrics grid
                    const Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.schedule,
                            iconColor: Color(0xFFFFA500),
                            value: '45',
                            label: 'Pending',
                            color: Color(0xFFFFF7ED),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.check_circle,
                            iconColor: Color(0xFF10B981),
                            value: '128',
                            label: 'Approved',
                            color: Color(0xFFE8F5E3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.description,
                            iconColor: Color(0xFF0891B2),
                            value: '8',
                            label: 'Digitization',
                            color: Color(0xFFE6F2F5),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.attach_money,
                            iconColor: Color(0xFF10B981),
                            value: '₦656K',
                            label: 'Revenue',
                            color: Color(0xFFE8F5E3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Weekly Applications Chart
                    const Text(
                      'Weekly Applications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.greyDark.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const _SimpleBarChart(),
                    ),
                    const SizedBox(height: 24),
                    // Quick actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: _QuickActionButton(
                            icon: Icons.description,
                            label: 'Applications',
                            onTap: () =>
                                context.router.pushNamed('/admin/applications'),
                          ),
                        ),
                        const RowSpacing(16),
                        Expanded(
                          child: _QuickActionButton(
                            icon: Icons.bar_chart,
                            label: 'Reports',
                            onTap: () =>
                                context.router.pushNamed('/admin/reports'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 0),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppStyles.textStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
          ),
          const ColSpacing(8),
          Text(
            label,
            style: AppStyles.textStyle.copyWith(
              fontSize: 14,
              color: AppColors.greyDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  const _SimpleBarChart();

  @override
  Widget build(BuildContext context) {
    final data = [12, 19, 15, 22, 27, 18, 9]; // Mon-Sun values
    final max = data.reduce((a, b) => a > b ? a : b).toDouble();
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(data.length, (index) {
        final height = (data[index] / max) * 150;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFF065F46),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              labels[index],
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.greyDark.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF065F46)),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
