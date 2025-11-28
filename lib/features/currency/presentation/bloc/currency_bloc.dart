import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'currency_event.dart';
import 'currency_state.dart';
import '../../domain/usecases/get_exchange_rates_usecase.dart';
import '../../domain/usecases/convert_currency_usecase.dart';

/// BLoC for managing currency operations
@injectable
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetExchangeRatesUseCase getExchangeRatesUseCase;
  final ConvertCurrencyUseCase convertCurrencyUseCase;

  CurrencyBloc(this.getExchangeRatesUseCase, this.convertCurrencyUseCase)
    : super(const CurrencyInitial()) {
    on<LoadExchangeRates>(_onLoadExchangeRates);
    on<ConvertCurrency>(_onConvertCurrency);
    on<ConvertToUSD>(_onConvertToUSD);
  }

  /// Load exchange rates
  Future<void> _onLoadExchangeRates(
    LoadExchangeRates event,
    Emitter<CurrencyState> emit,
  ) async {
    try {
      emit(const CurrencyLoading());

      final rates = await getExchangeRatesUseCase(
        baseCurrency: event.baseCurrency,
        forceRefresh: event.forceRefresh,
      );

      emit(CurrencyLoaded(rates));
    } catch (e) {
      emit(CurrencyError('Failed to load exchange rates: $e'));
    }
  }

  /// Convert currency
  Future<void> _onConvertCurrency(
    ConvertCurrency event,
    Emitter<CurrencyState> emit,
  ) async {
    try {
      emit(const CurrencyLoading());

      final convertedAmount = await convertCurrencyUseCase(
        amount: event.amount,
        from: event.fromCurrency,
        to: event.toCurrency,
      );

      emit(
        CurrencyConverted(
          convertedAmount: convertedAmount,
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
        ),
      );
    } catch (e) {
      emit(CurrencyError('Failed to convert currency: $e'));
    }
  }

  /// Convert to USD
  Future<void> _onConvertToUSD(
    ConvertToUSD event,
    Emitter<CurrencyState> emit,
  ) async {
    try {
      emit(const CurrencyLoading());

      final convertedAmount = await convertCurrencyUseCase(
        amount: event.amount,
        from: event.fromCurrency,
        to: 'USD',
      );

      emit(
        CurrencyConverted(
          convertedAmount: convertedAmount,
          fromCurrency: event.fromCurrency,
          toCurrency: 'USD',
        ),
      );
    } catch (e) {
      emit(CurrencyError('Failed to convert to USD: $e'));
    }
  }
}
