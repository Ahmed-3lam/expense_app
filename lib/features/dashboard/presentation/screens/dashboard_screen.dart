import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';
import '../bloc/dashboard_event.dart';
import '../../../expense/presentation/bloc/expense_bloc.dart';
import '../../../expense/presentation/bloc/expense_event.dart';
import '../../../expense/presentation/bloc/expense_state.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../widgets/balance_card.dart';
import '../widgets/filter_dropdown.dart';
import '../../../expense/presentation/widgets/expense_list_item.dart';
import '../../../expense/presentation/screens/add_expense_screen.dart';

/// Main Dashboard Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ExpenseBloc>().add(const LoadMoreExpenses());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    context.read<DashboardBloc>().add(const RefreshDashboard());
    context.read<ExpenseBloc>().add(const LoadExpenses());
  }

  void _onFilterChanged(DashboardFilterType filter) {
    context.read<DashboardBloc>().add(ChangeFilter(filter));

    // Also update expense list filter
    DateTime? startDate;
    DateTime? endDate = DateTime.now();

    switch (filter) {
      case DashboardFilterType.thisMonth:
        startDate = DateTime(endDate.year, endDate.month, 1);
        break;
      case DashboardFilterType.last7Days:
        startDate = endDate.subtract(const Duration(days: 7));
        break;
      case DashboardFilterType.last30Days:
        startDate = endDate.subtract(const Duration(days: 30));
        break;
      case DashboardFilterType.allTime:
        startDate = null;
        endDate = null;
        break;
    }

    context.read<ExpenseBloc>().add(
      FilterExpensesByDateRange(startDate: startDate, endDate: endDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primaryBlue,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar & Profile Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Alex Johnson', style: AppTextStyles.header),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.pravatar.cc/150?img=12',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Balance Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state is DashboardLoaded) {
                        return BalanceCard(
                          balance: state.totalBalance,
                          income: state.totalIncome,
                          expenses: state.totalExpenses,
                          isLoading: false,
                        );
                      }
                      return const BalanceCard(
                        balance: 0,
                        income: 0,
                        expenses: 0,
                        isLoading: true,
                      );
                    },
                  ),
                ),
              ),

              // Transactions Header & Filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transactions', style: AppTextStyles.subHeader),
                      BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, state) {
                          DashboardFilterType currentFilter =
                              DashboardFilterType.allTime;
                          if (state is DashboardLoaded) {
                            currentFilter = state.currentFilter;
                          }

                          return FilterDropdown(
                            selectedFilter: currentFilter,
                            onFilterChanged: _onFilterChanged,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Expense List
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoading && state is! ExpenseLoaded) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    );
                  }

                  if (state is ExpenseError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    );
                  }

                  if (state is ExpenseLoaded) {
                    if (state.displayedExpenses.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                size: 64,
                                color: AppColors.textLight,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No expenses found',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= state.displayedExpenses.length) {
                            return state.hasMore
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 80,
                                  ); // Bottom padding for FAB
                          }

                          final expense = state.displayedExpenses[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: ExpenseListItem(expense: expense),
                          );
                        },
                        childCount:
                            state.displayedExpenses.length +
                            (state.hasMore ? 1 : 0),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );

          if (result == true && mounted) {
            _onRefresh();
          }
        },
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
