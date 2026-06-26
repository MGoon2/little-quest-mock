import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/my_page_data.dart';

/// 주간 탐험 요약 카드.
class WeeklyExplorationSummaryCard extends StatelessWidget {
  final MyPageData data;

  const WeeklyExplorationSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              const Icon(Icons.spa, size: 16, color: LqColors.primaryGreen),
              const SizedBox(width: 6),
              const Text(
                '주간 탐험 요약',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: LqColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: '이번 주 발견',
                  value: '${data.weeklyDiscoveryCount}종',
                  icon: Icons.local_florist,
                  iconColor: LqColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryTile(
                  label: '이번 주 EXP',
                  value: '+${data.weeklyExp}',
                  icon: Icons.star,
                  iconColor: LqColors.yellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LqColors.cream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: LqColors.textSubtle,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: LqColors.textDark,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
        ],
      ),
    );
  }
}
