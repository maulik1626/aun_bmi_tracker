import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';
import 'package:aun_bmi_tracker/core/constants/app_strings.dart';
import 'package:aun_bmi_tracker/core/widgets/banner_ad_widget.dart';
import 'package:aun_bmi_tracker/features/calculator/data/models/bmi_log_model.dart';
import 'package:aun_bmi_tracker/features/history/presentation/providers/history_provider.dart';
import 'package:aun_bmi_tracker/features/profiles/presentation/providers/profile_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfile = ref.watch(activeProfileProvider);
    final profileId = activeProfile?.id ?? 1;
    final filteredAsync = ref.watch(filteredHistoryProvider(profileId));
    final currentFilter = ref.watch(historyFilterProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
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
                AppStrings.historyTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // ---- Filter pills ----
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: _FilterRow(
                currentFilter: currentFilter,
                isDark: isDark,
                onFilterChanged: (filter) {
                  ref.read(historyFilterProvider.notifier).state = filter;
                },
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            // ---- Chart + List ----
            Expanded(
              child: filteredAsync.when(
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (logs) {
                  if (logs.isEmpty) {
                    return _EmptyState(isDark: isDark);
                  }

                  return Column(
                    children: [
                      // ---- Line chart ----
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.screenPaddingH,
                        ),
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.only(
                            top: AppDimensions.spacingLg,
                            right: AppDimensions.spacingMd,
                            bottom: AppDimensions.spacingSm,
                          ),
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
                          child: _BmiLineChart(logs: logs, isDark: isDark),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXl),

                      // ---- Log list ----
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPaddingH,
                          ),
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppDimensions.spacingSm),
                              child: _LogTile(
                                  log: logs[index], isDark: isDark),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ---- Banner ad ----
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter row - minimal pill-shaped buttons
// ---------------------------------------------------------------------------

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.currentFilter,
    required this.isDark,
    required this.onFilterChanged,
  });

  final HistoryFilter currentFilter;
  final bool isDark;
  final ValueChanged<HistoryFilter> onFilterChanged;

  static const _labels = {
    HistoryFilter.week: '1W',
    HistoryFilter.month: '1M',
    HistoryFilter.threeMonths: '3M',
    HistoryFilter.all: 'All',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: HistoryFilter.values.map((filter) {
          final isSelected = filter == currentFilter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm + 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  _labels[filter]!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkOnSurfaceSecondary
                            : AppColors.lightOnSurfaceSecondary),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timeline_rounded,
                size: 36,
                color: isDark
                    ? AppColors.darkOnSurfaceTertiary
                    : AppColors.lightOnSurfaceTertiary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            Text(
              'No records yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkOnSurfaceSecondary
                    : AppColors.lightOnSurfaceSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Calculate your first BMI to start\ntracking your progress',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkOnSurfaceTertiary
                    : AppColors.lightOnSurfaceTertiary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Line chart - premium with gradient fill and smooth curves
// ---------------------------------------------------------------------------

class _BmiLineChart extends StatelessWidget {
  const _BmiLineChart({required this.logs, required this.isDark});

  final List<BmiLogModel> logs;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final sorted = List<BmiLogModel>.from(logs)
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final spots = sorted.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.bmi);
    }).toList();

    final gridColor = isDark
        ? AppColors.darkOutline.withValues(alpha: 0.3)
        : AppColors.lightOutline.withValues(alpha: 0.5);

    final labelColor = isDark
        ? AppColors.darkOnSurfaceTertiary
        : AppColors.lightOnSurfaceTertiary;

    return LineChart(
      LineChartData(
        minY: 10,
        maxY: 45,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: gridColor,
              strokeWidth: 0.5,
              dashArray: [4, 4],
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: 10,
              getTitlesWidget: (value, meta) {
                if (value == 10 || value == 45) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: labelColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: max(1, (sorted.length / 5).ceilToDouble()),
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= sorted.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat('d MMM').format(sorted[idx].recordedAt),
                    style: TextStyle(
                      fontSize: 9,
                      color: labelColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppColors.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3.5,
                  color: AppColors.bmiColor(spot.y),
                  strokeWidth: 2,
                  strokeColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: AppDimensions.radiusMd,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  spot.y.toStringAsFixed(1),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                );
              }).toList();
            },
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, idx) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: AppColors.primary,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

// Helper to avoid import
double max(double a, double b) => a > b ? a : b;

// ---------------------------------------------------------------------------
// Log tile - clean card with category dot
// ---------------------------------------------------------------------------

class _LogTile extends StatelessWidget {
  const _LogTile({required this.log, required this.isDark});

  final BmiLogModel log;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.bmiColor(log.bmi);
    final dateStr =
        DateFormat('MMM d, yyyy').format(log.recordedAt);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingLg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Category dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingLg),

          // BMI value
          Text(
            log.bmi.toStringAsFixed(1),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),

          // Category
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              log.category[0].toUpperCase() + log.category.substring(1),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const Spacer(),

          // Date and weight
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateStr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkOnSurfaceSecondary
                      : AppColors.lightOnSurfaceSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${log.weightKg.toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkOnSurfaceTertiary
                      : AppColors.lightOnSurfaceTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
