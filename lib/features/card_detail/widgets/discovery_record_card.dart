import 'package:flutter/material.dart';

import '../models/card_detail_data.dart';
import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';

/// 발견 기록 영역.
class DiscoveryRecordCard extends StatelessWidget {
  final DiscoveryRecord record;
  final VoidCallback? onTap;

  const DiscoveryRecordCard({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                Icon(Icons.event_note, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Text('발견 기록', style: AppTextStyles.heading),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: '발견일',
              value: _formatDateTime(record.discoveredAt),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow(
              icon: Icons.location_on,
              label: '발견 장소',
              value: record.locationName,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow(
              icon: Icons.edit_note,
              label: '메모',
              value: record.memo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primaryLight),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    final weekday = ['일', '월', '화', '수', '목', '금', '토'][date.weekday % 7];
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ($weekday) '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
