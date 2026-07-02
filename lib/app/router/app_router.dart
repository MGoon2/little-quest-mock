import 'package:flutter/material.dart';

import 'package:little_quest/models/discovery_card_item.dart';
import 'package:little_quest/features/account_verification/presentation/pages/account_verification_screen_method.dart';
import 'package:little_quest/features/account_verification/presentation/pages/account_verification_screen_password.dart';
import 'package:little_quest/features/account_verification/presentation/pages/account_verification_screen_social.dart';
import 'package:little_quest/features/parent_mode/parent_account_security_page.dart';
import 'package:little_quest/features/parent_mode/parent_child_info_page.dart';
import 'package:little_quest/features/parent_mode/parent_child_list_page.dart';
import 'package:little_quest/features/parent_mode/parent_data_management_page.dart';
import 'package:little_quest/features/parent_mode/parent_discovery_record_page.dart';
import 'package:little_quest/features/parent_mode/parent_guardian_info_page.dart';
import 'package:little_quest/features/parent_mode/parent_home_page.dart';
import 'package:little_quest/features/parent_mode/parent_location_record_page.dart';
import 'package:little_quest/features/parent_mode/parent_mode_entry_page.dart';
import 'package:little_quest/features/parent_mode/parent_privacy_consent_page.dart';
import 'package:little_quest/features/parent_mode/parent_settings_page.dart';
import 'package:little_quest/features/parent_mode/parent_subscription_page.dart';
import 'package:little_quest/features/parent_mode/parent_verification_page.dart';
import 'package:little_quest/features/signup/presentation/pages/email_signup_page.dart';
import 'package:little_quest/features/signup/presentation/pages/signup_method_page.dart';
import 'package:little_quest/screens/card_detail_screen.dart';
import 'package:little_quest/screens/discovery_card_detail_screen.dart';
import 'package:little_quest/screens/discovery_card_screen.dart';
import 'package:little_quest/screens/home_screen.dart';
import 'package:little_quest/screens/login_screen.dart';
import 'package:little_quest/screens/map_screen.dart';
import 'package:little_quest/screens/mode_selection_screen.dart';
import 'package:little_quest/features/my_page/presentation/pages/my_page_screen.dart';
import 'package:little_quest/features/profile_edit/presentation/pages/profile_edit_screen.dart';
import 'package:little_quest/features/quest_detail/presentation/pages/quest_detail_screen.dart';
import 'package:little_quest/screens/welcome_screen.dart';

abstract final class AppRouter {
  static const initialRoute = '/';

  static Map<String, WidgetBuilder> get routes => {
    '/': (context) => const WelcomeScreen(),
    '/login': (context) => const LoginScreen(),
    '/mode-selection': (context) => const ModeSelectionScreen(),
    '/signup': (context) => const SignupMethodPage(),
    '/signup/email': (context) => const EmailSignupPage(),
    '/home': (context) => const HomeScreen(),
    '/discovery-cards': (context) => const DiscoveryCardScreen(),
    '/map': (context) => const MapScreen(),
    '/quest-detail': (context) => const QuestDetailScreen(),
    '/my-page': (context) => const MyPageScreen(),
    '/account-verification': (context) => const AccountVerificationScreen(),
    '/account-verification-social': (context) =>
        const AccountVerificationScreenSocial(),
    '/account-verification-method': (context) =>
        const AccountVerificationScreenMethod(),
    '/profile-edit': (context) => const ProfileEditScreen(),
    '/card-detail': (context) => const DiscoveryCardDetailScreen(),
    '/parent/entry': (context) => const ParentModeEntryPage(),
    '/parent/verify': (context) => const ParentVerificationPage(),
    '/parent/home': (context) => const ParentHomePage(),
    '/parent/children': (context) => const ParentChildListPage(),
    '/parent/guardian-info': (context) => const ParentGuardianInfoPage(),
    '/parent/account-security': (context) => const ParentAccountSecurityPage(),
    '/parent/privacy-consent': (context) => const ParentPrivacyConsentPage(),
    '/parent/records': (context) => const ParentDiscoveryRecordPage(),
    '/parent/location': (context) => const ParentLocationRecordPage(),
    '/parent/subscription': (context) => const ParentSubscriptionPage(),
    '/parent/data': (context) => const ParentDataManagementPage(),
    '/parent/settings': (context) => const ParentSettingsPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;
    const childRoutePrefix = '/parent/children/';
    if (routeName != null && routeName.startsWith(childRoutePrefix)) {
      final childId = Uri.decodeComponent(
        routeName.substring(childRoutePrefix.length),
      );
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ParentChildInfoPage(childId: childId),
      );
    }

    if (settings.name == '/card-detail-legacy') {
      final item = settings.arguments as DiscoveryCardItem;
      return MaterialPageRoute(
        builder: (context) => CardDetailScreen(item: item),
      );
    }
    return null;
  }
}
