import 'package:flutter/material.dart';

/// Premium typography system for AUN BMI Tracker.
///
/// Uses the system default font (SF Pro on iOS, Roboto on Android) with
/// carefully chosen weights, sizes, and spacing for a refined hierarchy.
/// Thin weights for display, medium for structure, regular for reading.
class AppTextStyles {
  AppTextStyles._();

  // We omit fontFamily to use the platform default, which looks most native
  // and premium on each platform (SF Pro on iOS, Roboto on Android).

  // ──────────────────────────── Display ──────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w200, // thin, elegant
    letterSpacing: -1.5,
    height: 1.1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w200,
    letterSpacing: -0.5,
    height: 1.14,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.25,
    height: 1.2,
  );

  // ──────────────────────────── Headline ─────────────────────────
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.28,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.33,
  );

  // ──────────────────────────── Title ────────────────────────────
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // ──────────────────────────── Body ─────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.55,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.4,
  );

  // ──────────────────────────── Label ────────────────────────────
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // ──────────────────────────── Custom (BMI) ────────────────────
  /// Large BMI value - ultra-thin weight for dramatic, premium display.
  static const TextStyle bmiValue = TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.w100, // ultra-thin, like Apple Health
    letterSpacing: -2.0,
    height: 1.0,
  );

  /// BMI category label - understated but clear.
  static const TextStyle bmiCategory = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2, // generous tracking for labels
    height: 1.4,
  );

  /// Unit label beside input fields.
  static const TextStyle unitLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: Color(0xFFB0B0B8),
  );

  /// Small caps-style section headers.
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.4,
  );

  /// Returns the complete M3 TextTheme built from these styles.
  static TextTheme get textTheme => const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
