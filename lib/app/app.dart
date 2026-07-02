import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'package:little_quest/app/theme/app_theme.dart';

class LittleQuestApp extends StatelessWidget {
  const LittleQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    const routeOverride = String.fromEnvironment('LQ_INITIAL_ROUTE');
    final defaultRouteName =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    final initialRoute = routeOverride.isNotEmpty
        ? routeOverride
        : defaultRouteName == Navigator.defaultRouteName
        ? AppRouter.initialRoute
        : defaultRouteName;

    return MaterialApp(
      title: 'Little Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: initialRoute,
      routes: AppRouter.routes,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
