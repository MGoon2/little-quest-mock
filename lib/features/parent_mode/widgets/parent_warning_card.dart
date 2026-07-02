import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 부모 모드 주의 안내 카드.
class ParentWarningCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;

  const ParentWarningCard({
    super.key,
    required this.title,
    this.description,
    this.icon = Icons.warning_amber_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LqColors.warning,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFFF3DEAF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFA36D18), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: LqColors.textDark,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      height: 1.45,
                      color: LqColors.textSubtle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
