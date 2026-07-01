import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 퀘스트 보상 안내 박스.
class QuestRewardNotice extends StatelessWidget {
  const QuestRewardNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: LqColors.softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb,
              size: 18,
              color: LqColors.yellow,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '퀘스트를 완료하면 특별한 보상을 받을 수 있어요!',
              style: TextStyle(
                fontSize: 13,
                color: LqColors.textDark,
                height: 1.4,
              ),
            ),
          ),
          const Icon(Icons.grass, size: 28, color: LqColors.mutedGreen),
        ],
      ),
    );
  }
}
