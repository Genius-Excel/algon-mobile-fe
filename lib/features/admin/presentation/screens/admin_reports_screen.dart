import 'package:algon_mobile/shared/widgets/margin.dart';
import 'package:algon_mobile/src/res/styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/shared/widgets/admin_bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/admin/data/repository/admin_repository.dart';
import 'package:algon_mobile/features/admin/data/models/admin_reports_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:intl/intl.dart';

@RoutePage(name: 'AdminReports')
class AdminReportsScreen extends ConsumerStatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  ConsumerState<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends ConsumerState<AdminReportsScreen> {
  bool _isLoading = true;
  AdminReportsData? _reportsData;

  @override
  void initState() {
    super.initState();
    _fetchReportAnalytics();
  }

  Future<void> _fetchReportAnalytics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final adminRepo = ref.read(adminRepositoryProvider);
      final result = await adminRepo.getReportAnalytics();

      result.when(
        success: (AdminReportsResponse response) {
          if (mounted) {
            setState(() {
              _reportsData = response.data;
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
        Toast.error('Failed to load reports: ${e.toString()}', context);
      }
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '₦${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '₦${(value / 1000).toStringAsFixed(1)}K';
    }
    return '₦${value.toStringAsFixed(0)}';
  }

  String _formatMonth(String isoDateString) {
    try {
      final date = DateTime.parse(isoDateString);
      return DateFormat('MMM').format(date);
    } catch (e) {
      return isoDateString;
    }
  }

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
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.router.maybePop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Reports & Analytics',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _reportsData == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No data available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                text: 'Retry',
                                onPressed: _fetchReportAnalytics,
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchReportAnalytics,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Summary card
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color:
                                          AppColors.greyDark.withOpacity(0.3),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Summary',
                                        style: AppStyles.textStyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      const ColSpacing(40),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _SummaryMetric(
                                              value: _reportsData!
                                                  .metricCards.totalRequests
                                                  .toString(),
                                              label: 'Total Requests',
                                            ),
                                          ),
                                          Expanded(
                                            child: _SummaryMetric(
                                              value: _formatCurrency(
                                                  _reportsData!.metricCards
                                                      .totalRevenue),
                                              label: 'Total Revenue',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const ColSpacing(20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _SummaryMetric(
                                              value:
                                                  '${_reportsData!.metricCards.approvalRate.toStringAsFixed(1)}%',
                                              label: 'Approval Rate',
                                            ),
                                          ),
                                          Expanded(
                                            child: _SummaryMetric(
                                              value:
                                                  '${_reportsData!.metricCards.averageProcessingDays.toStringAsFixed(1)}d',
                                              label: 'Avg. Processing',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Monthly Applications chart
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Monthly Applications',
                                        style: AppStyles.textStyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _MonthlyBarChart(
                                        monthlyData:
                                            _reportsData!.monthlyBreakdown,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Status Distribution
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Status Distribution',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: _DonutChart(
                                            statusDistribution: _reportsData!
                                                .statusDistribution,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Column(
                                        children: [
                                          _StatusLegendItem(
                                            color: const Color(0xFF10B981),
                                            label:
                                                'Approved: ${_reportsData!.statusDistribution.approved}',
                                          ),
                                          const SizedBox(height: 8),
                                          _StatusLegendItem(
                                            color: const Color(0xFFFFA500),
                                            label:
                                                'Pending: ${_reportsData!.statusDistribution.pending}',
                                          ),
                                          const SizedBox(height: 8),
                                          _StatusLegendItem(
                                            color: const Color(0xFFEF4444),
                                            label:
                                                'Rejected: ${_reportsData!.statusDistribution.rejected}',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                                const ColSpacing(16),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    text: 'Export as CSV',
                                    iconData: Icons.download,
                                    onPressed: () {},
                                  ),
                                ),
                                const ColSpacing(12),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    text: 'Export as Excel',
                                    variant: ButtonVariant.outline,
                                    iconData: Icons.download,
                                    onPressed: () {},
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
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryMetric({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppStyles.textStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
          ),
        ),
        const ColSpacing(4),
        Text(
          label,
          style: AppStyles.textStyle.copyWith(
            fontSize: 14,
            color: AppColors.greyDark,
          ),
        ),
      ],
    );
  }
}

class _MonthlyBarChart extends StatelessWidget {
  final MonthlyBreakdown monthlyData;

  const _MonthlyBarChart({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    // Combine certificate and digitization data by month
    final Map<String, int> combinedData = {};

    for (var item in monthlyData.certificate) {
      final monthKey = item.month;
      combinedData[monthKey] = (combinedData[monthKey] ?? 0) + item.total;
    }

    for (var item in monthlyData.digitizations) {
      final monthKey = item.month;
      combinedData[monthKey] = (combinedData[monthKey] ?? 0) + item.total;
    }

    // Sort by month
    final sortedMonths = combinedData.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    if (sortedMonths.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No monthly data available',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }

    final data = sortedMonths.map((month) => combinedData[month]!).toList();
    final max = data.reduce((a, b) => a > b ? a : b).toDouble();
    final labels = sortedMonths.map((month) {
      try {
        final date = DateTime.parse(month);
        return DateFormat('MMM').format(date);
      } catch (e) {
        return month;
      }
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < labels.length; i++)
            Padding(
              padding: EdgeInsets.only(
                right: i < labels.length - 1 ? 8 : 0,
              ),
              child: Column(
                children: [
                  Container(
                    width: 30,
                    height: max > 0 ? (data[i] / max) * 120 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF065F46),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[i],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  final StatusDistribution statusDistribution;

  const _DonutChart({required this.statusDistribution});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutChartPainter(statusDistribution: statusDistribution),
      child: const Center(
        child: Text(''),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final StatusDistribution statusDistribution;

  _DonutChartPainter({required this.statusDistribution});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    final total = statusDistribution.approved +
        statusDistribution.pending +
        statusDistribution.rejected;

    if (total == 0) {
      // Draw empty circle if no data
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 40;
      canvas.drawArc(rect, 0, 6.28, false, paint);
      return;
    }

    // Calculate percentages
    final approvedPercent = statusDistribution.approved / total;
    final pendingPercent = statusDistribution.pending / total;
    final rejectedPercent = statusDistribution.rejected / total;

    // Draw segments
    final segments = [
      (const Color(0xFF10B981), approvedPercent), // Approved
      (const Color(0xFFFFA500), pendingPercent), // Pending
      (const Color(0xFFEF4444), rejectedPercent), // Rejected
    ];

    double startAngle = -1.57; // Start from top
    for (final (color, percentage) in segments) {
      if (percentage > 0) {
        final sweepAngle = percentage * 6.28; // 2 * PI
        final rect = Rect.fromCircle(center: center, radius: radius);
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 40;

        canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
        startAngle += sweepAngle;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatusLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusLegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
