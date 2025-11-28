import 'package:flutter_test/flutter_test.dart';
import 'package:expense_app/features/currency/data/models/currency_rate_model.dart';

void main() {
  group('Currency Calculation Tests', () {
    late CurrencyRateModel rates;

    setUp(() {
      rates = CurrencyRateModel(
        baseCurrency: 'USD',
        rates: {
          'USD': 1.0,
          'EUR': 0.85,
          'GBP': 0.73,
          'JPY': 110.0,
          'INR': 74.5,
        },
        timestamp: DateTime.now(),
      );
    });

    test('Should get correct exchange rate for currency', () {
      expect(rates.getRate('USD'), 1.0);
      expect(rates.getRate('EUR'), 0.85);
      expect(rates.getRate('GBP'), 0.73);
      expect(rates.getRate('JPY'), 110.0);
    });

    test('Should return 1.0 for unknown currency', () {
      expect(rates.getRate('XYZ'), 1.0);
    });

    test('Should convert USD to EUR correctly', () {
      final result = rates.convert(amount: 100.0, from: 'USD', to: 'EUR');

      expect(result, closeTo(85.0, 0.01));
    });

    test('Should convert EUR to USD correctly', () {
      final result = rates.convert(amount: 85.0, from: 'EUR', to: 'USD');

      expect(result, closeTo(100.0, 0.01));
    });

    test('Should convert GBP to JPY correctly', () {
      final result = rates.convert(amount: 100.0, from: 'GBP', to: 'JPY');

      // 100 GBP = 100/0.73 USD = 136.99 USD
      // 136.99 USD = 136.99 * 110 JPY = 15068.49 JPY
      expect(result, closeTo(15068.49, 1.0));
    });

    test('Should return same amount when converting to same currency', () {
      final result = rates.convert(amount: 100.0, from: 'USD', to: 'USD');

      expect(result, 100.0);
    });

    test('Should handle decimal amounts correctly', () {
      final result = rates.convert(amount: 123.45, from: 'USD', to: 'EUR');

      expect(result, closeTo(104.93, 0.01));
    });

    test('Should convert to JSON correctly', () {
      final json = rates.toJson();

      expect(json['base_code'], 'USD');
      expect(json['rates'], isA<Map<String, double>>());
      expect(json['rates']['EUR'], 0.85);
    });

    test('Should create from JSON correctly', () {
      final json = {
        'base_code': 'USD',
        'rates': {'USD': 1.0, 'EUR': 0.85},
        'time_last_update_unix': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      };

      final model = CurrencyRateModel.fromJson(json);

      expect(model.baseCurrency, 'USD');
      expect(model.getRate('EUR'), 0.85);
    });
  });
}
