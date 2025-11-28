import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/category_icons.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: AppCategories.categories.length + 1, // +1 for Add Category
          itemBuilder: (context, index) {
            if (index == AppCategories.categories.length) {
              // Add Category button
              return GestureDetector(
                onTap: () {
                  // TODO: Implement add category
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.divider, width: 2),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.textLight,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add Category',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final category = AppCategories.categories[index];
            final isSelected = selectedCategory == category.name;

            return GestureDetector(
              onTap: () => onCategorySelected(category.name),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category.color
                          : category.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      color: isSelected ? Colors.white : category.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected
                          ? AppColors.textDark
                          : AppColors.textLight,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
