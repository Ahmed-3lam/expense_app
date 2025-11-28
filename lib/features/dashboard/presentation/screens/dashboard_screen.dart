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
import '../widgets/balance_card.dart';
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

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Blue Background Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primaryBlue,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App Bar & Profile Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://i.pravatar.cc/150?img=12',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good Morning',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Shihab Rahman',
                                    style: AppTextStyles.header.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'This month',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppColors.textDark,
                                ),
                              ],
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

                  // Recent Expenses Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Expenses',
                            style: AppTextStyles.subHeader.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'see all',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
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
                                    : const SizedBox(height: 100);
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
        ],
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
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
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_filled,
                  color: _selectedIndex == 0
                      ? AppColors.primaryBlue
                      : AppColors.textLight,
                  size: 28,
                ),
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
              IconButton(
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: _selectedIndex == 1
                      ? AppColors.primaryBlue
                      : AppColors.textLight,
                  size: 28,
                ),
                onPressed: () => setState(() => _selectedIndex = 1),
              ),
              const SizedBox(width: 48), // Space for FAB
              IconButton(
                icon: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: _selectedIndex == 2
                      ? AppColors.primaryBlue
                      : AppColors.textLight,
                  size: 28,
                ),
                onPressed: () => setState(() => _selectedIndex = 2),
              ),
              IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: _selectedIndex == 3
                      ? AppColors.primaryBlue
                      : AppColors.textLight,
                  size: 28,
                ),
                onPressed: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
