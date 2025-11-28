import 'package:injectable/injectable.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Use case for getting dashboard summary
@injectable
class GetDashboardSummaryUseCase {
  final DashboardRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  Future<DashboardSummary> call({
    DashboardFilterType filter = DashboardFilterType.allTime,
  }) {
    return repository.getDashboardSummary(filter: filter);
  }
}
