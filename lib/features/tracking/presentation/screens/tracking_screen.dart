import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/shared/widgets/bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/features/application/data/models/application_list_models.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';

@RoutePage(name: 'Tracking')
class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  bool _isLoading = true;
  List<ApplicationItem> _applications = [];

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final result = await applicationRepo.getMyApplications();

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              _applications = response.data;
              _isLoading = false;
            });
            print('✅ Loaded ${_applications.length} applications in tracking screen');
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
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Toast.error('An unexpected error occurred: ${e.toString()}', context);
      }
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
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
            // Application Tracking content
            Expanded(
              child: Container(
                color: const Color(0xFFF9FAFB),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Application Tracking',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _applications.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No applications found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _fetchApplications,
                                  child: ListView.builder(
                                    itemCount: _applications.length,
                                    itemBuilder: (context, index) {
                                      final application = _applications[index];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              index < _applications.length - 1
                                                  ? 16
                                                  : 0,
                                        ),
                                        child: _TrackingCard(
                                          application: application,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}

class _TrackingCard extends StatelessWidget {
  final ApplicationItem application;

  const _TrackingCard({
    required this.application,
  });

  ApplicationStatus get _status {
    return ApplicationStatus.fromString(application.applicationStatus);
  }

  String get _location {
    return '${application.localGovernment.name}, ${application.state.name}';
  }

  String get _description {
    switch (_status) {
      case ApplicationStatus.approved:
        return 'Application approved. Certificate ready for download.';
      case ApplicationStatus.rejected:
        return application.remarks ?? 'Application has been rejected.';
      case ApplicationStatus.digitized:
        return 'Digitization complete. Digital certificate issued.';
      case ApplicationStatus.underReview:
        return 'Under review by local government admin.';
      case ApplicationStatus.pending:
      default:
        if (application.paymentStatus == 'unpaid') {
          return 'Payment pending. Please complete payment to proceed.';
        }
        return 'Application submitted and pending review.';
    }
  }

  bool get _hasDownloadButton {
    return _status == ApplicationStatus.approved ||
        _status == ApplicationStatus.digitized;
  }

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
            blurRadius: 8,
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
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIN: ${application.nin}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              if (application.paymentStatus == 'paid')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Paid',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              if (application.paymentStatus == 'paid') const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _status.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_status.icon, size: 14, color: _status.color),
                    const SizedBox(width: 4),
                    Text(
                      _status.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _status.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _location,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormatter.formatDisplayDate(application.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
          if (_hasDownloadButton) ...[
            const SizedBox(height: 12),
            CustomButton(
              text: 'Download',
              iconData: Icons.download,
              iconPosition: IconPosition.left,
              onPressed: () {},
              variant: ButtonVariant.primary,
              fontSize: 14,
            ),
          ],
        ],
      ),
    );
  }
}
