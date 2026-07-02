import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';
import 'package:little_quest/features/parent_mode/models/parent_subscription_summary.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_status_badge.dart';

/// 구독 상태 카드.
class ParentSubscriptionCard extends StatelessWidget {
  final ParentSubscriptionSummary summary;

  const ParentSubscriptionCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return ParentSectionCard(
      backgroundColor: LqColors.softGreen,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        summary.planName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: LqColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ParentStatusBadge(label: summary.statusLabel),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  summary.billingCycleLabel,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    color: LqColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '다음 결제일: ${summary.nextBillingDateLabel}',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: LqColors.textSubtle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: LqColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: Image.asset(
                'assets/images/account_verification/explorer_verification_header.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
