import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/core/enums/payment_status.dart';
import 'package:algon_mobile/features/application/data/models/application_list_models.dart';
import 'package:algon_mobile/shared/widgets/toast.dart';
import 'package:algon_mobile/features/application/data/repository/application_repository.dart';
import 'package:algon_mobile/core/utils/date_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:algon_mobile/shared/widgets/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class ApplicationDetailScreen extends ConsumerStatefulWidget {
  const ApplicationDetailScreen({
    super.key,
    @PathParam('id') required this.id,
  });

  final String id;

  @override
  ConsumerState<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState
    extends ConsumerState<ApplicationDetailScreen> {
  ApplicationItem? _application;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApplicationDetails();
  }

  Future<void> _fetchApplicationDetails() async {
    setState(() => _isLoading = true);

    try {
      final applicationRepo = ref.read(applicationRepositoryProvider);

      // Try both application types
      final applicationTypes = ['certificate', 'digitization'];

      for (final appType in applicationTypes) {
        print('🔍 Fetching application details for type: $appType');

        final result = await applicationRepo.getMyApplicationDetails(
          applicationId: widget.id,
          applicationType: appType,
        );

        result.when(
          success: (application) {
            print('✅ Successfully fetched application details');
            setState(() {
              _application = application;
              _isLoading = false;
            });
          },
          apiFailure: (error, statusCode) {
            print(
                '❌ Failed to fetch application details: $error (Status: $statusCode)');
            if (appType == applicationTypes.last && _isLoading) {
              setState(() => _isLoading = false);
              if (mounted) {
                if (statusCode == 404) {
                  Toast.error('Application not found', context);
                } else {
                  Toast.error('Failed to load application', context);
                }
              }
            }
          },
        );

        if (!_isLoading) break;
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        Toast.error('An unexpected error occurred', context);
      }
    }
  }

  Widget _buildImageContainer({
    String? imageUrl,
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: imageUrl != null && imageUrl.isNotEmpty
                ? () => _showFullScreenImage(context, imageUrl, label)
                : null,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
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
                                const Text(
                                  'Failed to load',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.all(Radius.circular(12)),
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
    );
  }

  void _showFullScreenImage(
      BuildContext context, String? imageUrl, String label) {
    if (imageUrl == null || imageUrl.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
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
                              _buildImageContainer(
                                imageUrl: app.profilePhoto,
                                label: 'Profile Photo',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(width: 12),
                              _buildImageContainer(
                                imageUrl: app.ninSlip,
                                label: 'NIN Slip',
                                icon: Icons.credit_card_outlined,
                              ),
                            ],
                          ),
                          if (app.letterFromTraditionalRuler != null &&
                              app.letterFromTraditionalRuler!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            _buildImageContainer(
                              imageUrl: app.letterFromTraditionalRuler!,
                              label: 'Traditional Ruler Letter',
                              icon: Icons.description_outlined,
                            ),
                          ],
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
            'Application Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
              label: 'Date of Birth', value: application.dateOfBirth ?? 'N/A'),
          const Divider(),
          _InfoRow(label: 'Phone Number', value: application.phoneNumber),
          const Divider(),
          _InfoRow(label: 'Email', value: application.email),
          const Divider(),
          _InfoRow(label: 'Village', value: application.village ?? 'N/A'),
          if (application.residentialAddress != null &&
              application.residentialAddress!.isNotEmpty) ...[
            const Divider(),
            _InfoRow(
                label: 'Residential Address',
                value: application.residentialAddress!),
          ],
          if (application.landmark != null &&
              application.landmark!.isNotEmpty) ...[
            const Divider(),
            _InfoRow(label: 'Landmark', value: application.landmark!),
          ],
          const Divider(),
          _InfoRow(label: 'State', value: application.state.name),
          const Divider(),
          _InfoRow(
              label: 'Local Government',
              value: application.localGovernment.name),
          const Divider(),
          _InfoRow(
              label: 'Date Submitted',
              value: DateFormatter.formatDisplayDate(application.createdAt)),
          if (application.approvedAt != null &&
              application.approvedAt!.isNotEmpty) ...[
            const Divider(),
            _InfoRow(
                label: 'Date Approved',
                value: DateFormatter.formatDisplayDate(
                    application.approvedAt ?? '')),
          ],
          if (application.remarks != null &&
              application.remarks!.isNotEmpty) ...[
            const Divider(),
            _InfoRow(label: 'Remarks', value: application.remarks!),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
            ),
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
          const Text(
            'Payment Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: paymentStatus.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      paymentStatus.icon,
                      size: 14,
                      color: paymentStatus.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      paymentStatus.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: paymentStatus.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Reference ID', value: reference),
          const Divider(),
          _InfoRow(label: 'Application Date', value: date),
        ],
      ),
    );
  }
}
