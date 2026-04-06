import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';
import 'package:aun_bmi_tracker/core/constants/app_strings.dart';
import 'package:aun_bmi_tracker/core/widgets/banner_ad_widget.dart';
import 'package:aun_bmi_tracker/features/calculator/presentation/providers/bmi_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _height = 170;
  double _weight = 70;
  int _age = 25;
  String _gender = 'Male';

  final _heightController = TextEditingController(text: '170');
  final _weightController = TextEditingController(text: '70');
  final _ageController = TextEditingController(text: '25');

  late final AnimationController _buttonAnimController;
  late final Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _buttonAnimController.dispose();
    super.dispose();
  }

  void _onCalculate() async {
    HapticFeedback.mediumImpact();
    _buttonAnimController.forward().then((_) {
      _buttonAnimController.reverse();
    });

    final notifier = ref.read(bmiNotifierProvider.notifier);
    await notifier.calculate(
      weight: _weight,
      height: _height,
      age: _age,
      gender: _gender,
    );

    if (mounted) {
      context.push('/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMetric = ref.watch(isMetricProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : null,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spacingXl),

              // ---- Header ----
              Text(
                AppStrings.homeTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter your details below',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkOnSurfaceTertiary
                      : AppColors.lightOnSurfaceTertiary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXxl),

              // ---- Unit toggle ----
              _buildUnitToggle(isMetric, theme, isDark),
              const SizedBox(height: AppDimensions.sectionGap),

              // ---- Gender selector ----
              _buildGenderSelector(theme, isDark),
              const SizedBox(height: AppDimensions.sectionGap),

              // ---- Height & Weight in a row ----
              _buildMeasurementsRow(isMetric, theme, isDark),
              const SizedBox(height: AppDimensions.sectionGap),

              // ---- Age input ----
              _buildAgeSection(theme, isDark),
              const SizedBox(height: AppDimensions.spacingXxxl),

              // ---- Calculate button ----
              _buildCalculateButton(theme, isDark),
              const SizedBox(height: AppDimensions.spacingXl),

              // ---- Banner ad ----
              const BannerAdWidget(),
              const SizedBox(height: AppDimensions.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────── Sub-widgets ───────────────────────────

  Widget _buildUnitToggle(bool isMetric, ThemeData theme, bool isDark) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UnitPill(
              label: AppStrings.unitMetric,
              isSelected: isMetric,
              isDark: isDark,
              onTap: () =>
                  ref.read(isMetricProvider.notifier).state = true,
            ),
            _UnitPill(
              label: AppStrings.unitImperial,
              isSelected: !isMetric,
              isDark: isDark,
              onTap: () =>
                  ref.read(isMetricProvider.notifier).state = false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _GenderPill(
            label: AppStrings.labelMale,
            icon: Icons.male_rounded,
            isSelected: _gender == 'Male',
            isDark: isDark,
            onTap: () => setState(() => _gender = 'Male'),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: _GenderPill(
            label: AppStrings.labelFemale,
            icon: Icons.female_rounded,
            isSelected: _gender == 'Female',
            isDark: isDark,
            onTap: () => setState(() => _gender = 'Female'),
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementsRow(
      bool isMetric, ThemeData theme, bool isDark) {
    final heightUnit = isMetric ? AppStrings.unitCm : AppStrings.unitIn;
    final weightUnit = isMetric ? AppStrings.unitKg : AppStrings.unitLb;

    return Row(
      children: [
        Expanded(
          child: _InputCard(
            label: AppStrings.labelHeight,
            isDark: isDark,
            child: _buildNumericField(
              controller: _heightController,
              unit: heightUnit,
              isDark: isDark,
              theme: theme,
              onChanged: (val) {
                final parsed = double.tryParse(val);
                if (parsed != null) setState(() => _height = parsed);
              },
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: _InputCard(
            label: AppStrings.labelWeight,
            isDark: isDark,
            child: _buildNumericField(
              controller: _weightController,
              unit: weightUnit,
              isDark: isDark,
              theme: theme,
              onChanged: (val) {
                final parsed = double.tryParse(val);
                if (parsed != null) setState(() => _weight = parsed);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericField({
    required TextEditingController controller,
    required String unit,
    required bool isDark,
    required ThemeData theme,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintStyle: TextStyle(
                color: isDark
                    ? AppColors.darkOnSurfaceTertiary
                    : AppColors.lightOnSurfaceTertiary,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            unit,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkOnSurfaceTertiary
                  : AppColors.lightOnSurfaceTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeSection(ThemeData theme, bool isDark) {
    return _InputCard(
      label: AppStrings.labelAge,
      isDark: isDark,
      child: SizedBox(
        width: 120,
        child: TextField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            hintText: '25',
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.darkOnSurfaceTertiary
                  : AppColors.lightOnSurfaceTertiary,
            ),
            suffixText: 'years',
            suffixStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkOnSurfaceTertiary
                  : AppColors.lightOnSurfaceTertiary,
            ),
          ),
          onChanged: (val) {
            final parsed = int.tryParse(val);
            if (parsed != null) setState(() => _age = parsed);
          },
        ),
      ),
    );
  }

  Widget _buildCalculateButton(ThemeData theme, bool isDark) {
    return ScaleTransition(
      scale: _buttonScale,
      child: GestureDetector(
        onTapDown: (_) => _buttonAnimController.forward(),
        onTapUp: (_) {
          _buttonAnimController.reverse();
          _onCalculate();
        },
        onTapCancel: () => _buttonAnimController.reverse(),
        child: Container(
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius:
                BorderRadius.circular(AppDimensions.buttonBorderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            AppStrings.btnCalculate,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Unit pill for segmented control
// ---------------------------------------------------------------------------

class _UnitPill extends StatelessWidget {
  const _UnitPill({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm + 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppColors.darkOnSurfaceSecondary
                    : AppColors.lightOnSurfaceSecondary),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gender pill button - minimal, elegant
// ---------------------------------------------------------------------------

class _GenderPill extends StatelessWidget {
  const _GenderPill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : (isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.5)
                : (isDark ? AppColors.darkOutline : AppColors.lightOutline),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.darkOnSurfaceSecondary
                      : AppColors.lightOnSurfaceSecondary),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.darkOnSurfaceSecondary
                        : AppColors.lightOnSurfaceSecondary),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Input card - dark surface card for input groups
// ---------------------------------------------------------------------------

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.label,
    required this.isDark,
    required this.child,
  });

  final String label;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark
                  ? AppColors.darkOnSurfaceTertiary
                  : AppColors.lightOnSurfaceTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          child,
        ],
      ),
    );
  }
}
