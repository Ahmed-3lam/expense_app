import 'package:injectable/injectable.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Use case for adding an expense
@injectable
class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(Expense expense) async {
    // Business logic validation
    if (expense.amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }
    if (expense.category.isEmpty) {
      throw Exception('Category is required');
    }

    await repository.addExpense(expense);
  }
}
