import 'package:hive_flutter/hive_flutter.dart';
import '../../features/expense/data/models/expense_model.dart';

/// Hive initialization service
class HiveInitializer {
  static const String _expenseBoxName = 'expenses';
  static const String _settingsBoxName = 'settings';

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExpenseModelAdapter());
    }

    // Open boxes
    await Hive.openBox<ExpenseModel>(_expenseBoxName);
    await Hive.openBox(_settingsBoxName);
  }
}
