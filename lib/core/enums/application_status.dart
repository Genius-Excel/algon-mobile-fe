import 'package:flutter/material.dart';

enum ApplicationStatus {
  pending('Pending', Color(0xFFFFA500)),
  approved('Approved', Color(0xFF10B981)),
  rejected('Rejected', Color(0xFFEF4444)),
  digitized('Digitized', Color(0xFF0891B2)),
  underReview('Under Review', Color(0xFFF59E0B));

  final String label;
  final Color color;

  const ApplicationStatus(this.label, this.color);

  Color get backgroundColor {
    switch (this) {
      case ApplicationStatus.pending:
        return const Color(0xFFFFF7ED);
      case ApplicationStatus.approved:
        return const Color(0xFFE8F5E3);
      case ApplicationStatus.rejected:
        return const Color(0xFFFEE2E2);
      case ApplicationStatus.digitized:
        return const Color(0xFFE6F2F5);
      case ApplicationStatus.underReview:
        return const Color(0xFFFEF3C7);
    }
  }

  IconData get icon {
    switch (this) {
      case ApplicationStatus.pending:
        return Icons.schedule;
      case ApplicationStatus.approved:
        return Icons.check_circle;
      case ApplicationStatus.rejected:
        return Icons.cancel;
      case ApplicationStatus.digitized:
        return Icons.verified;
      case ApplicationStatus.underReview:
        return Icons.search;
    }
  }

  static ApplicationStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'digitized':
      case 'digitization':
        return ApplicationStatus.digitized;
      case 'under_review':
      case 'under review':
        return ApplicationStatus.underReview;
      default:
        return ApplicationStatus.pending;
    }
  }
}
