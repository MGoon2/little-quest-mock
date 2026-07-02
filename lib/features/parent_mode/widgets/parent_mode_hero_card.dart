import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 부모 모드 진입 안내 일러스트 영역.
class ParentModeHeroCard extends StatelessWidget {
  const ParentModeHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '보호자와 아이가 함께 탐험 기록을 확인하는 일러스트',
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, LqColors.softGreen],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 14,
              bottom: 18,
              child: Icon(
                Icons.eco,
                size: 54,
                color: LqColors.mutedGreen.withValues(alpha: 0.62),
              ),
            ),
            Positioned(
              right: 22,
              top: 28,
              child: Icon(
                Icons.flutter_dash,
                size: 32,
                color: LqColors.yellow.withValues(alpha: 0.9),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 10,
              child: Icon(
                Icons.local_florist,
                size: 62,
                color: LqColors.mutedGreen.withValues(alpha: 0.5),
              ),
            ),
            Positioned(
              left: 24,
              bottom: 24,
              child: const _ParentGuidePlaceholder(),
            ),
            Positioned(
              right: 54,
              bottom: 24,
              child: SizedBox(
                height: 170,
                child: Image.asset(
                  'assets/images/account_verification/explorer_verification_header.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentGuidePlaceholder extends StatelessWidget {
  const _ParentGuidePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 122,
      height: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: LqColors.softGreen,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.supervisor_account_outlined,
              color: LqColors.primaryGreen,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '보호자\n확인',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              height: 1.28,
              fontWeight: FontWeight.w800,
              color: LqColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
