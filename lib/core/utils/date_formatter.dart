class DateFormatter {
  /// Convert date from MM/DD/YYYY to YYYY-MM-DD format for API
  static String toApiFormat(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final month = parts[0].padLeft(2, '0');
        final day = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
      return dateString; // Return as-is if format is unexpected
    } catch (e) {
      return dateString; // Return as-is on error
    }
  }

  /// Convert DateTime to YYYY-MM-DD format
  static String fromDateTime(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Format ISO 8601 date string to readable format
  static String formatDisplayDate(String isoDateString) {
    try {
      final date = DateTime.parse(isoDateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
        }
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks week${weeks == 1 ? '' : 's'} ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return isoDateString; // Return as-is on error
    }
  }
}
