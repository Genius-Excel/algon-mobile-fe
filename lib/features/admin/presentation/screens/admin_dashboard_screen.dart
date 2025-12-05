import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/admin_bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';
import 'package:algon_mobile/features/admin/data/repository/admin_repository.dart';
import 'package:algon_mobile/features/admin/data/models/admin_dashboard_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';

import '../../../../shared/widgets/margin.dart';

@RoutePage(name: 'AdminDashboard')
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool _isLoading = true;
  AdminDashboardResponse? _dashboardData;

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
      final adminRepo = ref.read(adminRepositoryProvider);
      final result = await adminRepo.getDashboard();

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

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  String _formatCurrency(int value) {
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
                    'ALGON Admin',
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
                      child: CircularProgressIndicator.adaptive(
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
                  ? const Center(child: CircularProgressIndicator())
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
                      : SingleChildScrollView(
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
                                _dashboardData!
                                        .data.recentApplications.isNotEmpty
                                    ? '${_dashboardData!.data.recentApplications.first.localGovernment.name} LGA, ${_dashboardData!.data.recentApplications.first.state.name} State'
                                    : 'Local Government Admin',
                                style: AppStyles.textStyle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.greyDark,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Expanded(
                                    child: _MetricCard(
                                      icon: Icons.schedule,
                                      iconColor: const Color(0xFFFFA500),
                                      value: _dashboardData!.data.metricCards
                                          .pendingApplications.value
                                          .toString(),
                                      label: 'Pending',
                                      color: const Color(0xFFFFF7ED),
                                      trend: _dashboardData!.data.metricCards
                                          .pendingApplications.trend,
                                      percentChange: _dashboardData!
                                          .data
                                          .metricCards
                                          .pendingApplications
                                          .changePercent,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _MetricCard(
                                      icon: Icons.check_circle,
                                      iconColor: const Color(0xFF10B981),
                                      value: _dashboardData!.data.metricCards
                                          .approvedCertificates.value
                                          .toString(),
                                      label: 'Approved',
                                      color: const Color(0xFFE8F5E3),
                                      trend: _dashboardData!.data.metricCards
                                          .approvedCertificates.trend,
                                      percentChange: _dashboardData!
                                          .data
                                          .metricCards
                                          .approvedCertificates
                                          .changePercent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _MetricCard(
                                      icon: Icons.cancel,
                                      iconColor: const Color(0xFFEF4444),
                                      value: _dashboardData!
                                          .data.metricCards.rejected.value
                                          .toString(),
                                      label: 'Rejected',
                                      color: const Color(0xFFFEE2E2),
                                      trend: _dashboardData!
                                          .data.metricCards.rejected.trend,
                                      percentChange: _dashboardData!.data
                                          .metricCards.rejected.changePercent,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _MetricCard(
                                      icon: Icons.attach_money,
                                      iconColor: const Color(0xFF10B981),
                                      value: _formatCurrency(_dashboardData!
                                          .data.metricCards.totalRevenue.value),
                                      label: 'Revenue',
                                      color: const Color(0xFFE8F5E3),
                                      trend: _dashboardData!
                                          .data.metricCards.totalRevenue.trend,
                                      percentChange: _dashboardData!
                                          .data
                                          .metricCards
                                          .totalRevenue
                                          .changePercent,
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
                              const SizedBox(height: 8),
                              Text(
                                'Total: ${_dashboardData!.data.weeklyApplications} applications this week',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
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
                                child: _WeeklyApplicationsChart(
                                  totalCount:
                                      _dashboardData!.data.weeklyApplications,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Approval Statistics
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.green.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.trending_up,
                                        color: AppColors.green,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Approval Statistics',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${_dashboardData!.data.approvalStatistics}%',
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              if (_dashboardData!
                                  .data.recentApplications.isNotEmpty) ...[
                                const Text(
                                  'Recent Applications',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ..._dashboardData!.data.recentApplications
                                    .map((app) => _RecentApplicationCard(
                                          application: app,
                                        )),
                              ],
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: _QuickActionButton(
                                      icon: Icons.description,
                                      label: 'Applications',
                                      onTap: () => context.router
                                          .pushNamed('/admin/applications'),
                                    ),
                                  ),
                                  const RowSpacing(16),
                                  Expanded(
                                    child: _QuickActionButton(
                                      icon: Icons.bar_chart,
                                      label: 'Reports',
                                      onTap: () => context.router
                                          .pushNamed('/admin/reports'),
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
  final String? trend;
  final double? percentChange;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.color,
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

class _RecentApplicationCard extends StatelessWidget {
  final RecentApplication application;

  const _RecentApplicationCard({required this.application});

  @override
  Widget build(BuildContext context) {
    final status = ApplicationStatus.fromString(application.applicationStatus);
    final paymentStatus = application.paymentStatus;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greyDark.withOpacity(0.1),
          width: 1,
        ),
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      application.nin,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: status.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status.icon,
                      size: 16,
                      color: status.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${application.localGovernment.name}, ${application.state.name}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                paymentStatus == 'paid' ? Icons.check_circle : Icons.schedule,
                size: 16,
                color: paymentStatus == 'paid'
                    ? AppColors.green
                    : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Payment: ${paymentStatus.toUpperCase()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: paymentStatus == 'paid'
                      ? AppColors.green
                      : Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                DateFormatter.formatDisplayDate(application.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyApplicationsChart extends StatelessWidget {
  final int totalCount;

  const _WeeklyApplicationsChart({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    // Since API only returns total count, distribute it evenly across 7 days for visualization
    // Or show it as a single bar representing the week
    final dailyAverage = totalCount > 0 ? (totalCount / 7).ceil() : 0;
    final data = List.generate(7, (index) {
      // Distribute the total count across the week with slight variations for realism
      if (index < totalCount % 7) {
        return dailyAverage + 1;
      }
      return dailyAverage;
    });
    final max = data.isNotEmpty && data.any((d) => d > 0)
        ? data.reduce((a, b) => a > b ? a : b).toDouble()
        : 1.0;
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(data.length, (index) {
          final height = max > 0 ? (data[index] / max) * 150 : 4.0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: height > 0 ? height : 4,
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
              const SizedBox(height: 4),
              Text(
                data[index].toString(),
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }),
      ),
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
