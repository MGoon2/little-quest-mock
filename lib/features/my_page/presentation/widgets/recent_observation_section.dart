import 'package:flutter/material.dart';

import 'package:little_quest/features/my_page/data/models/my_page_data.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 최근 관찰 기록 섹션.
class RecentObservationSection extends StatelessWidget {
  final List<RecentObservationItem> observations;
  final VoidCallback? onSeeAll;

  const RecentObservationSection({
    super.key,
    required this.observations,
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
                '최근 관찰 기록',
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
                      '더보기',
                      style: TextStyle(
                        fontSize: 12,
                        color: LqColors.textSubtle,
                      ),
                    ),
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
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: observations.length,
            separatorBuilder: (_, index) => const SizedBox(width: 16),
            itemBuilder: (_, index) =>
                _ObservationItem(item: observations[index]),
          ),
        ),
      ],
    );
  }
}

class _ObservationItem extends StatelessWidget {
  final RecentObservationItem item;

  const _ObservationItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: LqColors.lightGreen,
            shape: BoxShape.circle,
            border: Border.all(color: LqColors.border, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.local_florist,
              size: 32,
              color: LqColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: LqColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.observedAt,
          style: const TextStyle(fontSize: 11, color: LqColors.textSubtle),
        ),
      ],
    );
  }
}
