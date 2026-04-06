import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';
import 'package:aun_bmi_tracker/core/constants/app_strings.dart';
import 'package:aun_bmi_tracker/core/widgets/banner_ad_widget.dart';
import 'package:aun_bmi_tracker/features/calculator/domain/entities/bmi_category.dart';
import 'package:aun_bmi_tracker/features/calculator/presentation/providers/bmi_provider.dart';

class TipsScreen extends ConsumerWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bmiState = ref.watch(bmiNotifierProvider);
    final category = bmiState.valueOrNull?.category ?? BmiCategory.normal;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Tab icon/color mapping
    final tabData = [
      _TabInfo('Diet', Icons.eco_rounded, const Color(0xFF66BB6A)),
      _TabInfo('Exercise', Icons.fitness_center_rounded, const Color(0xFF42A5F5)),
      _TabInfo('Lifestyle', Icons.self_improvement_rounded, const Color(0xFFE0A861)),
      _TabInfo('Sleep', Icons.bedtime_rounded, const Color(0xFF7E57C2)),
    ];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : null,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Header ----
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.screenPaddingH,
                  right: AppDimensions.screenPaddingH,
                  top: AppDimensions.spacingXl,
                  bottom: AppDimensions.spacingLg,
                ),
                child: Text(
                  AppStrings.tipsTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              // ---- Tab bar - clean, minimal ----
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkOutline
                          : AppColors.lightOutline,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSm + 2),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark
                        ? AppColors.darkOnSurfaceSecondary
                        : AppColors.lightOnSurfaceSecondary,
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelPadding: EdgeInsets.zero,
                    tabs: tabData
                        .map((t) => Tab(
                              height: 36,
                              child: Text(t.label),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              // ---- Tab content ----
              Expanded(
                child: TabBarView(
                  children: [
                    _TipsList(
                      tips: _dietTips(category),
                      accentColor: tabData[0].color,
                      isDark: isDark,
                    ),
                    _TipsList(
                      tips: _exerciseTips(category),
                      accentColor: tabData[1].color,
                      isDark: isDark,
                    ),
                    _TipsList(
                      tips: _lifestyleTips(category),
                      accentColor: tabData[2].color,
                      isDark: isDark,
                    ),
                    _TipsList(
                      tips: _sleepTips(category),
                      accentColor: tabData[3].color,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab info helper
// ---------------------------------------------------------------------------

class _TabInfo {
  const _TabInfo(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

// ---------------------------------------------------------------------------
// Tips list with premium cards
// ---------------------------------------------------------------------------

class _TipsList extends StatelessWidget {
  const _TipsList({
    required this.tips,
    required this.accentColor,
    required this.isDark,
  });

  final List<_Tip> tips;
  final Color accentColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      itemCount: tips.length + (tips.length ~/ 3),
      itemBuilder: (context, index) {
        final adjustedIndex = index - (index ~/ 4);
        final isAd = index > 0 && index % 4 == 3;

        if (isAd) {
          return const Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spacingMd),
            child: BannerAdWidget(),
          );
        }

        if (adjustedIndex >= tips.length) {
          return const SizedBox.shrink();
        }

        final tip = tips[adjustedIndex];
        return _TipCard(
          tip: tip,
          accentColor: accentColor,
          isDark: isDark,
          index: adjustedIndex,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Tip card - elegant with subtle icon and generous padding
// ---------------------------------------------------------------------------

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.tip,
    required this.accentColor,
    required this.isDark,
    required this.index,
  });

  final _Tip tip;
  final Color accentColor;
  final bool isDark;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius:
            BorderRadius.circular(AppDimensions.cardBorderRadius),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtle icon container with category accent
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(
              tip.icon,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingLg),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Text(
                  tip.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkOnSurfaceSecondary
                        : AppColors.lightOnSurfaceSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tip model & data
// ---------------------------------------------------------------------------

class _Tip {
  const _Tip({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;
}

List<_Tip> _dietTips(BmiCategory cat) {
  final base = <_Tip>[
    const _Tip(
      title: 'Eat More Vegetables',
      body:
          'Fill half your plate with vegetables at every meal for essential vitamins and fiber.',
      icon: Icons.eco_rounded,
    ),
    const _Tip(
      title: 'Stay Hydrated',
      body:
          'Drink at least 8 glasses of water daily. Proper hydration aids metabolism and digestion.',
      icon: Icons.water_drop_rounded,
    ),
    const _Tip(
      title: 'Mindful Eating',
      body:
          'Eat slowly and without distractions to recognize fullness cues and prevent overeating.',
      icon: Icons.restaurant_rounded,
    ),
    const _Tip(
      title: 'Balanced Macros',
      body:
          'Include lean protein, healthy fats, and complex carbs in every meal for sustained energy.',
      icon: Icons.pie_chart_rounded,
    ),
  ];

  if (cat == BmiCategory.underweight) {
    base.add(const _Tip(
      title: 'Increase Calorie Intake',
      body:
          'Add calorie-dense healthy foods like nuts, avocados, and whole grains to your diet.',
      icon: Icons.add_circle_rounded,
    ));
  } else if (cat == BmiCategory.overweight || cat == BmiCategory.obese) {
    base.add(const _Tip(
      title: 'Reduce Processed Foods',
      body:
          'Limit sugar-sweetened beverages, fast food, and packaged snacks to lower calorie intake.',
      icon: Icons.no_food_rounded,
    ));
  }

  return base;
}

List<_Tip> _exerciseTips(BmiCategory cat) {
  final base = <_Tip>[
    const _Tip(
      title: 'Daily Walking',
      body:
          'Aim for 10,000 steps a day. Walking is a low-impact way to stay active and burn calories.',
      icon: Icons.directions_walk_rounded,
    ),
    const _Tip(
      title: 'Strength Training',
      body:
          'Include weight or resistance exercises 2-3 times a week to build muscle and boost metabolism.',
      icon: Icons.fitness_center_rounded,
    ),
    const _Tip(
      title: 'Stretch Regularly',
      body:
          'Stretching improves flexibility, reduces injury risk, and helps with post-workout recovery.',
      icon: Icons.accessibility_new_rounded,
    ),
    const _Tip(
      title: 'Find a Workout Buddy',
      body:
          'Exercising with a partner increases motivation and accountability.',
      icon: Icons.people_rounded,
    ),
  ];

  if (cat == BmiCategory.obese) {
    base.insert(
        0,
        const _Tip(
          title: 'Start Slow',
          body:
              'Begin with short 10-minute sessions and gradually increase intensity as your fitness improves.',
          icon: Icons.timer_rounded,
        ));
  }

  return base;
}

List<_Tip> _lifestyleTips(BmiCategory cat) {
  return const [
    _Tip(
      title: 'Manage Stress',
      body:
          'Practice meditation or deep breathing exercises to reduce cortisol, which can cause weight gain.',
      icon: Icons.self_improvement_rounded,
    ),
    _Tip(
      title: 'Regular Check-ups',
      body:
          'Visit your healthcare provider regularly to monitor BMI, blood pressure, and overall health.',
      icon: Icons.local_hospital_rounded,
    ),
    _Tip(
      title: 'Limit Alcohol',
      body:
          'Alcoholic drinks are calorie-dense and can lead to poor food choices. Moderate your intake.',
      icon: Icons.no_drinks_rounded,
    ),
    _Tip(
      title: 'Screen Time Balance',
      body:
          'Reduce sedentary screen time. Take a 5-minute break to move for every 30 minutes of sitting.',
      icon: Icons.tv_off_rounded,
    ),
  ];
}

List<_Tip> _sleepTips(BmiCategory cat) {
  return const [
    _Tip(
      title: 'Get 7-9 Hours',
      body:
          'Adequate sleep is essential for weight management. Lack of sleep increases hunger hormones.',
      icon: Icons.bedtime_rounded,
    ),
    _Tip(
      title: 'Consistent Schedule',
      body:
          'Go to bed and wake up at the same time every day, even on weekends.',
      icon: Icons.schedule_rounded,
    ),
    _Tip(
      title: 'Dark, Cool Room',
      body:
          'Keep your bedroom dark, quiet, and cool (around 18 C / 65 F) for optimal sleep quality.',
      icon: Icons.dark_mode_rounded,
    ),
    _Tip(
      title: 'No Screens Before Bed',
      body:
          'Avoid phones and laptops at least 30 minutes before sleep. Blue light disrupts melatonin production.',
      icon: Icons.phone_android_rounded,
    ),
  ];
}
