import 'package:flutter/material.dart';

enum PaymentStatus {
  pending('pending', 'Pending'),
  successful('successful', 'Successful'),
  failed('failed', 'Failed'),
  refunded('refunded', 'Refunded');

  final String value;
  final String label;

  const PaymentStatus(this.value, this.label);

  static PaymentStatus fromString(String? status) {
    if (status == null) return PaymentStatus.pending;

    final normalizedStatus = status.toLowerCase();

    // Handle legacy/alternative status values
    if (normalizedStatus == 'paid') {
      return PaymentStatus.successful;
    }
    if (normalizedStatus == 'unpaid') {
      return PaymentStatus.pending;
    }

    return PaymentStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == normalizedStatus,
      orElse: () => PaymentStatus.pending,
    );
  }

  Color get color {
    switch (this) {
      case PaymentStatus.successful:
        return const Color(0xFF10B981); // Green
      case PaymentStatus.failed:
        return const Color(0xFFEF4444); // Red
      case PaymentStatus.refunded:
        return const Color(0xFFF59E0B); // Amber/Orange
      case PaymentStatus.pending:
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  Color get backgroundColor {
    switch (this) {
      case PaymentStatus.successful:
        return const Color(0xFFD1FAE5); // Light Green
      case PaymentStatus.failed:
        return const Color(0xFFFEE2E2); // Light Red
      case PaymentStatus.refunded:
        return const Color(0xFFFEF3C7); // Light Amber
      case PaymentStatus.pending:
      default:
        return const Color(0xFFF3F4F6); // Light Gray
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentStatus.successful:
        return Icons.check_circle;
      case PaymentStatus.failed:
        return Icons.cancel;
      case PaymentStatus.refunded:
        return Icons.refresh;
      case PaymentStatus.pending:
      default:
        return Icons.pending;
    }
  }
}
