import '../entities/expense.dart';

/// Repository interface for expense operations (domain layer)
abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Expense? getExpenseById(String id);
  List<Expense> getAllExpenses();
  List<Expense> getExpensesByDateRange({
    required DateTime start,
    required DateTime end,
  });
  List<Expense> getExpensesByCategory(String category);
  List<Expense> getPaginatedExpenses({
    required int page,
    required int pageSize,
    List<Expense>? sourceExpenses,
  });
  double getTotalExpensesInUSD({List<Expense>? expenses});
  List<Expense> getCurrentMonthExpenses();
  List<Expense> getLastNDaysExpenses(int days);
  Future<void> clearAllExpenses();
}
