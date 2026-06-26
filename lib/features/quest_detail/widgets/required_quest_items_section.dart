import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/quest_detail_data.dart';
import 'quest_target_mini_card.dart';

/// 발견해야 할 퀘스트 대상 섹션.
class RequiredQuestItemsSection extends StatelessWidget {
  final List<QuestTargetItem> items;
  final VoidCallback? onSeeAll;

  const RequiredQuestItemsSection({
    super.key,
    required this.items,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '발견해야 할 식물',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: LqColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: const Row(
                  children: [
                    Text(
                      '모두 보기',
                      style: TextStyle(
                        fontSize: 12,
                        color: LqColors.textSubtle,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: LqColors.textSubtle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (_, index) => QuestTargetMiniCard(
              item: items[index],
              onTap: () {
                // TODO: target detail or card detail
              },
            ),
          ),
        ),
      ],
    );
  }
}
