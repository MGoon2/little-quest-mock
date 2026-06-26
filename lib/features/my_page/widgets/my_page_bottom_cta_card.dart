import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';

/// 하단 CTA 카드.
class MyPageBottomCtaCard extends StatelessWidget {
  final VoidCallback? onTap;

  const MyPageBottomCtaCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LqColors.softGreen, LqColors.cream],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '기록할수록 더 가까워져요!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: LqColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '자연과 함께하는 나만의 모험',
                  style: TextStyle(
                    fontSize: 13,
                    color: LqColors.textSubtle,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: LqColors.primaryGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '관찰하러 가기',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: LqColors.lightGreen,
              shape: BoxShape.circle,
              border: Border.all(color: LqColors.border),
            ),
            child: const Icon(
              Icons.backpack,
              size: 40,
              color: LqColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
