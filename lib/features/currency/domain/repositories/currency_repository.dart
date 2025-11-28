import '../entities/currency_rate.dart';

/// Repository interface for currency operations (domain layer)
abstract class CurrencyRepository {
  Future<CurrencyRate> getExchangeRates({
    String baseCurrency = 'USD',
    bool forceRefresh = false,
  });

  Future<double> convertCurrency({
    required double amount,
    required String from,
    required String to,
  });
}
