import 'package:injectable/injectable.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

/// Implementation of ExpenseRepository (data layer)
@LazySingleton(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<void> addExpense(Expense expense) async {
    final model = ExpenseModel(
      id: expense.id,
      category: expense.category,
      amount: expense.amount,
      currency: expense.currency,
      amountInUSD: expense.amountInUSD,
      date: expense.date,
      receiptPath: expense.receiptPath,
      createdAt: expense.createdAt,
    );
    await localDataSource.addExpense(model);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final model = ExpenseModel(
      id: expense.id,
      category: expense.category,
      amount: expense.amount,
      currency: expense.currency,
      amountInUSD: expense.amountInUSD,
      date: expense.date,
      receiptPath: expense.receiptPath,
      createdAt: expense.createdAt,
    );
    await localDataSource.updateExpense(model);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
  }

  @override
  Expense? getExpenseById(String id) {
    final model = localDataSource.getExpense(id);
    return model != null ? _modelToEntity(model) : null;
  }

  @override
  List<Expense> getAllExpenses() {
    return localDataSource.getAllExpenses().map(_modelToEntity).toList();
  }

  @override
  List<Expense> getExpensesByDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    return localDataSource
        .getExpensesByDateRange(start: start, end: end)
        .map(_modelToEntity)
        .toList();
  }

  @override
  List<Expense> getExpensesByCategory(String category) {
    return localDataSource
        .getExpensesByCategory(category)
        .map(_modelToEntity)
        .toList();
  }

  @override
  List<Expense> getPaginatedExpenses({
    required int page,
    required int pageSize,
    List<Expense>? sourceExpenses,
  }) {
    final expenses = sourceExpenses ?? getAllExpenses();
    final startIndex = page * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= expenses.length) {
      return [];
    }

    return expenses.sublist(
      startIndex,
      endIndex > expenses.length ? expenses.length : endIndex,
    );
  }

  @override
  double getTotalExpensesInUSD({List<Expense>? expenses}) {
    final expenseList = expenses ?? getAllExpenses();
    return expenseList.fold(0.0, (sum, expense) => sum + expense.amountInUSD);
  }

  @override
  List<Expense> getCurrentMonthExpenses() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return getExpensesByDateRange(start: startOfMonth, end: endOfMonth);
  }

  @override
  List<Expense> getLastNDaysExpenses(int days) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    return getExpensesByDateRange(start: startDate, end: now);
  }

  @override
  Future<void> clearAllExpenses() async {
    await localDataSource.clearAllExpenses();
  }

  Expense _modelToEntity(ExpenseModel model) {
    return Expense(
      id: model.id,
      category: model.category,
      amount: model.amount,
      currency: model.currency,
      amountInUSD: model.amountInUSD,
      date: model.date,
      receiptPath: model.receiptPath,
      createdAt: model.createdAt,
    );
  }
}
