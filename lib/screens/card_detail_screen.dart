import 'package:flutter/material.dart';

import '../models/discovery_card_item.dart';
import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';

/// 도감 카드 상세 화면.
class CardDetailScreen extends StatelessWidget {
  final DiscoveryCardItem item;

  const CardDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: item.backgroundColor,
                child: Center(
                  child: Icon(item.icon, size: 120, color: AppColors.primary),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    children: [
                      _buildTag(item.category),
                      const SizedBox(width: AppSpacing.sm),
                      if (item.isNew) _buildTag('NEW'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(item.name, style: AppTextStyles.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Latin Name',
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  _buildInfoCard(
                    title: '특징',
                    content: '이 대상의 대표적인 특징을 AI가 분석하여 설명해요.',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildInfoCard(
                    title: '서식지',
                    content: '우리 주변에서 어디에서 흔히 발견할 수 있는지 알려줘요.',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildInfoCard(
                    title: '유해 여부',
                    content: '아이가 접해도 안전한지, 주의가 필요한지 알려줘요.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
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
        style: AppTextStyles.captionMedium.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
