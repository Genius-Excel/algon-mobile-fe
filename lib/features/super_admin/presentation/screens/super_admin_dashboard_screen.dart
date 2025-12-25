import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:algon_mobile/shared/widgets/super_admin_bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/super_admin/data/repository/super_admin_repository.dart';
import 'package:algon_mobile/features/super_admin/data/models/dashboard_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

@RoutePage(name: 'SuperAdminDashboard')
class SuperAdminDashboardScreen extends ConsumerStatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  ConsumerState<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState
    extends ConsumerState<SuperAdminDashboardScreen> {
  bool _isLoading = true;
  DashboardResponse? _dashboardData;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final superAdminRepo = ref.read(superAdminRepositoryProvider);
      final result = await superAdminRepo.getDashboard();

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _dashboardData = response;
              _isLoading = false;
            });
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
        Toast.error('Failed to load dashboard: ${e.toString()}', context);
      }
    }
  }

  String _formatNumber(int? value) {
    if (value == null) return '0';
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  String _formatCurrency(int? value) {
    if (value == null) return '₦0';
    if (value >= 1000000) {
      return '₦${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '₦${(value / 1000).toStringAsFixed(1)}K';
    }
    return '₦${value.toString()}';
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
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Text(
                    'ALGON Super Admin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _fetchDashboard,
                    ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Container(
                      color: const Color(0xFFF9FAFB),
                      child: const SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title shimmer
                            ShimmerContainer(
                              width: 150,
                              height: 28,
                            ),
                            SizedBox(height: 8),
                            ShimmerContainer(
                              width: 200,
                              height: 16,
                            ),
                            SizedBox(height: 24),
                            // Metric cards shimmer (2x2 grid)
                            Row(
                              children: [
                                Expanded(
                                  child: ShimmerMetricCard(),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ShimmerMetricCard(),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ShimmerMetricCard(),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ShimmerMetricCard(),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Chart shimmer
                            ShimmerChartCard(),
                            SizedBox(height: 24),
                            // Action buttons shimmer
                            Row(
                              children: [
                                Expanded(
                                  child: ShimmerActionButton(),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ShimmerActionButton(),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    )
                  : _dashboardData == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load dashboard',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _fetchDashboard,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : Container(
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: _MetricCard(
                                        icon: Icons.location_on,
                                        value: _dashboardData!.data.activeLgas
                                            .toString(),
                                        label: 'Active LGAs',
                                        color: const Color(0xFFE0F2FE),
                                        iconColor: const Color(0xFF0891B2),
                                        trend: _dashboardData!
                                            .data.metricCards.activeLgs.trend,
                                        percentChange: _dashboardData!
                                            .data
                                            .metricCards
                                            .activeLgs
                                            .percentChange,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _MetricCard(
                                        icon: Icons.description,
                                        value: _formatNumber(_dashboardData!
                                            .data
                                            .metricCards
                                            .certificatesIssued
                                            .value),
                                        label: 'Certificates',
                                        color: const Color(0xFFE8F5E3),
                                        iconColor: const Color(0xFF10B981),
                                        trend: _dashboardData!.data.metricCards
                                            .certificatesIssued.trend,
                                        percentChange: _dashboardData!
                                            .data
                                            .metricCards
                                            .certificatesIssued
                                            .percentChange,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _MetricCard(
                                        icon: Icons.trending_up,
                                        value: _dashboardData!.data.metricCards
                                                    .totalRevenue !=
                                                null
                                            ? _formatCurrency(_dashboardData!
                                                .data
                                                .metricCards
                                                .totalRevenue!
                                                .value)
                                            : '₦0',
                                        label: 'Total Revenue',
                                        color: const Color(0xFFDBEAFE),
                                        iconColor: const Color(0xFF3B82F6),
                                        trend: _dashboardData!.data.metricCards
                                            .totalRevenue?.trend,
                                        percentChange: _dashboardData!
                                            .data
                                            .metricCards
                                            .totalRevenue
                                            ?.percentChange,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _MetricCard(
                                        icon: Icons.schedule,
                                        value: _formatNumber(_dashboardData!
                                            .data
                                            .metricCards
                                            .totalApplications
                                            .value),
                                        label: 'Total Applications',
                                        color: const Color(0xFFFEF3C7),
                                        iconColor: const Color(0xFFF59E0B),
                                        trend: _dashboardData!.data.metricCards
                                            .totalApplications.trend,
                                        percentChange: _dashboardData!
                                            .data
                                            .metricCards
                                            .totalApplications
                                            .percentChange,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (_dashboardData!
                                    .data.monthlyRevenue.isNotEmpty)
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Monthly Revenue Trend (₦'000)",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          height: 200,
                                          child: _RevenueChart(
                                            monthlyData: _dashboardData!
                                                .data.monthlyRevenue,
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
                                        onTap: () => context.router.pushNamed(
                                            '/super-admin/manage-lgas'),
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
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
                                        onTap: () => context.router.pushNamed(
                                            '/super-admin/system-settings'),
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
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
  final String? trend;
  final double? percentChange;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.iconColor,
    this.trend,
    this.percentChange,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppStyles.textStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.greyDark,
                  ),
                ),
              ),
              if (trend != null && percentChange != null) ...[
                Icon(
                  trend == 'up' ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: trend == 'up' ? AppColors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '${percentChange!.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: trend == 'up' ? AppColors.green : Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  final List<MonthlyData> monthlyData;

  const _RevenueChart({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return const Center(
        child: Text('No revenue data available'),
      );
    }

    // Find max value for scaling
    int maxValue = 4000; // Default max
    final values = monthlyData.map((item) => item.total).toList();
    if (values.isNotEmpty) {
      maxValue = values.reduce((a, b) => a > b ? a : b);
      if (maxValue == 0) maxValue = 4000;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: monthlyData.map((item) {
        String monthLabel = item.month;
        try {
          if (item.month.isNotEmpty) {
            final date = DateTime.parse(item.month);
            const months = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec'
            ];
            monthLabel = months[date.month - 1];
          }
        } catch (e) {
          monthLabel = item.month;
        }
        return _ChartBar(
          month: monthLabel,
          value: item.total,
          max: maxValue,
        );
      }).toList(),
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
          height: height > 0 ? height : 4,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 40,
          child: Text(
            month,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
