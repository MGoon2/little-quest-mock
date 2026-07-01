import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'package:little_quest/app/theme/app_theme.dart';

class LittleQuestApp extends StatelessWidget {
  const LittleQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
