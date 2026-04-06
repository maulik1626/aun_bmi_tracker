import 'package:intl/intl.dart';

// ════════════════════════════════════════════════════════════════
// String extensions
// ════════════════════════════════════════════════════════════════

extension StringX on String {
  /// Capitalizes the first letter: "hello" → "Hello".
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalizes every word: "hello world" → "Hello World".
  String get titleCase =>
      split(' ').map((w) => w.capitalize).join(' ');

  /// Returns `true` if the string is a valid numeric value.
  bool get isNumeric => double.tryParse(this) != null;

  /// Returns `null` if the string is empty, otherwise returns itself.
  String? get nullIfEmpty => isEmpty ? null : this;

  /// Truncates the string to [maxLength] and appends an ellipsis if needed.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

// ════════════════════════════════════════════════════════════════
// DateTime extensions
// ════════════════════════════════════════════════════════════════

extension DateTimeX on DateTime {
  /// Formats as "Apr 7, 2026".
  String get formatted => DateFormat.yMMMd().format(this);

  /// Formats as "04/07/2026".
  String get shortDate => DateFormat('MM/dd/yyyy').format(this);

  /// Formats as "April 7, 2026 3:30 PM".
  String get fullDateTime => DateFormat.yMMMMd().add_jm().format(this);

  /// Formats as "3:30 PM".
  String get timeOnly => DateFormat.jm().format(this);

  /// Formats as "2026-04-07" (ISO date only).
  String get isoDate => DateFormat('yyyy-MM-dd').format(this);

  /// Returns true if this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns true if this date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns a human-readable relative label: "Today", "Yesterday", or formatted date.
  String get relativeLabel {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    return formatted;
  }

  /// Returns the date with time set to midnight.
  DateTime get dateOnly => DateTime(year, month, day);
}

// ════════════════════════════════════════════════════════════════
// double (numeric) extensions
// ════════════════════════════════════════════════════════════════

extension DoubleX on double {
  /// Formats to one decimal place: 24.56789 → "24.6".
  String get toOneDecimal => toStringAsFixed(1);

  /// Formats to two decimal places: 24.5 → "24.50".
  String get toTwoDecimal => toStringAsFixed(2);

  /// Formats as a BMI value (one decimal): 22.345 → "22.3".
  String get asBmi => toStringAsFixed(1);

  /// Formats with the given number of decimal places, stripping trailing zeros.
  String toPrecision(int fractionDigits) {
    final s = toStringAsFixed(fractionDigits);
    if (!s.contains('.')) return s;
    // Remove trailing zeros after the decimal point.
    final trimmed = s.replaceAll(RegExp(r'0+$'), '');
    return trimmed.endsWith('.') ? trimmed.substring(0, trimmed.length - 1) : trimmed;
  }

  /// Converts centimeters to feet + inches tuple.
  ({int feet, double inches}) get cmToFeetInches {
    final totalInches = this / 2.54;
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return (feet: feet, inches: inches);
  }

  /// Converts kilograms to pounds.
  double get kgToLb => this * 2.20462;

  /// Converts pounds to kilograms.
  double get lbToKg => this / 2.20462;
}

// ════════════════════════════════════════════════════════════════
// int extensions
// ════════════════════════════════════════════════════════════════

extension IntX on int {
  /// Converts feet to centimeters (combine with inches separately).
  double get feetToCm => this * 30.48;

  /// Pads with a leading zero: 7 → "07".
  String get twoDigits => toString().padLeft(2, '0');
}
