import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/repositories/expense_repository.dart';

/// BLoC for managing expense operations (presentation layer)
@injectable
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;
  final AddExpenseUseCase addExpenseUseCase;
  final GetExpensesUseCase getExpensesUseCase;
  static const int _pageSize = 10;

  ExpenseBloc(this.repository, this.addExpenseUseCase, this.getExpensesUseCase)
    : super(const ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<LoadMoreExpenses>(_onLoadMoreExpenses);
    on<FilterExpensesByDateRange>(_onFilterExpensesByDateRange);
    on<FilterExpensesByCategory>(_onFilterExpensesByCategory);
    on<ResetFilters>(_onResetFilters);
  }

  /// Load all expenses
  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      emit(const ExpenseLoading());

      final allExpenses = repository.getAllExpenses();
      final displayedExpenses = getExpensesUseCase(
        page: 0,
        pageSize: _pageSize,
        sourceExpenses: allExpenses,
      );

      emit(
        ExpenseLoaded(
          expenses: allExpenses,
          displayedExpenses: displayedExpenses,
          currentPage: 0,
          hasMore: displayedExpenses.length < allExpenses.length,
        ),
      );
    } catch (e) {
      emit(ExpenseError('Failed to load expenses: $e'));
    }
  }

  /// Add a new expense
  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await addExpenseUseCase(event.expense);

      // Reload expenses after adding
      add(const LoadExpenses());

      emit(const ExpenseOperationSuccess('Expense added successfully'));
    } catch (e) {
      emit(ExpenseError('Failed to add expense: $e'));
    }
  }

  /// Update an existing expense
  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await repository.updateExpense(event.expense);

      // Reload expenses after updating
      add(const LoadExpenses());

      emit(const ExpenseOperationSuccess('Expense updated successfully'));
    } catch (e) {
      emit(ExpenseError('Failed to update expense: $e'));
    }
  }

  /// Delete an expense
  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await repository.deleteExpense(event.id);

      // Reload expenses after deleting
      add(const LoadExpenses());

      emit(const ExpenseOperationSuccess('Expense deleted successfully'));
    } catch (e) {
      emit(ExpenseError('Failed to delete expense: $e'));
    }
  }

  /// Load more expenses (pagination)
  Future<void> _onLoadMoreExpenses(
    LoadMoreExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is! ExpenseLoaded) return;

    final currentState = state as ExpenseLoaded;

    if (!currentState.hasMore) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final newExpenses = getExpensesUseCase(
        page: nextPage,
        pageSize: _pageSize,
        sourceExpenses: currentState.expenses,
      );

      if (newExpenses.isEmpty) {
        emit(currentState.copyWith(hasMore: false));
        return;
      }

      final updatedDisplayedExpenses = [
        ...currentState.displayedExpenses,
        ...newExpenses,
      ];

      emit(
        currentState.copyWith(
          displayedExpenses: updatedDisplayedExpenses,
          currentPage: nextPage,
          hasMore:
              updatedDisplayedExpenses.length < currentState.expenses.length,
        ),
      );
    } catch (e) {
      emit(ExpenseError('Failed to load more expenses: $e'));
    }
  }

  /// Filter expenses by date range
  Future<void> _onFilterExpensesByDateRange(
    FilterExpensesByDateRange event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      emit(const ExpenseLoading());

      final filteredExpenses =
          (event.startDate != null && event.endDate != null)
          ? repository.getExpensesByDateRange(
              start: event.startDate!,
              end: event.endDate!,
            )
          : repository.getAllExpenses();

      final displayedExpenses = getExpensesUseCase(
        page: 0,
        pageSize: _pageSize,
        sourceExpenses: filteredExpenses,
      );

      emit(
        ExpenseLoaded(
          expenses: filteredExpenses,
          displayedExpenses: displayedExpenses,
          currentPage: 0,
          hasMore: displayedExpenses.length < filteredExpenses.length,
          filterStartDate: event.startDate,
          filterEndDate: event.endDate,
        ),
      );
    } catch (e) {
      emit(ExpenseError('Failed to filter expenses: $e'));
    }
  }

  /// Filter expenses by category
  Future<void> _onFilterExpensesByCategory(
    FilterExpensesByCategory event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      emit(const ExpenseLoading());

      final filteredExpenses = repository.getExpensesByCategory(event.category);
      final displayedExpenses = getExpensesUseCase(
        page: 0,
        pageSize: _pageSize,
        sourceExpenses: filteredExpenses,
      );

      emit(
        ExpenseLoaded(
          expenses: filteredExpenses,
          displayedExpenses: displayedExpenses,
          currentPage: 0,
          hasMore: displayedExpenses.length < filteredExpenses.length,
          filterCategory: event.category,
        ),
      );
    } catch (e) {
      emit(ExpenseError('Failed to filter expenses: $e'));
    }
  }

  /// Reset all filters
  Future<void> _onResetFilters(
    ResetFilters event,
    Emitter<ExpenseState> emit,
  ) async {
    add(const LoadExpenses());
  }
}
