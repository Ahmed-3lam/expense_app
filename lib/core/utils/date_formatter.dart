import 'package:intl/intl.dart';

/// Date formatting utilities
class DateFormatter {
  DateFormatter._();

  /// Format date as "Today HH:mm AM/PM"
  static String formatExpenseDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    final timeFormat = DateFormat('h:mm a');

    if (dateToCheck == today) {
      return 'Today ${timeFormat.format(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday ${timeFormat.format(date)}';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  /// Format date as "dd/MM/yy"
  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }

  /// Format date as "MMMM dd, yyyy"
  static String formatLongDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  /// Check if date is in current month
  static bool isInCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Check if date is in last 7 days
  static bool isInLast7Days(DateTime date) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return date.isAfter(sevenDaysAgo);
  }

  /// Check if date is in last 30 days
  static bool isInLast30Days(DateTime date) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    return date.isAfter(thirtyDaysAgo);
  }

  /// Get start of current month
  static DateTime getStartOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// Get end of current month
  static DateTime getEndOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }
}
