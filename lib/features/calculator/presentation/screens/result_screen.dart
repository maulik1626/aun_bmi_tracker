import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';
import 'package:aun_bmi_tracker/core/constants/app_strings.dart';
import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_category.dart';
import 'package:aun_bmi_tracker/core/services/ad_service.dart';
import 'package:aun_bmi_tracker/features/calculator/presentation/providers/bmi_provider.dart';
import 'package:aun_bmi_tracker/features/calculator/presentation/widgets/bmi_gauge.dart';

/// Tracks whether an interstitial has been shown this session.
final _interstitialShownProvider = StateProvider<bool>((ref) => false);

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shown = ref.read(_interstitialShownProvider);
      if (!shown) {
        ref.read(_interstitialShownProvider.notifier).state = true;
        AdService.instance.loadInterstitialAd().then((_) {
          AdService.instance.showInterstitialAd();
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final resultAsync = ref.watch(bmiNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : null,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          AppStrings.resultTitle,
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
          onPressed: () => context.pop(),
        ),
      ),
      body: resultAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkOnSurfaceSecondary
                  : AppColors.lightOnSurfaceSecondary,
            ),
          ),
        ),
        data: (result) {
          if (result == null) {
            return const Center(child: Text('No result available.'));
          }

          final color = _categoryColor(result.category);
          final label = _categoryLabel(result.category);
          final description = AppStrings.bmiDescription(result.bmi);

          return FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.spacingLg),

                  // ---- BMI Gauge (hero section) ----
                  BmiGauge(
                    bmiValue: result.bmi,
                    categoryLabel: label,
                    categoryColor: color,
                  ),
                  const SizedBox(height: AppDimensions.spacingXxl),

                  // ---- Description card ----
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.cardPadding),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.cardBorderRadius),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkOutline
                            : AppColors.lightOutline,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkOnSurfaceSecondary
                            : AppColors.lightOnSurfaceSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // ---- Ideal weight range card ----
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.cardPadding),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.cardBorderRadius),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkOutline
                            : AppColors.lightOutline,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd),
                          ),
                          child: const Icon(
                            Icons.monitor_weight_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingLg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IDEAL WEIGHT',
                                style:
                                    theme.textTheme.labelSmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkOnSurfaceTertiary
                                      : AppColors.lightOnSurfaceTertiary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(
                                  height: AppDimensions.spacingXs),
                              Text(
                                '${result.idealWeightMin.toStringAsFixed(1)} - '
                                '${result.idealWeightMax.toStringAsFixed(1)} kg',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXxl),

                  // ---- Action buttons ----
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Save',
                          icon: Icons.bookmark_outline_rounded,
                          isPrimary: true,
                          isDark: isDark,
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            await ref
                                .read(bmiNotifierProvider.notifier)
                                .saveCurrentResult();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(AppStrings.msgSaved),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusMd),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingMd),
                      Expanded(
                        child: _ActionButton(
                          label: 'Share',
                          icon: Icons.ios_share_rounded,
                          isPrimary: false,
                          isDark: isDark,
                          onTap: () => context.push('/share'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingXxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sleek action button
// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(AppDimensions.buttonBorderRadius),
        child: Container(
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.primaryGradient : null,
            color: isPrimary
                ? null
                : (isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurfaceVariant),
            borderRadius:
                BorderRadius.circular(AppDimensions.buttonBorderRadius),
            border: isPrimary
                ? null
                : Border.all(
                    color: isDark
                        ? AppColors.darkOutline
                        : AppColors.lightOutline,
                    width: 1,
                  ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPrimary
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkOnSurfaceSecondary
                        : AppColors.lightOnSurfaceSecondary),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isPrimary
                      ? Colors.white
                      : (isDark
                          ? AppColors.darkOnSurfaceSecondary
                          : AppColors.lightOnSurfaceSecondary),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
