import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/category_icons.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/expense.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final categoryItem =
        AppCategories.getCategoryByName(expense.category) ??
        const CategoryItem(
          name: 'Other',
          icon: Icons.category,
          color: AppColors.primaryBlue,
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryItem.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(categoryItem.icon, color: categoryItem.color, size: 24),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatExpenseDate(expense.date),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-${CurrencyFormatter.format(expense.amount, currency: expense.currency)}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.expenseRed,
                ),
              ),
              if (expense.currency != 'USD') ...[
                const SizedBox(height: 4),
                Text(
                  '~${CurrencyFormatter.format(expense.amountInUSD, currency: 'USD')}',
                  style: AppTextStyles.caption,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
