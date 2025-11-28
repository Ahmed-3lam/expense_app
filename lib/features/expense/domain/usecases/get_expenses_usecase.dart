import 'package:injectable/injectable.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Use case for getting expenses with pagination
@injectable
class GetExpensesUseCase {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  List<Expense> call({
    int page = 0,
    int pageSize = 10,
    List<Expense>? sourceExpenses,
  }) {
    return repository.getPaginatedExpenses(
      page: page,
      pageSize: pageSize,
      sourceExpenses: sourceExpenses,
    );
  }
}
