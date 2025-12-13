import 'package:shared_preferences/shared_preferences.dart';

class DailyQuestionnaireStorage {
  static const String _completedDaysKey = 'completed_days';
  static const String _effectiveDateKey = 'date'; 

  /// Devuelve la fecha efectiva (simulada o real)
  static Future<String> effectiveToday() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString(_effectiveDateKey);

    if (storedDate != null) {
      return storedDate; // 👈 USAMOS LA SIMULADA
    }

    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    await prefs.setString(_effectiveDateKey, today);
    return today;
  }

  static Future<bool> hasCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = await effectiveToday();
    final completedDays =
        prefs.getStringList(_completedDaysKey) ?? [];

    return completedDays.contains(today);
  }

  static Future<void> markTodayAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final today = await effectiveToday();
    final completedDays =
        prefs.getStringList(_completedDaysKey) ?? [];

    if (!completedDays.contains(today)) {
      completedDays.add(today);
      await prefs.setStringList(_completedDaysKey, completedDays);
    }
  }

  /// SOLO PARA DEBUG / TESTING
  static Future<void> setSimulatedDate(String yyyyMmDd) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_effectiveDateKey, yyyyMmDd);
  }

  /// Volver al comportamiento real
  static Future<void> clearSimulatedDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_effectiveDateKey);
  }
}