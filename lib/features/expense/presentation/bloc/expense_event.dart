import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

/// Base class for all expense events
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load expenses
class LoadExpenses extends ExpenseEvent {
  const LoadExpenses();
}

/// Event to add a new expense
class AddExpense extends ExpenseEvent {
  final Expense expense;

  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

/// Event to update an existing expense
class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  const UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

/// Event to delete an expense
class DeleteExpense extends ExpenseEvent {
  final String id;

  const DeleteExpense(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to load more expenses (pagination)
class LoadMoreExpenses extends ExpenseEvent {
  const LoadMoreExpenses();
}

/// Event to filter expenses by date range
class FilterExpensesByDateRange extends ExpenseEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterExpensesByDateRange({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event to filter expenses by category
class FilterExpensesByCategory extends ExpenseEvent {
  final String category;

  const FilterExpensesByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// Event to reset filters
class ResetFilters extends ExpenseEvent {
  const ResetFilters();
}
