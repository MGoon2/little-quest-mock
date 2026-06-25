import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_shadows.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_text_styles.dart';
import '../models/card_detail_data.dart';
import 'category_chip.dart';
import 'holo_badge.dart';

/// 대표 카드 영역.
class DiscoveryHeroCard extends StatelessWidget {
  final CardDetailData data;

  const DiscoveryHeroCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              // 중앙 대표 이미지
              _buildHeroImage(context),
              // 좌상단 Holo 배지
              Positioned(
                top: 0,
                left: 0,
                child: HoloBadge(label: data.currentGrade.label),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // 대상 이름
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data.nameKo, style: AppTextStyles.titleLarge),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.eco, size: 20, color: AppColors.primaryLight),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // 학명
          Text(
            data.nameEn,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // 카테고리 칩
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryChip(label: data.categoryLabel, icon: Icons.eco),
              const SizedBox(width: AppSpacing.md),
              CategoryChip(
                label: data.subCategoryLabel,
                icon: Icons.account_tree,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // 한 줄 설명
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(Icons.eco, size: 28, color: AppColors.primaryLight),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    data.oneLineDescription,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: const BoxDecoration(
        color: AppColors.leafLight,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(160, 160),
          painter: _GinkgoLeafPainter(),
        ),
      ),
    );
  }
}

/// 수채화풍 은행잎 placeholder.
class _GinkgoLeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final leafPath = Path()
      ..moveTo(center.dx, center.dy + 70)
      ..cubicTo(
        center.dx - 40,
        center.dy + 60,
        center.dx - 75,
        center.dy - 10,
        center.dx - 75,
        center.dy - 50,
      )
      ..cubicTo(
        center.dx - 75,
        center.dy - 90,
        center.dx - 45,
        center.dy - 110,
        center.dx,
        center.dy - 110,
      )
      ..cubicTo(
        center.dx + 45,
        center.dy - 110,
        center.dx + 75,
        center.dy - 90,
        center.dx + 75,
        center.dy - 50,
      )
      ..cubicTo(
        center.dx + 75,
        center.dy - 10,
        center.dx + 40,
        center.dy + 60,
        center.dx,
        center.dy + 70,
      )
      ..close();

    final fillPaint = Paint()
      ..color = AppColors.primaryLight
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(leafPath, fillPaint);
    canvas.drawPath(leafPath, strokePaint);

    // 잎맥
    final veinPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(center.dx, center.dy + 65),
      Offset(center.dx, center.dy - 90),
      veinPaint,
    );

    for (var i = 1; i <= 6; i++) {
      final y = center.dy + 50 - i * 22;
      canvas.drawLine(
        Offset(center.dx, y),
        Offset(center.dx - 35 + i * 2, y - 18),
        veinPaint,
      );
      canvas.drawLine(
        Offset(center.dx, y),
        Offset(center.dx + 35 - i * 2, y - 18),
        veinPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
