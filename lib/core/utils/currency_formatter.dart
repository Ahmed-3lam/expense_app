import 'package:intl/intl.dart';

/// Currency formatting utilities
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format amount with currency symbol
  static String format(double amount, {String currency = 'USD'}) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currency),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format amount without currency symbol
  static String formatWithoutSymbol(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }

  /// Get currency symbol
  static String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'INR':
        return '₹';
      case 'AUD':
        return 'A\$';
      case 'CAD':
        return 'C\$';
      case 'CHF':
        return 'Fr';
      case 'CNY':
        return '¥';
      default:
        return currency;
    }
  }

  /// Get list of supported currencies
  static List<String> getSupportedCurrencies() {
    return ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'AUD', 'CAD', 'CHF', 'CNY'];
  }

  /// Format amount with sign (+ or -)
  static String formatWithSign(double amount, {bool isIncome = false}) {
    final sign = isIncome ? '+' : '-';
    return '$sign${format(amount.abs())}';
  }
}
