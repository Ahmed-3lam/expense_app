import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

/// Local data source for currency rates using Hive
@lazySingleton
class CurrencyLocalDataSource {
  static const String _boxName = 'settings';
  static const String _ratesKey = 'currency_rates';
  static const String _timestampKey = 'currency_rates_timestamp';

  Box get _box => Hive.box(_boxName);

  /// Save currency rates cache
  Future<void> saveCurrencyRates(Map<String, dynamic> rates) async {
    await _box.put(_ratesKey, rates);
    await _box.put(_timestampKey, DateTime.now().toIso8601String());
  }

  /// Get cached currency rates
  Map<String, dynamic>? getCachedCurrencyRates() {
    final timestamp = _box.get(_timestampKey) as String?;
    if (timestamp == null) return null;

    final cachedTime = DateTime.parse(timestamp);
    final now = DateTime.now();

    // Cache valid for 24 hours
    if (now.difference(cachedTime).inHours > 24) {
      return null;
    }

    // Cast the dynamic map to Map<String, dynamic>
    final data = _box.get(_ratesKey);
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }
}
