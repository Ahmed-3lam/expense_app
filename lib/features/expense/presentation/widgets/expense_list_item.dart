import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/category_icons.dart';
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
        borderRadius: BorderRadius.circular(24),
        // Removed shadow for cleaner look as per design
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: categoryItem.color.withValues(alpha: 0.1),
              shape: BoxShape.circle, // Circular background
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manually', // Static as per design
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Amount & Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '- \$${expense.amount.toStringAsFixed(0)}', // Simplified format as per design
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Today ${TimeOfDay.fromDateTime(expense.date).format(context)}', // Simplified date
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textLight,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
