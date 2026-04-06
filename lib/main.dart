import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aun_bmi_tracker/core/constants/app_strings.dart';
import 'package:aun_bmi_tracker/core/router/app_router.dart';
import 'package:aun_bmi_tracker/core/services/ad_service.dart';
import 'package:aun_bmi_tracker/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.instance.initialize();
  runApp(const ProviderScope(child: AunBmiTrackerApp()));
}

class AunBmiTrackerApp extends StatelessWidget {
  const AunBmiTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: goRouter,
    );
  }
}
