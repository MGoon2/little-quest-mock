import 'package:flutter/material.dart';

import 'package:little_quest/features/quest_detail/data/models/quest_detail_data.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 퀘스트 미션 row.
class QuestMissionRow extends StatelessWidget {
  final QuestMissionItem mission;
  final VoidCallback? onTap;

  const QuestMissionRow({super.key, required this.mission, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: mission.completed
                    ? LqColors.primaryGreen
                    : LqColors.cream,
                shape: BoxShape.circle,
                border: mission.completed
                    ? null
                    : Border.all(color: LqColors.border),
              ),
              child: Icon(
                mission.type.icon,
                size: 22,
                color: mission.completed ? Colors.white : LqColors.mutedGreen,
              ),
            ),
            const SizedBox(width: 12),
            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: mission.completed
                          ? LqColors.textDark
                          : LqColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: LqColors.textSubtle,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 보상 + 상태
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.eco,
                      size: 14,
                      color: LqColors.primaryGreen,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+${mission.rewardPoint}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: LqColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: mission.completed
                        ? LqColors.primaryGreen
                        : LqColors.cream,
                    shape: BoxShape.circle,
                    border: mission.completed
                        ? null
                        : Border.all(
                            color: LqColors.border,
                            style: BorderStyle.solid,
                          ),
                  ),
                  child: mission.completed
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : const Icon(
                          Icons.circle_outlined,
                          size: 14,
                          color: LqColors.textSubtle,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
