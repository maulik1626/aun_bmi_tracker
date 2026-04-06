import 'package:flutter/material.dart';

/// Premium color palette for AUN BMI Tracker.
///
/// Dark-first design language inspired by Apple Health, Oura Ring,
/// and premium fitness trackers. Every value is intentional.
class AppColors {
  AppColors._();

  // ──────────────────────────── Brand / Accent ──────────────────────
  /// Primary accent - refined teal that reads as "health" without being clinical.
  static const Color primary = Color(0xFF00BFA6);
  static const Color primaryLight = Color(0xFF5DFFD2);
  static const Color primaryDark = Color(0xFF008E76);
  static const Color primaryMuted = Color(0xFF00BFA6); // for dark theme use

  /// Secondary accent - warm gold for highlights, achievements, premium feel.
  static const Color secondary = Color(0xFFE0A861);
  static const Color secondaryLight = Color(0xFFF5CC8E);
  static const Color secondaryDark = Color(0xFFB8843A);

  // ──────────────────────────── BMI Zones (muted, sophisticated) ────
  /// Desaturated, elegant zone colors that don't scream.
  static const Color underweight = Color(0xFF64B5F6); // soft blue
  static const Color normal = Color(0xFF66BB6A); // calm green
  static const Color overweight = Color(0xFFFFB74D); // warm amber
  static const Color obese = Color(0xFFEF5350); // restrained red

  // ──────────────────────────── Dark Theme (Hero) ───────────────────
  static const Color darkBackground = Color(0xFF0D0D0D); // near-black
  static const Color darkSurface = Color(0xFF1A1A1E); // card surface
  static const Color darkSurfaceVariant = Color(0xFF242428); // elevated surface
  static const Color darkSurfaceHigh = Color(0xFF2E2E34); // highest elevation
  static const Color darkOnBackground = Color(0xFFF5F5F7); // primary text
  static const Color darkOnSurface = Color(0xFFF5F5F7);
  static const Color darkOnSurfaceSecondary = Color(0xFFB0B0B8); // secondary text
  static const Color darkOnSurfaceTertiary = Color(0xFF6E6E78); // tertiary / hint
  static const Color darkOnPrimary = Color(0xFF003D33); // text on primary
  static const Color darkOnSecondary = Color(0xFF3E2800);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnError = Color(0xFF1E1E1E);
  static const Color darkOutline = Color(0xFF3A3A42); // subtle borders
  static const Color darkDivider = Color(0xFF2A2A30);

  // ──────────────────────────── Light Theme ─────────────────────────
  static const Color lightBackground = Color(0xFFF8F9FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F1F5);
  static const Color lightOnBackground = Color(0xFF111114);
  static const Color lightOnSurface = Color(0xFF111114);
  static const Color lightOnSurfaceSecondary = Color(0xFF6B6B76);
  static const Color lightOnSurfaceTertiary = Color(0xFFA0A0AA);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFB3261E);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOutline = Color(0xFFE0E0E6);
  static const Color lightDivider = Color(0xFFECECF0);

  // ──────────────────────────── Semantic ─────────────────────────────
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);
  static const Color disabled = Color(0xFF5C5C66);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  /// Subtle shimmer for premium card borders in dark mode.
  static const Color cardBorderDark = Color(0xFF2A2A30);
  static const Color cardBorderLight = Color(0xFFE8E8EE);

  /// Returns the appropriate BMI zone color for a given BMI value.
  static Color bmiColor(double bmi) {
    if (bmi < 18.5) return underweight;
    if (bmi < 25.0) return normal;
    if (bmi < 30.0) return overweight;
    return obese;
  }

  // ──────────────────────────── Gradients ────────────────────────────
  /// Premium dark gradient for splash and hero sections.
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D0D0D),
      Color(0xFF141418),
      Color(0xFF0D0D0D),
    ],
  );

  /// Subtle accent gradient for buttons and highlights.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00BFA6),
      Color(0xFF00D4B8),
    ],
  );

  // ──────────────────────────── ColorScheme helpers ──────────────────
  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: lightOnPrimary,
        secondary: secondary,
        onSecondary: lightOnSecondary,
        error: lightError,
        onError: lightOnError,
        surface: lightSurface,
        onSurface: lightOnSurface,
        outline: lightOutline,
        surfaceContainerHighest: lightSurfaceVariant,
      );

  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: darkOnPrimary,
        secondary: secondary,
        onSecondary: darkOnSecondary,
        error: darkError,
        onError: darkOnError,
        surface: darkSurface,
        onSurface: darkOnSurface,
        outline: darkOutline,
        surfaceContainerHighest: darkSurfaceVariant,
      );
}
