import 'package:equatable/equatable.dart';

/// Currency Rate entity (domain layer)
class CurrencyRate extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime timestamp;

  const CurrencyRate({
    required this.baseCurrency,
    required this.rates,
    required this.timestamp,
  });

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
