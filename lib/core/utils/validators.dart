/// Form validators for BMI input fields.
class Validators {
  Validators._();

  // ──────────────────────────── Height ───────────────────────────

  /// Validates height in centimeters. Acceptable range: 50–300 cm.
  static String? heightCm(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your height';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed < 50) {
      return 'Height must be at least 50 cm';
    }
    if (parsed > 300) {
      return 'Height must be less than 300 cm';
    }
    return null;
  }

  /// Validates height in feet. Acceptable range: 1–10 ft.
  static String? heightFeet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter feet';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed < 1 || parsed > 10) {
      return 'Feet must be between 1 and 10';
    }
    return null;
  }

  /// Validates height inches portion. Acceptable range: 0–11.
  static String? heightInches(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter inches';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed < 0 || parsed >= 12) {
      return 'Inches must be between 0 and 11';
    }
    return null;
  }

  // ──────────────────────────── Weight ───────────────────────────

  /// Validates weight in kilograms. Acceptable range: 10–500 kg.
  static String? weightKg(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your weight';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed < 10) {
      return 'Weight must be at least 10 kg';
    }
    if (parsed > 500) {
      return 'Weight must be less than 500 kg';
    }
    return null;
  }

  /// Validates weight in pounds. Acceptable range: 22–1100 lb.
  static String? weightLb(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your weight';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid number';
    }
    if (parsed < 22) {
      return 'Weight must be at least 22 lb';
    }
    if (parsed > 1100) {
      return 'Weight must be less than 1100 lb';
    }
    return null;
  }

  // ──────────────────────────── Age ──────────────────────────────

  /// Validates age. Acceptable range: 2–120 years.
  static String? age(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your age';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid whole number';
    }
    if (parsed < 2) {
      return 'Age must be at least 2';
    }
    if (parsed > 120) {
      return 'Age must be less than 120';
    }
    return null;
  }

  // ──────────────────────────── Generic ─────────────────────────

  /// Validates that a field is not empty.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates that a string is a positive number.
  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a value';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid positive number';
    }
    return null;
  }
}
