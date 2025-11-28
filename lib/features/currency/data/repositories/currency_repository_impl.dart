import 'package:injectable/injectable.dart';
import '../../domain/entities/currency_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_local_datasource.dart';
import '../datasources/currency_remote_datasource.dart';
import '../models/currency_rate_model.dart';

/// Implementation of CurrencyRepository (data layer)
@LazySingleton(as: CurrencyRepository)
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyLocalDataSource localDataSource;
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<CurrencyRate> getExchangeRates({
    String baseCurrency = 'USD',
    bool forceRefresh = false,
  }) async {
    // Try to get cached rates first
    if (!forceRefresh) {
      final cachedRates = localDataSource.getCachedCurrencyRates();
      if (cachedRates != null) {
        return _modelToEntity(CurrencyRateModel.fromJson(cachedRates));
      }
    }

    // Fetch fresh rates from API
    try {
      // Note: The remote data source (CurrencyApiService) returns CurrencyRateModel
      // We need to update the import in that file or cast it here.
      // Assuming CurrencyApiService returns CurrencyRateModel which is compatible.
      final ratesModel = await remoteDataSource.fetchRates(
        baseCurrency: baseCurrency,
      );

      // Cache the rates
      await localDataSource.saveCurrencyRates(ratesModel.toJson());

      return _modelToEntity(ratesModel);
    } catch (e) {
      // If API fails and we have cached data (even if expired/requested refresh), use it as fallback
      final cachedRates = localDataSource.getCachedCurrencyRates();
      if (cachedRates != null) {
        return _modelToEntity(CurrencyRateModel.fromJson(cachedRates));
      }

      rethrow;
    }
  }

  @override
  Future<double> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    if (from.toUpperCase() == to.toUpperCase()) {
      return amount;
    }

    try {
      final rates = await getExchangeRates();
      return rates.convert(amount: amount, from: from, to: to);
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }

  CurrencyRate _modelToEntity(CurrencyRateModel model) {
    return CurrencyRate(
      baseCurrency: model.baseCurrency,
      rates: model.rates,
      timestamp: model.timestamp,
    );
  }
}
