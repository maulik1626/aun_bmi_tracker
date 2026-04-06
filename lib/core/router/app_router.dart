import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:aun_bmi_tracker/core/widgets/app_scaffold.dart';
import 'package:aun_bmi_tracker/features/calculator/presentation/screens/home_screen.dart';
import 'package:aun_bmi_tracker/features/calculator/presentation/screens/result_screen.dart';
import 'package:aun_bmi_tracker/features/history/presentation/screens/history_screen.dart';
import 'package:aun_bmi_tracker/features/profiles/presentation/screens/profiles_screen.dart';
import 'package:aun_bmi_tracker/features/share/presentation/screens/share_screen.dart';
import 'package:aun_bmi_tracker/features/splash/presentation/screens/splash_screen.dart';
import 'package:aun_bmi_tracker/features/tips/presentation/screens/tips_screen.dart';

/// Route path constants.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String result = '/result';
  static const String history = '/history';
  static const String profiles = '/profiles';
  static const String tips = '/tips';
  static const String share = '/share';
}

/// Global navigator keys for the shell branches.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorCalculatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'calculator');
final _shellNavigatorHistoryKey =
    GlobalKey<NavigatorState>(debugLabel: 'history');
final _shellNavigatorProfilesKey =
    GlobalKey<NavigatorState>(debugLabel: 'profiles');
final _shellNavigatorTipsKey =
    GlobalKey<NavigatorState>(debugLabel: 'tips');

/// The app-level [GoRouter] configuration.
final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    // ─── Splash ────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // ─── Bottom-nav shell ──────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Calculator tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCalculatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // History tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHistoryKey,
          routes: [
            GoRoute(
              path: AppRoutes.history,
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),

        // Profiles tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfilesKey,
          routes: [
            GoRoute(
              path: AppRoutes.profiles,
              builder: (context, state) => const ProfilesScreen(),
            ),
          ],
        ),

        // Tips tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTipsKey,
          routes: [
            GoRoute(
              path: AppRoutes.tips,
              builder: (context, state) => const TipsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ─── Full-screen routes (outside bottom nav) ───────────────
    GoRoute(
      path: AppRoutes.result,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ResultScreen(),
    ),
    GoRoute(
      path: AppRoutes.share,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ShareScreen(),
    ),
  ],
);
