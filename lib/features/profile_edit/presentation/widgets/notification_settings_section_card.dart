import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 알림 설정 섹션 카드.
class NotificationSettingsSectionCard extends StatelessWidget {
  const NotificationSettingsSectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LqColors.border),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // TODO: notification settings page
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: LqColors.softGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                size: 20,
                color: LqColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                '알림 설정 관리',
                style: TextStyle(fontSize: 14, color: LqColors.textDark),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: LqColors.textSubtle,
            ),
          ],
        ),
      ),
    );
  }
}
