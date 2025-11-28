import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// BLoC for managing dashboard operations
@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;

  DashboardBloc(this.getDashboardSummaryUseCase)
    : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<ChangeFilter>(_onChangeFilter);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  /// Load dashboard data
  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(const DashboardLoading());

      final summary = await getDashboardSummaryUseCase(
        filter: DashboardFilterType.allTime,
      );

      emit(
        DashboardLoaded(
          totalBalance: summary.totalBalance,
          totalIncome: summary.totalIncome,
          totalExpenses: summary.totalExpenses,
          currentFilter: DashboardFilterType.allTime,
        ),
      );
    } catch (e) {
      emit(DashboardError('Failed to load dashboard: $e'));
    }
  }

  /// Change filter
  Future<void> _onChangeFilter(
    ChangeFilter event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(const DashboardLoading());

      final summary = await getDashboardSummaryUseCase(
        filter: event.filterType,
      );

      emit(
        DashboardLoaded(
          totalBalance: summary.totalBalance,
          totalIncome: summary.totalIncome,
          totalExpenses: summary.totalExpenses,
          currentFilter: event.filterType,
        ),
      );
    } catch (e) {
      emit(DashboardError('Failed to change filter: $e'));
    }
  }

  /// Refresh dashboard
  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    // Reload with current filter if possible, otherwise default
    if (state is DashboardLoaded) {
      add(ChangeFilter((state as DashboardLoaded).currentFilter));
    } else {
      add(const LoadDashboard());
    }
  }
}
