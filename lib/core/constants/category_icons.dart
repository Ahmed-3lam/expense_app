import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Category model with icon and color
class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// Predefined expense categories matching the design
class AppCategories {
  AppCategories._();

  static const List<CategoryItem> categories = [
    CategoryItem(
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: AppColors.categoryGroceries,
    ),
    CategoryItem(
      name: 'Entertainment',
      icon: Icons.sports_esports,
      color: AppColors.categoryEntertainment,
    ),
    CategoryItem(
      name: 'Gas',
      icon: Icons.local_gas_station,
      color: AppColors.categoryGas,
    ),
    CategoryItem(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: AppColors.categoryShopping,
    ),
    CategoryItem(
      name: 'News Paper',
      icon: Icons.newspaper,
      color: AppColors.categoryNewsPaper,
    ),
    CategoryItem(
      name: 'Transport',
      icon: Icons.directions_car,
      color: AppColors.categoryTransport,
    ),
    CategoryItem(name: 'Rent', icon: Icons.home, color: AppColors.categoryRent),
  ];

  /// Get category by name
  static CategoryItem? getCategoryByName(String name) {
    try {
      return categories.firstWhere(
        (category) => category.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get category icon
  static IconData getCategoryIcon(String categoryName) {
    final category = getCategoryByName(categoryName);
    return category?.icon ?? Icons.category;
  }

  /// Get category color
  static Color getCategoryColor(String categoryName) {
    final category = getCategoryByName(categoryName);
    return category?.color ?? AppColors.primaryBlue;
  }
}
