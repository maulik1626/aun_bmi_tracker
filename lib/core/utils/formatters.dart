import 'package:intl/intl.dart';

/// BMI value and date formatting utilities.
class Formatters {
  Formatters._();

  // ──────────────────────────── BMI ──────────────────────────────

  /// Formats a BMI double to one decimal place: 22.345 → "22.3".
  static String bmi(double value) => value.toStringAsFixed(1);

  /// Formats a BMI double to a display string with the "BMI" label.
  static String bmiWithLabel(double value) => 'BMI ${bmi(value)}';

  /// Returns a short BMI category string for the given value.
  static String bmiCategory(double value) {
    if (value < 18.5) return 'Underweight';
    if (value < 25.0) return 'Normal';
    if (value < 30.0) return 'Overweight';
    return 'Obese';
  }

  // ──────────────────────────── Height ───────────────────────────

  /// Formats height in cm: 175.0 → "175.0 cm".
  static String heightCm(double cm) => '${cm.toStringAsFixed(1)} cm';

  /// Formats height in feet and inches: 5 ft 9 in.
  static String heightFtIn(int feet, double inches) =>
      '$feet ft ${inches.toStringAsFixed(0)} in';

  /// Converts cm to feet/inches and formats: 175.0 → "5 ft 9 in".
  static String heightCmToFtIn(double cm) {
    final totalInches = cm / 2.54;
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return '$feet ft ${inches.toStringAsFixed(0)} in';
  }

  // ──────────────────────────── Weight ───────────────────────────

  /// Formats weight in kg: 72.5 → "72.5 kg".
  static String weightKg(double kg) => '${kg.toStringAsFixed(1)} kg';

  /// Formats weight in lb: 159.8 → "159.8 lb".
  static String weightLb(double lb) => '${lb.toStringAsFixed(1)} lb';

  // ──────────────────────────── Date ─────────────────────────────

  /// Formats as "Apr 7, 2026".
  static String dateMedium(DateTime date) => DateFormat.yMMMd().format(date);

  /// Formats as "04/07/2026".
  static String dateShort(DateTime date) =>
      DateFormat('MM/dd/yyyy').format(date);

  /// Formats as "April 7, 2026".
  static String dateLong(DateTime date) => DateFormat.yMMMMd().format(date);

  /// Formats as "2026-04-07" (ISO).
  static String dateIso(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  /// Formats as "April 7, 2026 3:30 PM".
  static String dateTimeFull(DateTime date) =>
      DateFormat.yMMMMd().add_jm().format(date);

  /// Formats as "3:30 PM".
  static String timeOnly(DateTime date) => DateFormat.jm().format(date);

  /// Returns "Today", "Yesterday", or a medium-formatted date.
  static String dateRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final diff = today.difference(dateOnly).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return dateMedium(date);
  }

  // ──────────────────────────── Numbers ─────────────────────────

  /// Formats a number with commas: 12500 → "12,500".
  static String number(num value) => NumberFormat('#,##0').format(value);

  /// Formats a decimal number: 12500.5 → "12,500.5".
  static String decimal(double value, {int decimalDigits = 1}) =>
      NumberFormat('#,##0.${'0' * decimalDigits}').format(value);

  /// Formats a percentage: 0.754 → "75.4%".
  static String percent(double value, {int decimalDigits = 1}) =>
      '${(value * 100).toStringAsFixed(decimalDigits)}%';
}
