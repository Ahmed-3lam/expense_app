import 'package:equatable/equatable.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Base class for all dashboard states
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// Loading state
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// Loaded state with dashboard data
class DashboardLoaded extends DashboardState {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final DashboardFilterType currentFilter;

  const DashboardLoaded({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.currentFilter,
  });

  DashboardLoaded copyWith({
    double? totalBalance,
    double? totalIncome,
    double? totalExpenses,
    DashboardFilterType? currentFilter,
  }) {
    return DashboardLoaded(
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [
    totalBalance,
    totalIncome,
    totalExpenses,
    currentFilter,
  ];
}

/// Error state
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
