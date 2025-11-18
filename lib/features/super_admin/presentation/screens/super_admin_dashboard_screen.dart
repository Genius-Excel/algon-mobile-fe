import 'package:algon_mobile/features/super_admin/presentation/widgets/national_coverage_section.dart';
import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/super_admin_bottom_nav_bar.dart';

@RoutePage(name: 'SuperAdminDashboard')
class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

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
              child: const Row(
                children: [
                  Text(
                    'LGCIVS Super Admin',
                    style: TextStyle(
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
                color: const Color(0xFFF9FAFB),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Super Admin',
                        style: AppStyles.textStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const ColSpacing(4),
                      Text(
                        'National Overview',
                        style: AppStyles.textStyle.copyWith(
                          fontSize: 14,
                          color: AppColors.greyDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              icon: Icons.location_on,
                              value: '774',
                              label: 'Active LGAs',
                              color: Color(0xFFE0F2FE),
                              iconColor: Color(0xFF0891B2),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              icon: Icons.description,
                              value: '45.2K',
                              label: 'Certificates',
                              color: Color(0xFFE8F5E3),
                              iconColor: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              icon: Icons.trending_up,
                              value: '₦226M',
                              label: 'Total Revenue',
                              color: Color(0xFFDBEAFE),
                              iconColor: Color(0xFF3B82F6),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              icon: Icons.schedule,
                              value: '1.2K',
                              label: 'Pending',
                              color: Color(0xFFFEF3C7),
                              iconColor: Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const NationalCoverageSection(),
                      const ColSpacing(15),
                      Container(
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
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Monthly Revenue Trend (₦'000)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              height: 200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _ChartBar(
                                      month: 'Jan', value: 2400, max: 4000),
                                  _ChartBar(
                                      month: 'Feb', value: 2800, max: 4000),
                                  _ChartBar(
                                      month: 'Mar', value: 2600, max: 4000),
                                  _ChartBar(
                                      month: 'Apr', value: 3000, max: 4000),
                                  _ChartBar(
                                      month: 'May', value: 3200, max: 4000),
                                  _ChartBar(
                                      month: 'Jun', value: 3600, max: 4000),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.router
                                  .pushNamed('/super-admin/manage-lgas'),
                              child: Container(
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
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.group,
                                      size: 32,
                                      color: AppColors.green,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Manage LGAs',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.router
                                  .pushNamed('/super-admin/system-settings'),
                              child: Container(
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
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: 32,
                                      color: AppColors.green,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Settings',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SuperAdminBottomNavBar(currentIndex: 0),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color iconColor;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.iconColor,
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
          Icon(icon, color: iconColor, size: 24),
          const ColSpacing(15),
          Text(
            value,
            style: AppStyles.textStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
          ),
          const ColSpacing(15),
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

class _ChartBar extends StatelessWidget {
  final String month;
  final int value;
  final int max;

  const _ChartBar({
    required this.month,
    required this.value,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final height = (value / max) * 150;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          month,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
