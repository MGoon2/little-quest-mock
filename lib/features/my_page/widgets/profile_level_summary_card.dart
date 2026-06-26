import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/my_page_data.dart';

/// 프로필 및 등급 통합 카드.
class ProfileLevelSummaryCard extends StatelessWidget {
  final MyPageData data;

  const ProfileLevelSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 메달 아이콘
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: LqColors.softGreen,
              shape: BoxShape.circle,
              border: Border.all(color: LqColors.yellow, width: 2),
            ),
            child: const Icon(
              Icons.eco,
              size: 48,
              color: LqColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 16),
          // 오른쪽 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '안녕, ${data.greetingName}!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LqColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.spa,
                      size: 16,
                      color: LqColors.primaryGreen,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '자연과 함께하는 멋진 하루예요',
                  style: TextStyle(
                    fontSize: 13,
                    color: LqColors.textSubtle,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: LqColors.primaryGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '내 등급',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            data.levelName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.spa,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: data.progressRatio,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '다음 등급까지 ${data.remainingExp} EXP',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
