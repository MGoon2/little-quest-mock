import 'package:flutter/material.dart';

import '../components/plan_card.dart';
import '../models/plan_tier.dart';
import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';

/// 구독 플랜 안내 화면.
class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  bool _isYearly = false;
  PlanTier _selectedTier = PlanTier.plus;

  List<Plan> get _plans => [
    const Plan(
      tier: PlanTier.free,
      title: 'Free',
      price: '무료',
      period: '평생',
      features: ['월 20장 카드 생성', '기본 카드 저장', '대표 지도 한번 사용', '커뮤니티'],
      isPopular: false,
    ),
    Plan(
      tier: PlanTier.plus,
      title: 'Plus',
      price: _isYearly ? '월 5,900원' : '월 6,900원',
      period: _isYearly ? '연간 결제' : '월간 결제',
      features: [
        '월 100장 카드 생성',
        '지도 기록 슬롯 20개',
        'Holo 카드 표시',
        'PDF 다운로드 월 3회',
        '디지털 백업드 확장',
      ],
      isPopular: true,
    ),
    Plan(
      tier: PlanTier.family,
      title: 'Family',
      price: _isYearly ? '월 11,900원' : '월 12,900원',
      period: _isYearly ? '연간 결제' : '월간 결제',
      features: [
        '월 300장 카드 생성',
        '자녀 프로필 최대 3명',
        '지도 기록 슬롯 100개',
        'PDF 다운로드 월 10회',
        '가족 발견 지도',
      ],
      isPopular: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('플랜 안내', style: AppTextStyles.titleMedium),
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
                '더 넓은 탐험을\nLittle Quest와 함께',
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '이야기 탐험을 더 풍부하게 만들어주세요.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildPeriodToggle(),
              const SizedBox(height: AppSpacing.xxl),
              ..._plans.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: PlanCard(
                    plan: plan,
                    isSelected: _selectedTier == plan.tier,
                    onTap: () => setState(() => _selectedTier = plan.tier),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                '언제든지 취소할 수 있어요.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '플랜 비교 자세히 보기 >',
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PeriodButton(
              label: '월간',
              isSelected: !_isYearly,
              onTap: () => setState(() => _isYearly = false),
            ),
          ),
          Expanded(
            child: _PeriodButton(
              label: '연간',
              badge: '-17%',
              isSelected: _isYearly,
              onTap: () => setState(() => _isYearly = true),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: AppShadows.card,
              )
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentCoralLight,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.accentCoral,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
