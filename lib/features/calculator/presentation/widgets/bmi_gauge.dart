import 'dart:math';

import 'package:flutter/material.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';

/// A premium animated semi-circular arc gauge that visualises a BMI value.
///
/// Features:
/// - Muted, sophisticated zone colours with smooth transitions
/// - Subtle glow effect on the needle tip
/// - Clean tick marks with refined typography
/// - Smooth animated sweep with easeOutCubic curve
class BmiGauge extends StatelessWidget {
  const BmiGauge({
    super.key,
    required this.bmiValue,
    required this.categoryLabel,
    required this.categoryColor,
  });

  final double bmiValue;
  final String categoryLabel;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: bmiValue),
      duration: const Duration(milliseconds: 1800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedBmi, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 2,
              child: CustomPaint(
                painter: _BmiGaugePainter(
                  animatedBmi: animatedBmi,
                  isDark: isDark,
                  categoryColor: categoryColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // BMI value - hero number
            Text(
              animatedBmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w700,
                color: categoryColor,
                letterSpacing: -1,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            // Category pill
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: categoryColor.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Text(
                categoryLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: categoryColor,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Gauge painter - premium design
// ---------------------------------------------------------------------------

class _BmiGaugePainter extends CustomPainter {
  _BmiGaugePainter({
    required this.animatedBmi,
    required this.isDark,
    required this.categoryColor,
  });

  final double animatedBmi;
  final bool isDark;
  final Color categoryColor;

  static const double _minBmi = 10;
  static const double _maxBmi = 40;

  // Muted, sophisticated zone colours
  static const List<_Zone> _zones = [
    _Zone(start: 10, end: 18.5, color: AppColors.underweight),
    _Zone(start: 18.5, end: 25, color: AppColors.normal),
    _Zone(start: 25, end: 30, color: AppColors.overweight),
    _Zone(start: 30, end: 40, color: AppColors.obese),
  ];

  static const List<double> _tickValues = [18.5, 25, 30];

  double _bmiToAngle(double bmi) {
    final clamped = bmi.clamp(_minBmi, _maxBmi);
    final fraction = (clamped - _minBmi) / (_maxBmi - _minBmi);
    return pi * (1 - fraction);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = min(size.width / 2, size.height) * 0.82;
    const arcWidth = 16.0;
    const gapAngle = 0.02; // subtle gap between zones

    // Background track (subtle)
    final trackPaint = Paint()
      ..color = isDark
          ? AppColors.darkSurfaceVariant
          : AppColors.lightSurfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      -pi,
      false,
      trackPaint,
    );

    // Draw colour-coded arc zones with gaps
    for (int i = 0; i < _zones.length; i++) {
      final zone = _zones[i];
      double startAngle = _bmiToAngle(zone.start);
      double endAngle = _bmiToAngle(zone.end);

      // Add gap between zones (except at edges)
      if (i > 0) startAngle -= gapAngle;
      if (i < _zones.length - 1) endAngle += gapAngle;

      final sweepAngle = endAngle - startAngle;

      final paint = Paint()
        ..color = zone.color.withValues(alpha: isDark ? 0.7 : 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }

    // Elegant tick marks at key boundaries
    for (final tick in _tickValues) {
      final angle = _bmiToAngle(tick);
      final outerPoint = Offset(
        center.dx + (radius + arcWidth / 2 + 3) * cos(angle),
        center.dy + (radius + arcWidth / 2 + 3) * sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - arcWidth / 2 - 3) * cos(angle),
        center.dy + (radius - arcWidth / 2 - 3) * sin(angle),
      );

      final tickPaint = Paint()
        ..color = isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(innerPoint, outerPoint, tickPaint);

      // Tick label
      final labelOffset = Offset(
        center.dx + (radius + arcWidth / 2 + 18) * cos(angle),
        center.dy + (radius + arcWidth / 2 + 18) * sin(angle),
      );
      _drawTickLabel(canvas, tick.toString(), labelOffset);
    }

    // Min / max labels
    _drawTickLabel(
      canvas,
      _minBmi.toInt().toString(),
      Offset(center.dx - radius - arcWidth / 2 - 18, center.dy + 8),
    );
    _drawTickLabel(
      canvas,
      _maxBmi.toInt().toString(),
      Offset(center.dx + radius + arcWidth / 2 + 18, center.dy + 8),
    );

    // Needle glow (subtle bloom at the tip)
    final needleAngle = _bmiToAngle(animatedBmi.clamp(_minBmi, _maxBmi));
    final needleLength = radius - arcWidth / 2 - 12;

    final needleTip = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    // Glow around needle tip
    final glowPaint = Paint()
      ..color = categoryColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(needleTip, 6, glowPaint);

    // Needle body - thin, elegant
    final needlePaint = Paint()
      ..color = isDark
          ? AppColors.darkOnBackground
          : AppColors.lightOnBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleTip, needlePaint);

    // Needle tip dot
    canvas.drawCircle(
      needleTip,
      4,
      Paint()..color = categoryColor,
    );

    // Pivot - refined
    canvas.drawCircle(
      center,
      5,
      Paint()
        ..color =
            isDark ? AppColors.darkSurfaceHigh : AppColors.lightSurfaceVariant,
    );
    canvas.drawCircle(
      center,
      2.5,
      Paint()
        ..color = isDark
            ? AppColors.darkOnSurfaceSecondary
            : AppColors.lightOnSurfaceSecondary,
    );
  }

  void _drawTickLabel(Canvas canvas, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isDark
              ? AppColors.darkOnSurfaceTertiary
              : AppColors.lightOnSurfaceTertiary,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_BmiGaugePainter oldDelegate) {
    return oldDelegate.animatedBmi != animatedBmi ||
        oldDelegate.isDark != isDark;
  }
}

// ---------------------------------------------------------------------------
// Helper model
// ---------------------------------------------------------------------------

class _Zone {
  const _Zone({
    required this.start,
    required this.end,
    required this.color,
  });

  final double start;
  final double end;
  final Color color;
}
