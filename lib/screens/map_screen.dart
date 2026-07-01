import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';
import 'package:little_quest/core/widgets/primary_button.dart';

/// 탐험 지도 화면.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('탐험 지도', style: AppTextStyles.titleMedium),
      ),
      body: Stack(
        children: [
          // 지도 플레이스홀더
          Container(
            color: const Color(0xFFE6EFDE),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 80,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '지도를 불러오는 중...',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 플로팅 카드
          Positioned(
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            bottom: AppSpacing.xxl,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('서울숲 가족마당', style: AppTextStyles.heading),
                            Text(
                              '12종류 발견 · 2024.05.20',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(label: '이 위치에서 퀘스트 시작', onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
