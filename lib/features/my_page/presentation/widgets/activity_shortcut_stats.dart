import 'package:flutter/material.dart';

import 'package:little_quest/features/my_page/data/models/my_page_data.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 활동 shortcut stats.
class ActivityShortcutStats extends StatelessWidget {
  final MyPageData data;
  final VoidCallback? onCards;
  final VoidCallback? onObservations;
  final VoidCallback? onQuests;
  final VoidCallback? onLikes;

  const ActivityShortcutStats({
    super.key,
    required this.data,
    this.onCards,
    this.onObservations,
    this.onQuests,
    this.onLikes,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
        icon: Icons.style,
        label: '내 카드',
        value: data.cardCount,
        onTap: onCards,
      ),
      _StatItem(
        icon: Icons.edit_note,
        label: '관찰 기록',
        value: data.observationCount,
        onTap: onObservations,
      ),
      _StatItem(
        icon: Icons.checklist,
        label: '퀘스트',
        value: data.questCount,
        onTap: onQuests,
      ),
      _StatItem(
        icon: Icons.favorite,
        label: '좋아요',
        value: data.likeCount,
        onTap: onLikes,
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: item.onTap,
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: LqColors.softGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.icon,
                            size: 22,
                            color: LqColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: LqColors.textSubtle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.value}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: LqColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (index < items.length - 1)
                  Container(width: 1, height: 40, color: LqColors.border),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final int value;
  final VoidCallback? onTap;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });
}
