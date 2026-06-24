import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

/// 둥근 Floating Bottom Navigation Bar.
class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: AppSpacing.lg,
        top: AppSpacing.sm,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.style_outlined), label: '카드'),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_outlined),
                label: '퀘스트',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '지도'),
            ],
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.backgroundElevated,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textTertiary,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
