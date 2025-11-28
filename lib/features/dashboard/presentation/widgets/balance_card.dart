import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;
  final bool isLoading;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, Color(0xFF5B86E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          isLoading
              ? Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                )
              : Text(
                  CurrencyFormatter.format(balance, currency: 'USD'),
                  style: AppTextStyles.header.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.arrow_downward,
                  label: 'Income',
                  amount: income,
                  color: AppColors.incomeGreen,
                  isLoading: isLoading,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.arrow_upward,
                  label: 'Expenses',
                  amount: expenses,
                  color: AppColors.expenseRed,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
    required bool isLoading,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 4),
            isLoading
                ? Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                : Text(
                    CurrencyFormatter.format(amount, currency: 'USD'),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
