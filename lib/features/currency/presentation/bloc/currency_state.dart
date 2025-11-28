import 'package:equatable/equatable.dart';
import '../../domain/entities/currency_rate.dart';

/// Base class for all currency states
abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CurrencyInitial extends CurrencyState {
  const CurrencyInitial();
}

/// Loading state
class CurrencyLoading extends CurrencyState {
  const CurrencyLoading();
}

/// Loaded state with exchange rates
class CurrencyLoaded extends CurrencyState {
  final CurrencyRate rates;

  const CurrencyLoaded(this.rates);

  @override
  List<Object?> get props => [rates];
}

/// Conversion result state
class CurrencyConverted extends CurrencyState {
  final double convertedAmount;
  final String fromCurrency;
  final String toCurrency;

  const CurrencyConverted({
    required this.convertedAmount,
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  List<Object?> get props => [convertedAmount, fromCurrency, toCurrency];
}

/// Error state
class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError(this.message);

  @override
  List<Object?> get props => [message];
}
