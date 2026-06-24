import 'package:flutter/material.dart';

import '../models/discovery_card.dart';
import '../models/discovery_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// 발견 카드 도감의 미니 카드 컴포넌트.
class DiscoveryMiniCard extends StatelessWidget {
  final DiscoveryCard card;
  final VoidCallback? onTap;

  const DiscoveryMiniCard({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Container(
              height: 84,
              decoration: BoxDecoration(
                color: card.category.backgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Icon(
                  card.category.icon,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // 이름
            Text(
              card.name,
              style: AppTextStyles.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            // 카테고리 chip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: card.category.backgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                card.category.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // 별점
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < card.rating ? Icons.star : Icons.star_border,
                  size: 14,
                  color: AppColors.accentYellow,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // 발견일
            Text(
              _formatDate(card.discoveredAt),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
