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
}
