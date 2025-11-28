import 'package:equatable/equatable.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Base class for all dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to change filter
class ChangeFilter extends DashboardEvent {
  final DashboardFilterType filterType;

  const ChangeFilter(this.filterType);

  @override
  List<Object?> get props => [filterType];
}

/// Event to load dashboard data
class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

/// Event to refresh dashboard
class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}
