import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:algon_mobile/core/enums/application_status.dart';
import 'package:algon_mobile/shared/widgets/bottom_nav_bar.dart';
import 'package:algon_mobile/shared/widgets/custom_button.dart';

@RoutePage(name: 'Tracking')
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

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
                    'LGCIVS',
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
                padding: const EdgeInsets.all(24),
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
                      child: ListView(
                        children: const [
                          _TrackingCard(
                            id: 'CERT-2025-001',
                            location: 'Ikeja LGA, Lagos',
                            status: ApplicationStatus.approved,
                            description:
                                'Application approved. Certificate ready for download.',
                            date: '2025-10-15',
                            hasDownloadButton: true,
                          ),
                          SizedBox(height: 16),
                          _TrackingCard(
                            id: 'DIGI-2025-012',
                            location: 'Ikeja LGA, Lagos',
                            status: ApplicationStatus.approved,
                            description:
                                'Digitization complete. Digital certificate issued.',
                            date: '2025-10-23',
                            additionalStatus: ApplicationStatus.digitized,
                            hasDownloadButton: true,
                          ),
                          SizedBox(height: 16),
                          _TrackingCard(
                            id: 'CERT-2025-002',
                            location: 'Owerri Municipal, Imo',
                            status: ApplicationStatus.pending,
                            description:
                                'Under review by local government admin.',
                            date: '2025-10-20',
                            hasDownloadButton: false,
                          ),
                        ],
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
  final String id;
  final String location;
  final ApplicationStatus status;
  final String description;
  final String date;
  final bool hasDownloadButton;
  final ApplicationStatus? additionalStatus;

  const _TrackingCard({
    required this.id,
    required this.location,
    required this.status,
    required this.description,
    required this.date,
    this.hasDownloadButton = false,
    this.additionalStatus,
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
                child: Text(
                  id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (additionalStatus != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: additionalStatus!.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    additionalStatus!.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: additionalStatus!.color,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
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
                    Icon(status.icon, size: 14, color: status.color),
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
          const SizedBox(height: 8),
          Text(
            location,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
          if (hasDownloadButton) ...[
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
