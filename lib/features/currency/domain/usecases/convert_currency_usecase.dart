import 'package:injectable/injectable.dart';
import '../repositories/currency_repository.dart';

/// Use case for converting currency
@injectable
class ConvertCurrencyUseCase {
  final CurrencyRepository repository;

  ConvertCurrencyUseCase(this.repository);

  Future<double> call({
    required double amount,
    required String from,
    required String to,
  }) {
    return repository.convertCurrency(amount: amount, from: from, to: to);
  }
}
