import 'package:flutter/material.dart';

import 'models/discovery_card_item.dart';
import 'screens/card_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const LittleQuestApp());
}

class LittleQuestApp extends StatelessWidget {
  const LittleQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/card-detail') {
          final item = settings.arguments as DiscoveryCardItem;
          return MaterialPageRoute(
            builder: (context) => CardDetailScreen(item: item),
          );
        }
        return null;
      },
    );
  }
}
