import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';

/// 섹션 제목 + "전체보기" 액션.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionLabel!,
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
