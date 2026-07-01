import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';

/// 하단 고정 액션 바.
class CardDetailBottomActionBar extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onViewMap;
  final VoidCallback? onObserveMore;
  final VoidCallback? onToggleFavorite;

  const CardDetailBottomActionBar({
    super.key,
    this.isFavorite = false,
    this.onViewMap,
    this.onObserveMore,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: AppSpacing.screenPadding + MediaQuery.paddingOf(context).bottom,
        top: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
        boxShadow: AppShadows.soft,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildSecondaryButton(
              icon: Icons.map,
              label: '지도 보기',
              onTap: onViewMap,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: _buildPrimaryButton(
                icon: Icons.camera_alt,
                label: '더 관찰하기',
                onTap: onObserveMore,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _buildSecondaryButton(
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              label: '좋아요',
              iconColor: isFavorite ? AppColors.error : null,
              onTap: onToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: AppShadows.button,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.textInverse),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: AppTextStyles.button),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: iconColor ?? AppColors.primary),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.captionMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
