/// Spacing, radii, and sizing constants for consistent premium layout.
///
/// Generous whitespace, large radii, and intentional breathing room
/// create the refined feel of a premium health app.
class AppDimensions {
  AppDimensions._();

  // ──────────────────────────── Spacing ──────────────────────────
  static const double spacingXxs = 2.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;
  static const double spacingXxxl = 48.0;
  static const double spacingHuge = 64.0;

  // ──────────────────────────── Border Radii ────────────────────
  static const double radiusSm = 6.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 28.0;
  static const double radiusRound = 100.0;

  // ──────────────────────────── Icon Sizes ──────────────────────
  static const double iconSm = 18.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double iconXxl = 64.0;

  // ──────────────────────────── Button ───────────────────────────
  static const double buttonHeight = 56.0;
  static const double buttonMinWidth = 140.0;
  static const double buttonBorderRadius = 16.0;
  static const double buttonElevation = 0.0; // flat, premium feel

  // ──────────────────────────── Text Field ──────────────────────
  static const double textFieldHeight = 56.0;
  static const double textFieldBorderRadius = 14.0;

  // ──────────────────────────── Card ────────────────────────────
  static const double cardBorderRadius = 20.0;
  static const double cardElevation = 0.0; // rely on color, not shadow
  static const double cardPadding = 20.0;

  // ──────────────────────────── AppBar ──────────────────────────
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // ──────────────────────────── Bottom Nav ──────────────────────
  static const double bottomNavHeight = 72.0;

  // ──────────────────────────── BMI Gauge ───────────────────────
  static const double gaugeSize = 220.0;
  static const double gaugeStrokeWidth = 14.0;

  // ──────────────────────────── Screen Padding ──────────────────
  /// Generous horizontal padding for premium breathing room.
  static const double screenPaddingH = 24.0;
  static const double screenPaddingV = 20.0;

  // ──────────────────────────── Banner Ad ───────────────────────
  static const double bannerAdHeight = 60.0;

  // ──────────────────────────── Avatar ──────────────────────────
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;

  // ──────────────────────────── Section Spacing ─────────────────
  /// Vertical gap between major content sections.
  static const double sectionGap = 28.0;

  /// Inner padding for content areas within cards.
  static const double contentInset = 20.0;
}
