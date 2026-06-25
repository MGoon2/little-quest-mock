import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_text_styles.dart';

/// Holo 등급 배지.
class HoloBadge extends StatelessWidget {
  final String label;

  const HoloBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryLight, AppColors.primary],
        ),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.md),
          topRight: const Radius.circular(AppRadius.md),
          bottomRight: const Radius.circular(AppRadius.md),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 14,
            color: AppColors.textInverse,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: AppColors.textInverse),
          ),
        ],
      ),
    );
  }
}
