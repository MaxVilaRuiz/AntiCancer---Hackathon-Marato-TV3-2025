import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuestionnaireStorage {
  static const String _completedDaysKey = 'completed_days';
  static const String _effectiveDateKey = 'date';
  static const String _entriesKey = 'daily_entries';

  /// Fecha efectiva (simulada o real)
  static Future<String> effectiveToday() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString(_effectiveDateKey);

    if (storedDate != null) return storedDate;

    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    await prefs.setString(_effectiveDateKey, today);
    return today;
  }

  /// Guarda el cuestionario del día con diagnóstico
  static Future<void> saveDailyEntry({
    required String diagnosis,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final today = await effectiveToday();

    // 1. Guardar día como completado
    final completedDays = prefs.getStringList(_completedDaysKey) ?? [];
    if (!completedDays.contains(today)) {
      completedDays.add(today);
      await prefs.setStringList(_completedDaysKey, completedDays);
    }

    // 2. Guardar entrada estructurada
    final rawEntries = prefs.getStringList(_entriesKey) ?? [];

    final entry = {
      'date': today,
      'diagnosis': diagnosis,
    };

    rawEntries.add(jsonEncode(entry));
    await prefs.setStringList(_entriesKey, rawEntries);
  }

  static Future<bool> hasCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = await effectiveToday();
    final completedDays =
        prefs.getStringList(_completedDaysKey) ?? [];

    return completedDays.contains(today);
  }

  /// (Preparado para el futuro)
  static Future<List<Map<String, dynamic>>> getLastEntries(
      int days) async {
    final prefs = await SharedPreferences.getInstance();
    final rawEntries = prefs.getStringList(_entriesKey) ?? [];

    return rawEntries
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  /// DEBUG
  static Future<void> setSimulatedDate(String yyyyMmDd) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_effectiveDateKey, yyyyMmDd);
  }

  static Future<void> clearSimulatedDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_effectiveDateKey);
  }
}