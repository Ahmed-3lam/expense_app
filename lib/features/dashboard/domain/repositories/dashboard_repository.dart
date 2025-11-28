import 'package:expense_app/features/expense/domain/entities/expense.dart';

import '../entities/dashboard_summary.dart';

/// Filter types for dashboard
enum DashboardFilterType { allTime, thisMonth, last7Days, last30Days }

/// Repository interface for dashboard operations (domain layer)
abstract class DashboardRepository {
  Future<DashboardSummary> getDashboardSummary({
    DashboardFilterType filter = DashboardFilterType.allTime,
  });

  Future<List<Expense>> getFilteredExpenses({
    DashboardFilterType filter = DashboardFilterType.allTime,
  });
}
