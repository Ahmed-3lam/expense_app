import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/currency_rate_model.dart';

/// Currency API service for fetching exchange rates
@lazySingleton
class CurrencyRemoteDataSource {
  static const String _baseUrl = 'https://open.er-api.com/v6/latest';

  final Dio dio;

  CurrencyRemoteDataSource(this.dio);

  /// Fetch exchange rates for a base currency
  Future<CurrencyRateModel> fetchRates({String baseCurrency = 'USD'}) async {
    try {
      final response = await dio.get('$_baseUrl/$baseCurrency');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return CurrencyRateModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to fetch currency rates: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch currency rates: $e');
    }
  }

  /// Convert amount from one currency to another
  Future<double> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    try {
      final rates = await fetchRates(baseCurrency: from);
      return rates.convert(amount: amount, from: from, to: to);
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }

  /// Dispose client
  void dispose() {
    dio.close();
  }
}
