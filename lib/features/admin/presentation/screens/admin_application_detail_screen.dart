import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/core/enums/payment_status.dart';
import 'package:algon_mobile/features/application/data/models/application_list_models.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/admin/data/repository/admin_repository.dart';
import 'package:algon_mobile/core/service_exceptions/api_exceptions.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class AdminApplicationDetailScreen extends ConsumerStatefulWidget {
  const AdminApplicationDetailScreen({
    super.key,
    @PathParam('id') required this.id,
  });

  final String id;

  @override
  ConsumerState<AdminApplicationDetailScreen> createState() =>
      _AdminApplicationDetailScreenState();
}

class _AdminApplicationDetailScreenState
    extends ConsumerState<AdminApplicationDetailScreen> {
  ApplicationItem? _application;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchApplicationDetails();
  }

  Future<void> _fetchApplicationDetails() async {
    setState(() => _isLoading = true);

    print('🔍 Starting to fetch application details...');
    print('   Screen ID: ${widget.id}');

    try {
      final adminRepo = ref.read(adminRepositoryProvider);

      // Try both application types
      final applicationTypes = ['certificate', 'digitization'];

      for (final appType in applicationTypes) {
        print('   Trying application type: $appType');

        final result = await adminRepo.getApplicationDetails(
          applicationId: widget.id,
          applicationType: appType,
        );

        result.when(
          success: (application) {
            setState(() {
              _application = application;
              _isLoading = false;
            });
          },
          apiFailure: (error, statusCode) {
            if (appType == applicationTypes.last && _isLoading) {
              // Last type failed, show error
              setState(() => _isLoading = false);
              if (statusCode == 404) {
                Toast.error('Application not found', context);
              } else {
                Toast.error('Failed to load: $error', context);
              }
            }
          },
        );

        // If we successfully got the application, break the loop
        if (!_isLoading) break;
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Toast.error('An unexpected error occurred: $e', context);
    }
  }

  Future<void> _updateApplicationStatus({required String action}) async {
    setState(() => _isUpdating = true);

    try {
      final adminRepo = ref.read(adminRepositoryProvider);
      final result = await adminRepo.updateApplicationStatus(
        applicationId: widget.id,
        applicationType: 'certificate',
        action: action,
      );

      result.when(
        success: (response) {
          Toast.success(response.message, context);
          _fetchApplicationDetails(); // Refresh details
          setState(() => _isUpdating = false);
        },
        apiFailure: (error, statusCode) {
          setState(() => _isUpdating = false);
          if (error is ApiExceptions) {
            Toast.apiError(error, context);
          } else {
            Toast.error(error.toString(), context);
          }
        },
      );
    } catch (e) {
      setState(() => _isUpdating = false);
      Toast.error('Failed to update application: ${e.toString()}', context);
    }
  }

  void _showApproveRejectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Application Action'),
          content:
              const Text('What would you like to do with this application?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateApplicationStatus(action: 'rejected');
              },
              child: const Text('Reject', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateApplicationStatus(action: 'approved');
              },
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageContainer({
    required String? imageUrl,
    required String label,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: imageUrl != null && imageUrl.isNotEmpty
          ? () => _showFullScreenImage(context, imageUrl, label)
          : null,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF9FAFB),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.grey[400],
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Failed to load',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      color: const Color(0xFFF9FAFB),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: 32,
                              color: const Color(0xFF9CA3AF),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No $label',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            // Label
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    const SizedBox(width: 4),
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    const Icon(
                      Icons.zoom_in,
                      size: 12,
                      color: Color(0xFF6B7280),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, String imageUrl, String label) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              // Full-screen background with slight blur
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                ),
              ),

              // Image content
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 5,
                    child: Center(
                      child: Hero(
                        tag: imageUrl,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.black,
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Failed to load image',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),

              // Label at bottom
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Zoom instructions
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 80,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(
                    'Pinch to zoom • Double tap to reset',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Application Details'),
            backgroundColor: AppColors.gradientStart,
            foregroundColor: Colors.white,
          ),
          body: const ShimmerApplicationDetailScreen(),
        ),
      );
    }

    if (_application == null) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Application Details'),
            backgroundColor: AppColors.gradientStart,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Application not found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchApplicationDetails,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final app = _application!;
    final status = ApplicationStatus.fromString(app.applicationStatus);
    final paymentStatus = PaymentStatus.fromString(app.paymentStatus);

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
                      'Application Details',
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
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Applicant info card
                    _InfoCard(
                      title: app.fullName,
                      subtitle: 'NIN: ${app.nin}',
                      status: status,
                    ),
                    const SizedBox(height: 16),

                    // Images Section
                    Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Uploaded Documents',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Profile Photo
                              _buildImageContainer(
                                imageUrl: app.profilePhoto,
                                label: 'Profile Photo',
                                icon: Icons.person_outline,
                              ),
                              // NIN Slip
                              _buildImageContainer(
                                imageUrl: app.ninSlip,
                                label: 'NIN Slip',
                                icon: Icons.credit_card_outlined,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Letter from Traditional Ruler (if exists)
                          if (app.letterFromTraditionalRuler != null &&
                              app.letterFromTraditionalRuler!.isNotEmpty)
                            Column(
                              children: [
                                const Divider(),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildImageContainer(
                                      imageUrl: app.letterFromTraditionalRuler,
                                      label: 'Traditional Ruler Letter',
                                      icon: Icons.description_outlined,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Additional Info Card
                    _AdditionalInfoCard(application: app),
                    const SizedBox(height: 16),

                    // Payment Status
                    _PaymentInfoCard(
                      paymentStatus: paymentStatus,
                      reference: app.id,
                      date: DateFormatter.formatDisplayDate(app.createdAt),
                    ),
                    const SizedBox(height: 16),

                    // Actions (only for pending applications)
                    if (status == ApplicationStatus.pending) ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Download",
                              iconData: Icons.download,
                              onPressed: () {
                                // TODO: Implement download functionality
                                Toast.success(
                                    'Download will be implemented', context);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              text: 'Review',
                              iconData: Icons.visibility,
                              onPressed: _showApproveRejectDialog,
                              isLoading: _isUpdating,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ApplicationStatus status;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.status,
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status.icon,
                  size: 14,
                  color: status.color,
                ),
                const SizedBox(width: 4),
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
    );
  }
}

class _AdditionalInfoCard extends StatelessWidget {
  final ApplicationItem application;

  const _AdditionalInfoCard({required this.application});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Email', value: application.email),
          const SizedBox(height: 8),
          _InfoRow(label: 'Phone', value: application.phoneNumber),
          const SizedBox(height: 8),
          _InfoRow(
              label: 'Date of Birth', value: application.dateOfBirth ?? 'N/A'),
          const SizedBox(height: 8),
          _InfoRow(label: 'State', value: application.state.name),
          const SizedBox(height: 8),
          _InfoRow(label: 'LGA', value: application.localGovernment.name),
          const SizedBox(height: 8),
          _InfoRow(label: 'Village', value: application.village ?? 'N/A'),
          const SizedBox(height: 8),
          _InfoRow(
              label: 'Address', value: application.residentialAddress ?? 'N/A'),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Submitted',
            value: DateFormatter.formatDisplayDate(application.createdAt),
          ),
          if (application.updatedAt != application.createdAt)
            Column(
              children: [
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'Last Updated',
                  value: DateFormatter.formatDisplayDate(application.updatedAt),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PaymentInfoCard extends StatelessWidget {
  final PaymentStatus paymentStatus;
  final String reference;
  final String date;

  const _PaymentInfoCard({
    required this.paymentStatus,
    required this.reference,
    required this.date,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: paymentStatus.backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  paymentStatus.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: paymentStatus.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // _InfoRow(label: 'Reference', value: reference),
          const SizedBox(height: 8),
          _InfoRow(label: 'Date', value: date),
          if (paymentStatus == PaymentStatus.successful)
            const Column(
              children: [
                SizedBox(height: 8),
                _InfoRow(
                    label: 'Paid Amount',
                    value: '₦5,000'), // TODO: Get actual amount from API
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
