import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

/// Base class for all expense states
abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

/// Loading state
class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

/// Loaded state with expenses
class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final List<Expense> displayedExpenses;
  final int currentPage;
  final bool hasMore;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String? filterCategory;

  const ExpenseLoaded({
    required this.expenses,
    required this.displayedExpenses,
    this.currentPage = 0,
    this.hasMore = true,
    this.filterStartDate,
    this.filterEndDate,
    this.filterCategory,
  });

  ExpenseLoaded copyWith({
    List<Expense>? expenses,
    List<Expense>? displayedExpenses,
    int? currentPage,
    bool? hasMore,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? filterCategory,
    bool clearFilters = false,
  }) {
    return ExpenseLoaded(
      expenses: expenses ?? this.expenses,
      displayedExpenses: displayedExpenses ?? this.displayedExpenses,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      filterStartDate: clearFilters
          ? null
          : (filterStartDate ?? this.filterStartDate),
      filterEndDate: clearFilters
          ? null
          : (filterEndDate ?? this.filterEndDate),
      filterCategory: clearFilters
          ? null
          : (filterCategory ?? this.filterCategory),
    );
  }

  @override
  List<Object?> get props => [
    expenses,
    displayedExpenses,
    currentPage,
    hasMore,
    filterStartDate,
    filterEndDate,
    filterCategory,
  ];
}

/// Error state
class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Loading more expenses state
class ExpenseLoadingMore extends ExpenseState {
  final List<Expense> currentExpenses;

  const ExpenseLoadingMore(this.currentExpenses);

  @override
  List<Object?> get props => [currentExpenses];
}

/// Expense operation success state
class ExpenseOperationSuccess extends ExpenseState {
  final String message;

  const ExpenseOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
