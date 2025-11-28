import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../models/expense_model.dart';

/// Local data source for expenses using Hive
@lazySingleton
class ExpenseLocalDataSource {
  static const String _boxName = 'expenses';

  Box<ExpenseModel> get _box => Hive.box<ExpenseModel>(_boxName);

  Future<void> addExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  ExpenseModel? getExpense(String id) {
    return _box.get(id);
  }

  List<ExpenseModel> getAllExpenses() {
    final expenses = _box.values.toList();
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  List<ExpenseModel> getExpensesByDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    return getAllExpenses()
        .where(
          (expense) =>
              expense.date.isAfter(
                start.subtract(const Duration(seconds: 1)),
              ) &&
              expense.date.isBefore(end.add(const Duration(seconds: 1))),
        )
        .toList();
  }

  List<ExpenseModel> getExpensesByCategory(String category) {
    return getAllExpenses()
        .where(
          (expense) => expense.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  Future<void> clearAllExpenses() async {
    await _box.clear();
  }
}
