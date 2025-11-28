import 'package:equatable/equatable.dart';

/// Base class for all currency events
abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load exchange rates
class LoadExchangeRates extends CurrencyEvent {
  final String baseCurrency;
  final bool forceRefresh;

  const LoadExchangeRates({
    this.baseCurrency = 'USD',
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [baseCurrency, forceRefresh];
}

/// Event to convert currency
class ConvertCurrency extends CurrencyEvent {
  final double amount;
  final String fromCurrency;
  final String toCurrency;

  const ConvertCurrency({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  List<Object?> get props => [amount, fromCurrency, toCurrency];
}

/// Event to convert to USD
class ConvertToUSD extends CurrencyEvent {
  final double amount;
  final String fromCurrency;

  const ConvertToUSD({required this.amount, required this.fromCurrency});

  @override
  List<Object?> get props => [amount, fromCurrency];
}
