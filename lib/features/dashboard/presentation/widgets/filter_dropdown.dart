import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/repositories/dashboard_repository.dart';

class FilterDropdown extends StatelessWidget {
  final DashboardFilterType selectedFilter;
  final Function(DashboardFilterType) onFilterChanged;

  const FilterDropdown({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DashboardFilterType>(
          value: selectedFilter,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textLight,
          ),
          style: AppTextStyles.bodyMedium,
          onChanged: (DashboardFilterType? newValue) {
            if (newValue != null) {
              onFilterChanged(newValue);
            }
          },
          items: const [
            DropdownMenuItem(
              value: DashboardFilterType.allTime,
              child: Text('All Time'),
            ),
            DropdownMenuItem(
              value: DashboardFilterType.thisMonth,
              child: Text('This Month'),
            ),
            DropdownMenuItem(
              value: DashboardFilterType.last7Days,
              child: Text('Last 7 Days'),
            ),
            DropdownMenuItem(
              value: DashboardFilterType.last30Days,
              child: Text('Last 30 Days'),
            ),
          ],
        ),
      ),
    );
  }
}
