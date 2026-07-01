import 'package:flutter/material.dart';

import 'package:little_quest/features/quest_detail/data/models/quest_detail_data.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 퀘스트 진행 상황 카드.
class QuestProgressCard extends StatelessWidget {
  final QuestDetailData quest;

  const QuestProgressCard({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LqColors.border),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 원형 progress
          SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: quest.progressRatio,
                  backgroundColor: LqColors.disabled,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    LqColors.primaryGreen,
                  ),
                  strokeWidth: 10,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${quest.completedCount}/${quest.requiredCount}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: LqColors.textDark,
                        ),
                      ),
                      const Text(
                        '종 발견',
                        style: TextStyle(
                          fontSize: 11,
                          color: LqColors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 오른쪽 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '나의 진행 상황',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: LqColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${quest.requiredCount}종 중 ${quest.completedCount}종을 발견했어요!',
                  style: const TextStyle(
                    fontSize: 13,
                    color: LqColors.textSubtle,
                  ),
                ),
                const SizedBox(height: 12),
                // progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: quest.progressRatio,
                    backgroundColor: LqColors.disabled,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      LqColors.primaryGreen,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${quest.progressPercent}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: LqColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 보상 박스
                _buildRewardBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: LqColors.yellow.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 16, color: LqColors.gold),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '완료 보상 | ${quest.rewardLabel}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: LqColors.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.style, size: 18, color: LqColors.gold),
        ],
      ),
    );
  }
}
