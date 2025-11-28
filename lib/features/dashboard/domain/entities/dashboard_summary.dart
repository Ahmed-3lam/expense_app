import 'package:equatable/equatable.dart';

/// Dashboard Summary entity (domain layer)
class DashboardSummary extends Equatable {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  const DashboardSummary({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  List<Object?> get props => [totalBalance, totalIncome, totalExpenses];
}
