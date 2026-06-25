import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_shadows.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_text_styles.dart';
import '../models/card_detail_data.dart';

/// 관찰 기록 영역.
class ObservationHistoryCard extends StatelessWidget {
  final List<ObservationRecord> observations;
  final VoidCallback? onAddObservation;

  const ObservationHistoryCard({
    super.key,
    required this.observations,
    this.onAddObservation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco, size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text('관찰 기록', style: AppTextStyles.heading),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: observations.length + 1,
              separatorBuilder: (_, index) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                if (index == observations.length) {
                  return _buildAddCard();
                }
                return _buildObservationCard(observations[index]);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, size: 16, color: AppColors.accentYellow),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '더 많은 계절과 장소에서 관찰하면 Holo 등급이 업그레이드돼요!',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationCard(ObservationRecord observation) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: _seasonalColor(observation.observedAt),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Center(
              child: Icon(Icons.photo, size: 28, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _formatDate(observation.observedAt),
            style: AppTextStyles.captionMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            observation.locationName,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          Expanded(
            child: Text(
              observation.memo,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: onAddObservation,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 28, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '더 관찰하기',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _seasonalColor(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) {
      return AppColors.leafLight;
    } else if (month >= 6 && month <= 8) {
      return const Color(0xFFE6F4EA);
    } else if (month >= 9 && month <= 11) {
      return AppColors.accentYellowLight;
    } else {
      return const Color(0xFFE8E8E8);
    }
  }

  String _formatDate(DateTime date) {
    final weekday = ['일', '월', '화', '수', '목', '금', '토'][date.weekday % 7];
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ($weekday)';
  }
}
