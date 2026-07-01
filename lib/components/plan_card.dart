import 'package:flutter/material.dart';

import '../models/plan_tier.dart';
import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';

/// 구독 플랜 카드.
class PlanCard extends StatelessWidget {
  final Plan plan;
  final bool isSelected;
  final VoidCallback? onTap;

  const PlanCard({
    super.key,
    required this.plan,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor;
    IconData icon;
    switch (plan.tier) {
      case PlanTier.free:
        accentColor = AppColors.primarySoft;
        icon = Icons.eco_outlined;
      case PlanTier.plus:
        accentColor = AppColors.accentYellowLight;
        icon = Icons.workspace_premium_outlined;
      case PlanTier.family:
        accentColor = AppColors.accentCoralLight;
        icon = Icons.family_restroom_outlined;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(plan.title, style: AppTextStyles.heading),
                      const SizedBox(width: AppSpacing.sm),
                      if (plan.isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: Text('추천', style: AppTextStyles.label),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${plan.price} / ${plan.period}',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xs,
                    children: plan.features
                        .map(
                          (feature) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(feature, style: AppTextStyles.caption),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
