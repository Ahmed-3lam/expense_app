import 'package:injectable/injectable.dart';
import '../entities/currency_rate.dart';
import '../repositories/currency_repository.dart';

/// Use case for getting exchange rates
@injectable
class GetExchangeRatesUseCase {
  final CurrencyRepository repository;

  GetExchangeRatesUseCase(this.repository);

  Future<CurrencyRate> call({
    String baseCurrency = 'USD',
    bool forceRefresh = false,
  }) {
    return repository.getExchangeRates(
      baseCurrency: baseCurrency,
      forceRefresh: forceRefresh,
    );
  }
}
