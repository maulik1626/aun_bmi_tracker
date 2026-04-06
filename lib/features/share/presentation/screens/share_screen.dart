import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';
import 'package:aun_bmi_tracker/core/constants/app_strings.dart';
import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_category.dart';
import 'package:aun_bmi_tracker/features/calculator/presentation/providers/bmi_provider.dart';

class ShareScreen extends ConsumerStatefulWidget {
  const ShareScreen({super.key});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  Color _categoryColor(BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return AppColors.underweight;
      case BmiCategory.normal:
        return AppColors.normal;
      case BmiCategory.overweight:
        return AppColors.overweight;
      case BmiCategory.obese:
        return AppColors.obese;
    }
  }

  String _categoryLabel(BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return AppStrings.bmiUnderweight;
      case BmiCategory.normal:
        return AppStrings.bmiNormal;
      case BmiCategory.overweight:
        return AppStrings.bmiOverweight;
      case BmiCategory.obese:
        return AppStrings.bmiObese;
    }
  }

  Future<void> _shareResult() async {
    setState(() => _isSharing = true);
    HapticFeedback.mediumImpact();

    try {
      final result = ref.read(bmiNotifierProvider).valueOrNull;
      if (result == null) return;

      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          final bytes = byteData.buffer.asUint8List();
          await Share.shareXFiles(
            [
              XFile.fromData(
                bytes,
                mimeType: 'image/png',
                name: 'bmi_result.png',
              ),
            ],
            text:
                'My BMI is ${result.bmi.toStringAsFixed(1)} (${_categoryLabel(result.category)}). '
                'Tracked with ${AppStrings.appName}!',
          );
          return;
        }
      }

      await Share.share(
        'My BMI is ${result.bmi.toStringAsFixed(1)} '
        '(${_categoryLabel(result.category)}). '
        'Weight: ${result.weightKg.toStringAsFixed(1)} kg, '
        'Height: ${result.heightCm.toStringAsFixed(0)} cm. '
        'Tracked with ${AppStrings.appName}!',
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bmiState = ref.watch(bmiNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : null,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          AppStrings.shareTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark
                ? AppColors.darkOnSurface
                : AppColors.lightOnSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: bmiState.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (result) {
          if (result == null) {
            return const Center(child: Text('No result to share.'));
          }

          final color = _categoryColor(result.category);
          final label = _categoryLabel(result.category);

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        AppDimensions.screenPaddingH),
                    child: RepaintBoundary(
                      key: _repaintKey,
                      child: _ShareCard(
                        bmi: result.bmi,
                        label: label,
                        color: color,
                        weightKg: result.weightKg,
                        heightCm: result.heightCm,
                        age: result.ageYears,
                        idealMin: result.idealWeightMin,
                        idealMax: result.idealWeightMax,
                      ),
                    ),
                  ),
                ),
              ),

              // ---- Share button ----
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                ),
                child: GestureDetector(
                  onTap: _isSharing ? null : _shareResult,
                  child: Container(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight,
                    decoration: BoxDecoration(
                      gradient:
                          _isSharing ? null : AppColors.primaryGradient,
                      color: _isSharing
                          ? AppColors.disabled.withValues(alpha: 0.3)
                          : null,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.buttonBorderRadius),
                      boxShadow: _isSharing
                          ? null
                          : [
                              BoxShadow(
                                color: AppColors.primary
                                    .withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isSharing)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          const Icon(Icons.ios_share_rounded,
                              color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          _isSharing ? 'Sharing...' : AppStrings.btnShare,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppDimensions.spacingXl +
                    MediaQuery.of(context).padding.bottom,
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Premium share card - dark gradient, clean typography
// ---------------------------------------------------------------------------

class _ShareCard extends StatelessWidget {
  const _ShareCard({
    required this.bmi,
    required this.label,
    required this.color,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.idealMin,
    required this.idealMax,
  });

  final double bmi;
  final String label;
  final Color color;
  final double weightKg;
  final double heightCm;
  final int age;
  final double idealMin;
  final double idealMax;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        child: Stack(
          children: [
            // Subtle decorative circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.04),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingXxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App branding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.appName.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingXxl),

                  // BMI hero number
                  Text(
                    bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: -2,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),

                  // Category pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusRound),
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXxl),

                  // Stat row - clean dividers
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingLg,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          value: '${weightKg.toStringAsFixed(1)}',
                          unit: 'kg',
                          label: 'Weight',
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        _StatItem(
                          value: '${heightCm.toStringAsFixed(0)}',
                          unit: 'cm',
                          label: 'Height',
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        _StatItem(
                          value: '$age',
                          unit: '',
                          label: 'Age',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // Ideal weight
                  Text(
                    'Ideal: ${idealMin.toStringAsFixed(1)} - ${idealMax.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat item for share card
// ---------------------------------------------------------------------------

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.unit,
    required this.label,
  });

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.35),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
