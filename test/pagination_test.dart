import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_app/features/expense/domain/repositories/expense_repository.dart';
import 'package:expense_app/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:expense_app/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_app/features/expense/domain/entities/expense.dart';

class MockExpenseLocalDataSource extends Mock
    implements ExpenseLocalDataSource {}

void main() {
  group('Pagination Logic Tests', () {
    late ExpenseRepository repository;
    late MockExpenseLocalDataSource mockLocalDataSource;
    late List<Expense> testExpenses;

    setUp(() {
      mockLocalDataSource = MockExpenseLocalDataSource();
      repository = ExpenseRepositoryImpl(mockLocalDataSource);

      // Create 25 test expenses
      testExpenses = List.generate(25, (index) {
        return Expense(
          id: 'expense_$index',
          category: 'Test Category',
          amount: 100.0 + index,
          currency: 'USD',
          amountInUSD: 100.0 + index,
          date: DateTime.now().subtract(Duration(days: index)),
          createdAt: DateTime.now(),
        );
      });
    });

    test('Should return first page with correct page size', () {
      final page0 = repository.getPaginatedExpenses(
        page: 0,
        pageSize: 10,
        sourceExpenses: testExpenses,
      );

      expect(page0.length, 10);
      expect(page0.first.id, 'expense_0');
      expect(page0.last.id, 'expense_9');
    });

    test('Should return second page with correct items', () {
      final page1 = repository.getPaginatedExpenses(
        page: 1,
        pageSize: 10,
        sourceExpenses: testExpenses,
      );

      expect(page1.length, 10);
      expect(page1.first.id, 'expense_10');
      expect(page1.last.id, 'expense_19');
    });

    test('Should return partial page when items are less than page size', () {
      final page2 = repository.getPaginatedExpenses(
        page: 2,
        pageSize: 10,
        sourceExpenses: testExpenses,
      );

      expect(page2.length, 5);
      expect(page2.first.id, 'expense_20');
      expect(page2.last.id, 'expense_24');
    });

    test('Should return empty list when page is out of range', () {
      final page3 = repository.getPaginatedExpenses(
        page: 3,
        pageSize: 10,
        sourceExpenses: testExpenses,
      );

      expect(page3.length, 0);
      expect(page3, isEmpty);
    });

    test('Should handle different page sizes correctly', () {
      final page0Size5 = repository.getPaginatedExpenses(
        page: 0,
        pageSize: 5,
        sourceExpenses: testExpenses,
      );

      expect(page0Size5.length, 5);
      expect(page0Size5.first.id, 'expense_0');
      expect(page0Size5.last.id, 'expense_4');
    });

    test('Should handle page size larger than total items', () {
      final page0 = repository.getPaginatedExpenses(
        page: 0,
        pageSize: 50,
        sourceExpenses: testExpenses,
      );

      expect(page0.length, 25);
      expect(page0.first.id, 'expense_0');
      expect(page0.last.id, 'expense_24');
    });

    test('Should work with empty expense list', () {
      final page0 = repository.getPaginatedExpenses(
        page: 0,
        pageSize: 10,
        sourceExpenses: [],
      );

      expect(page0.length, 0);
      expect(page0, isEmpty);
    });
  });
}
