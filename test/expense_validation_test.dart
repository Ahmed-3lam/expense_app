import 'package:flutter_test/flutter_test.dart';
import 'package:expense_app/features/expense/data/models/expense_model.dart';

void main() {
  group('Expense Validation Tests', () {
    test('Expense should be created with valid data', () {
      final expense = ExpenseModel(
        id: '1',
        category: 'Groceries',
        amount: 100.0,
        currency: 'USD',
        amountInUSD: 100.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      expect(expense.id, '1');
      expect(expense.category, 'Groceries');
      expect(expense.amount, 100.0);
      expect(expense.currency, 'USD');
      expect(expense.amountInUSD, 100.0);
    });

    test('Expense amount should be greater than 0', () {
      final expense = ExpenseModel(
        id: '1',
        category: 'Groceries',
        amount: 100.0,
        currency: 'USD',
        amountInUSD: 100.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      expect(expense.amount, greaterThan(0));
    });

    test('Expense should have required fields', () {
      final expense = ExpenseModel(
        id: '1',
        category: 'Groceries',
        amount: 100.0,
        currency: 'USD',
        amountInUSD: 100.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      expect(expense.id, isNotEmpty);
      expect(expense.category, isNotEmpty);
      expect(expense.currency, isNotEmpty);
    });

    test('Expense should support copyWith', () {
      final expense = ExpenseModel(
        id: '1',
        category: 'Groceries',
        amount: 100.0,
        currency: 'USD',
        amountInUSD: 100.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final updatedExpense = expense.copyWith(
        amount: 150.0,
        amountInUSD: 150.0,
      );

      expect(updatedExpense.amount, 150.0);
      expect(updatedExpense.amountInUSD, 150.0);
      expect(updatedExpense.id, expense.id);
      expect(updatedExpense.category, expense.category);
    });

    test('Expense should convert to JSON', () {
      final now = DateTime.now();
      final expense = ExpenseModel(
        id: '1',
        category: 'Groceries',
        amount: 100.0,
        currency: 'USD',
        amountInUSD: 100.0,
        date: now,
        createdAt: now,
      );

      final json = expense.toJson();

      expect(json['id'], '1');
      expect(json['category'], 'Groceries');
      expect(json['amount'], 100.0);
      expect(json['currency'], 'USD');
      expect(json['amountInUSD'], 100.0);
    });

    test('Expense should be created from JSON', () {
      final now = DateTime.now();
      final json = {
        'id': '1',
        'category': 'Groceries',
        'amount': 100.0,
        'currency': 'USD',
        'amountInUSD': 100.0,
        'date': now.toIso8601String(),
        'receiptPath': null,
        'createdAt': now.toIso8601String(),
      };

      final expense = ExpenseModel.fromJson(json);

      expect(expense.id, '1');
      expect(expense.category, 'Groceries');
      expect(expense.amount, 100.0);
      expect(expense.currency, 'USD');
      expect(expense.amountInUSD, 100.0);
    });
  });
}
