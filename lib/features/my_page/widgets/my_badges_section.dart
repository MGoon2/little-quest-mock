import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/my_page_data.dart';

/// 나의 배지 섹션.
class MyBadgesSection extends StatelessWidget {
  final List<BadgeItem> badges;
  final VoidCallback? onSeeAll;

  const MyBadgesSection({
    super.key,
    required this.badges,
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
                '나의 배지',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: badges.map((badge) => _BadgeItem(badge: badge)).toList(),
          ),
        ),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final BadgeItem badge;

  const _BadgeItem({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: badge.unlocked ? LqColors.yellow.withValues(alpha: 0.2) : LqColors.cream,
            shape: BoxShape.circle,
            border: Border.all(
              color: badge.unlocked ? LqColors.yellow : LqColors.border,
              width: 2,
            ),
          ),
          child: Icon(
            badge.icon,
            size: 28,
            color: badge.unlocked ? LqColors.yellow : LqColors.textSubtle,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          badge.label,
          style: TextStyle(
            fontSize: 12,
            color: badge.unlocked ? LqColors.textDark : LqColors.textSubtle,
          ),
        ),
      ],
    );
  }
}
