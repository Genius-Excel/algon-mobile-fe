import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/core/enums/payment_status.dart';
import 'package:algon_mobile/shared/widgets/bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
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
  bool _isLoadingMore = false;
  List<ApplicationItem> _applications = [];
  String? _nextUrl;
  int _totalCount = 0;
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        _nextUrl != null &&
        !_isLoadingMore) {
      _loadMoreApplications();
    }
  }

  Future<void> _fetchApplications({bool refresh = false}) async {
    if (refresh) {
      _nextUrl = null;
      _applications.clear();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final offset =
          refresh || _applications.isEmpty ? 0 : _applications.length;
      final result = await applicationRepo.getMyApplications(
        limit: _pageSize,
        offset: offset,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              final updatedList = refresh
                  ? List<ApplicationItem>.from(response.data.results)
                  : List<ApplicationItem>.from(_applications)
                ..addAll(response.data.results);
              updatedList.sort((a, b) {
                try {
                  final dateA = DateTime.parse(a.createdAt);
                  final dateB = DateTime.parse(b.createdAt);
                  return dateB
                      .compareTo(dateA); // Descending order (newest first)
                } catch (e) {
                  return 0;
                }
              });
              _applications = updatedList;
              _nextUrl = response.data.next;
              _totalCount = response.data.count;
              _isLoading = false;
            });
            print(
                '✅ Loaded ${_applications.length}/$_totalCount applications in tracking screen');
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

  Future<void> _loadMoreApplications() async {
    if (_nextUrl == null || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);
      final result = await applicationRepo.getMyApplications(
        limit: _pageSize,
        offset: _applications.length,
      );

      result.when(
        success: (response) {
          if (mounted) {
            setState(() {
              // Create new list with existing items and new items
              final updatedList = List<ApplicationItem>.from(_applications)
                ..addAll(response.data.results);
              // Sort by date (latest first)
              updatedList.sort((a, b) {
                try {
                  final dateA = DateTime.parse(a.createdAt);
                  final dateB = DateTime.parse(b.createdAt);
                  return dateB
                      .compareTo(dateA); // Descending order (newest first)
                } catch (e) {
                  // If parsing fails, maintain original order
                  return 0;
                }
              });
              // Assign new list instance to trigger rebuild
              _applications = updatedList;
              _nextUrl = response.data.next;
              _isLoadingMore = false;
            });
            print(
                '✅ Loaded more: ${_applications.length}/$_totalCount applications');
          }
        },
        apiFailure: (error, statusCode) {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
            // Don't show error toast for pagination failures
            print('❌ Failed to load more applications: $error');
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      print('❌ Error loading more applications: $e');
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
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
                          ? ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index < 4 ? 16 : 0,
                                  ),
                                  child: const ShimmerApplicationCard(),
                                );
                              },
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
                                  onRefresh: () =>
                                      _fetchApplications(refresh: true),
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: _applications.length +
                                        (_isLoadingMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index >= _applications.length) {
                                        // Loading more indicator
                                        return const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
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

  PaymentStatus get _paymentStatus {
    return PaymentStatus.fromString(application.paymentStatus);
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
        if (_paymentStatus == PaymentStatus.pending) {
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
              if (_paymentStatus == PaymentStatus.successful)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _paymentStatus.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_paymentStatus.icon,
                          size: 12, color: _paymentStatus.color),
                      const SizedBox(width: 4),
                      Text(
                        _paymentStatus.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _paymentStatus.color,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_paymentStatus == PaymentStatus.successful)
                const SizedBox(width: 8),
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
