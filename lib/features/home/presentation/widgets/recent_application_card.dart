import 'package:flutter/material.dart';

import '../../../../core/enums/application_status.dart';
import '../../../../src/constants/app_colors.dart';

class RecentApplicationCard extends StatelessWidget {
  final String name;
  final String location;
  final String date;
  final String status;

  const RecentApplicationCard({
    super.key,
    required this.name,
    required this.location,
    required this.date,
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
            blurRadius: 8,
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
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getApplicationStatusColor(
                      ApplicationStatus.fromString(status))
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getApplicationStatusBadge(
                    ApplicationStatus.fromString(status)),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getApplicationStatusColor(
                        ApplicationStatus.fromString(status)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getApplicationStatusBadge(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return const Icon(Icons.watch_later_outlined, size: 16, color: AppColors.orange);
      case ApplicationStatus.approved:
        return const Icon(Icons.check, size: 16, color: AppColors.green);
      case ApplicationStatus.rejected:
        return const Icon(Icons.close, size: 16, color: AppColors.errorColor);
      case ApplicationStatus.digitized:
        return const Icon(Icons.verified,
            size: 16, color: AppColors.gradientEnd);
      default:
        return const Icon(Icons.info, size: 16, color: AppColors.greyDark);
    }
  }

  Color _getApplicationStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return AppColors.orange;
      case ApplicationStatus.approved:
        return AppColors.green;
      case ApplicationStatus.rejected:
        return AppColors.errorColor;
      case ApplicationStatus.digitized:
        return AppColors.gradientEnd;
      default:
        return AppColors.greyDark;
    }
  }
}
