import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/quest_detail_data.dart';
import 'quest_mission_row.dart';

/// 퀘스트 미션 카드.
class QuestMissionCard extends StatelessWidget {
  final List<QuestMissionItem> missions;

  const QuestMissionCard({super.key, required this.missions});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '퀘스트 미션',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: LqColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          ...missions.asMap().entries.map((entry) {
            final index = entry.key;
            final mission = entry.value;
            return Column(
              children: [
                QuestMissionRow(
                  mission: mission,
                  onTap: () {
                    // TODO: mission action
                  },
                ),
                if (index < missions.length - 1)
                  const Divider(
                    color: LqColors.border,
                    height: 1,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
