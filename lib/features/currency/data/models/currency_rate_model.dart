import 'package:equatable/equatable.dart';

/// Currency rate model for API response
class CurrencyRateModel extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime timestamp;

  const CurrencyRateModel({
    required this.baseCurrency,
    required this.rates,
    required this.timestamp,
  });

  /// Create from JSON (Open Exchange Rates API format)
  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRateModel(
      baseCurrency: json['base_code'] as String? ?? 'USD',
      rates: Map<String, double>.from(
        (json['rates'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['time_last_update_unix'] as int? ?? 0) * 1000,
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCurrency,
      'rates': rates,
      'time_last_update_unix': timestamp.millisecondsSinceEpoch ~/ 1000,
    };
  }

  /// Get exchange rate for a specific currency
  double getRate(String currency) {
    return rates[currency.toUpperCase()] ?? 1.0;
  }

  /// Convert amount from one currency to another
  double convert({
    required double amount,
    required String from,
    required String to,
  }) {
    if (from.toUpperCase() == to.toUpperCase()) {
      return amount;
    }

    final fromRate = getRate(from);
    final toRate = getRate(to);

    // Convert to base currency first, then to target currency
    final amountInBase = amount / fromRate;
    return amountInBase * toRate;
  }

  @override
  List<Object?> get props => [baseCurrency, rates, timestamp];
}
