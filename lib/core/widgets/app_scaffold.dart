import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_strings.dart';

/// Shell widget that wraps pages with a premium translucent bottom navigation bar.
///
/// The navigation bar uses a backdrop blur effect for a refined, modern feel.
/// Minimal icons, subtle active states, no visual noise.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.82)
                  : AppColors.lightSurface.withValues(alpha: 0.88),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                  width: 0.5,
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: isDark
                        ? AppColors.darkOnSurfaceTertiary
                        : AppColors.lightOnSurfaceTertiary,
                  ),
                  selectedIcon: const Icon(
                    Icons.dashboard_rounded,
                    color: AppColors.primary,
                  ),
                  label: AppStrings.navCalculator,
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.timeline_outlined,
                    color: isDark
                        ? AppColors.darkOnSurfaceTertiary
                        : AppColors.lightOnSurfaceTertiary,
                  ),
                  selectedIcon: const Icon(
                    Icons.timeline_rounded,
                    color: AppColors.primary,
                  ),
                  label: AppStrings.navHistory,
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.person_outline_rounded,
                    color: isDark
                        ? AppColors.darkOnSurfaceTertiary
                        : AppColors.lightOnSurfaceTertiary,
                  ),
                  selectedIcon: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                  ),
                  label: AppStrings.navProfiles,
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.auto_awesome_outlined,
                    color: isDark
                        ? AppColors.darkOnSurfaceTertiary
                        : AppColors.lightOnSurfaceTertiary,
                  ),
                  selectedIcon: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                  ),
                  label: AppStrings.navTips,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
