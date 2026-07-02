import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';
import 'package:little_quest/features/parent_mode/models/parent_menu_item.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_bottom_navigation.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_child_profile_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_menu_grid.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(
        title: '부모 모드',
        showBackButton: false,
        showNotification: true,
      ),
      bottomNavigationBar: const ParentBottomNavigation(currentIndex: 1),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ParentChildProfileCard(
                child: ParentModeFixture.childSummary,
                onViewProfile: () {
                  Navigator.of(context).pushNamed('/parent/children');
                },
              ),
              const SizedBox(height: 18),
              ParentMenuGrid(
                items: ParentModeFixture.menuItems,
                onItemTap: (type) => _openMenu(context, type),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMenu(BuildContext context, ParentMenuType type) {
    switch (type) {
      case ParentMenuType.privacyConsent:
        Navigator.of(context).pushNamed('/parent/privacy-consent');
      case ParentMenuType.discoveryRecord:
        Navigator.of(context).pushNamed('/parent/records');
      case ParentMenuType.locationRecord:
        Navigator.of(context).pushNamed('/parent/location');
      case ParentMenuType.subscription:
        Navigator.of(context).pushNamed('/parent/subscription');
      case ParentMenuType.notification:
      case ParentMenuType.settings:
        Navigator.of(context).pushNamed('/parent/settings');
      case ParentMenuType.dataManagement:
        Navigator.of(context).pushNamed('/parent/data');
    }
  }
}
