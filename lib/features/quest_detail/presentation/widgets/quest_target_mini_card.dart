import 'package:flutter/material.dart';

import 'package:little_quest/features/quest_detail/data/models/quest_detail_data.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 퀘스트 대상 미니 카드.
class QuestTargetMiniCard extends StatelessWidget {
  final QuestTargetItem item;
  final VoidCallback? onTap;

  const QuestTargetMiniCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 112,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: LqColors.cardCream,
          borderRadius: BorderRadius.circular(16),
          border: item.completed
              ? null
              : Border.all(color: LqColors.mutedGreen.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: LqColors.deepGreen.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상태 아이콘
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: item.completed ? LqColors.primaryGreen : LqColors.cream,
                shape: BoxShape.circle,
                border: item.completed
                    ? null
                    : Border.all(
                        color: LqColors.mutedGreen,
                        style: BorderStyle.solid,
                      ),
              ),
              child: item.completed
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : const Icon(
                      Icons.circle_outlined,
                      size: 14,
                      color: LqColors.mutedGreen,
                    ),
            ),
            const SizedBox(height: 8),
            // 이미지 placeholder
            Container(
              height: 68,
              decoration: BoxDecoration(
                color: LqColors.lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_florist,
                  size: 32,
                  color: LqColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // 이름
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: LqColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // 상태/날짜
            Text(
              item.completed
                  ? '발견 완료 ${item.completedAt ?? ''}'
                  : '발견하기 ${item.currentCount}/${item.requiredCount}',
              style: TextStyle(
                fontSize: 11,
                color: item.completed
                    ? LqColors.primaryGreen
                    : LqColors.textSubtle,
                height: 1.4,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
