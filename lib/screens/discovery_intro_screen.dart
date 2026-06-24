import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/primary_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'camera_screen.dart';

/// 발견 카드 소개 화면.
///
/// 사진 한 장이 AI 분석을 통해 도감 카드가 되는 과정을 설명한다.
class DiscoveryIntroScreen extends StatelessWidget {
  const DiscoveryIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('발견 카드란?', style: AppTextStyles.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                '사진 한 장이\n나만의 도감 카드가 돼요',
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'AI가 사진 속 대상을 분석하고,\n근거 있는 정보로 카드의 앞면과 뒷면을 만들어줘요.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildCardPreview(),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildFeatureGrid(),
              const SizedBox(height: AppSpacing.sectionGap),
              PrimaryButton(
                label: '사진으로 카드 만들기',
                icon: const Icon(Icons.camera_alt, size: 20),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CameraScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          // 카드 앞면
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.leafLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('은행나무', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Ginkgo biloba',
                  style: AppTextStyles.caption.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTag('식물'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildTag('나무'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // 카드 뒷면
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('특징', style: AppTextStyles.heading),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '부채꼴 모양의 잎을 가진 대표적인 활엽 교목이에요.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('서식지', style: AppTextStyles.heading),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '도시 가로수나 공원에서 흔히 볼 수 있어요.',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionMedium.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      _Feature(
        icon: Icons.menu_book,
        title: '근거 기반 정보',
        description: '검증된 출처로\n정확하게',
      ),
      _Feature(
        icon: Icons.verified_user,
        title: '아이 안전 우선',
        description: '유해하지 않은 식물만\n선별',
      ),
      _Feature(
        icon: Icons.people,
        title: '연령 맞춤 설명',
        description: '나이에 맞는 쉬운\n설명 제공',
      ),
    ];

    return Row(
      children: features
          .map(
            (feature) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Icon(
                        feature.icon,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      feature.title,
                      style: GoogleFonts.jua(
                        textStyle: AppTextStyles.bodyMedium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature.description,
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;

  _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });
}
