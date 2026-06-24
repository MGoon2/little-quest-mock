import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'bottom_navigation.dart';

/// 앱 전역에서 사용하는 Scaffold.
///
/// 크림색 배경, 안전영역, 하단 네비게이션을 통일감 있게 감싼다.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final int currentIndex;
  final ValueChanged<int>? onNavigationTap;
  final bool showBottomNav;
  final bool extendBody;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.currentIndex = 0,
    this.onNavigationTap,
    this.showBottomNav = true,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      body: SafeArea(
        top: false,
        bottom: !showBottomNav,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: showBottomNav && onNavigationTap != null
          ? BottomNavigation(
              currentIndex: currentIndex,
              onTap: onNavigationTap!,
            )
          : null,
    );
  }
}
