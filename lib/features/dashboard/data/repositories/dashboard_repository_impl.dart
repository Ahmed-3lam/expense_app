import 'package:injectable/injectable.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../expense/domain/repositories/expense_repository.dart';
import '../../../expense/domain/entities/expense.dart';

/// Implementation of DashboardRepository (data layer)
@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final ExpenseRepository expenseRepository;

  DashboardRepositoryImpl(this.expenseRepository);

  @override
  Future<DashboardSummary> getDashboardSummary({
    DashboardFilterType filter = DashboardFilterType.allTime,
  }) async {
    final expenses = await getFilteredExpenses(filter: filter);

    final totalExpenses = expenseRepository.getTotalExpensesInUSD(
      expenses: expenses,
    );

    // For now, income is 0
    const totalIncome = 0.0;
    final totalBalance = totalIncome - totalExpenses;

    return DashboardSummary(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
    );
  }

  @override
  Future<List<Expense>> getFilteredExpenses({
    DashboardFilterType filter = DashboardFilterType.allTime,
  }) async {
    switch (filter) {
      case DashboardFilterType.thisMonth:
        return expenseRepository.getCurrentMonthExpenses();
      case DashboardFilterType.last7Days:
        return expenseRepository.getLastNDaysExpenses(7);
      case DashboardFilterType.last30Days:
        return expenseRepository.getLastNDaysExpenses(30);
      case DashboardFilterType.allTime:
        return expenseRepository.getAllExpenses();
    }
  }
}
