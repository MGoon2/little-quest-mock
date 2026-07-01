import 'package:flutter/material.dart';

import '../models/card_detail_data.dart';
import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';

/// 나의 Holo 등급 진행 영역.
class HoloProgressCard extends StatelessWidget {
  final CardDetailData data;

  const HoloProgressCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text('나의 Holo 등급', style: AppTextStyles.heading),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGradeProgress(),
          const SizedBox(height: AppSpacing.xs),
          _buildNextGradeConditions(),
        ],
      ),
    );
  }

  Widget _buildGradeProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const baseWidth = 375.0;
        const baseNodeLabelWidth = 120.0;
        const baseNodeCenterY = 28.0;
        const baseLineGap = 6.0;
        const baseLineThickness = 4.0;
        const baseStackHeight = 152.0;
        const baseDashWidth = 6.0;
        const baseGapWidth = 4.0;

        // 화면 너비에 비례하여 전체 요소를 확대/축소
        final progressWidth = constraints.maxWidth;
        final scaleFactor = (progressWidth / baseWidth).clamp(0.9, 1.2);

        final nodeLabelWidth = baseNodeLabelWidth * scaleFactor;
        final nodeCenterY = baseNodeCenterY * scaleFactor;
        final lineGap = baseLineGap * scaleFactor;
        final lineThickness = baseLineThickness * scaleFactor;
        final stackHeight = baseStackHeight * scaleFactor;
        final dashWidth = baseDashWidth * scaleFactor;
        final gapWidth = baseGapWidth * scaleFactor;

        // 등급 간 간격을 넉넉하게 확보
        const ratio = 0.15;
        final normalX = progressWidth * ratio;
        final holoX = progressWidth * 0.50;
        final seasonalX = progressWidth * (1 - ratio);

        final normalRadius = 20.0 * scaleFactor;
        final holoRadius = 24.0 * scaleFactor;
        final seasonalRadius = 20.0 * scaleFactor;

        final currentIndex = HoloGrade.values.indexOf(data.currentGrade);

        return SizedBox(
          width: progressWidth,
          height: stackHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 완료 구간 라인 (Normal → Holo)
              Positioned(
                left: normalX + normalRadius + lineGap,
                top: nodeCenterY - lineThickness / 2,
                width:
                    (holoX - holoRadius - lineGap) -
                    (normalX + normalRadius + lineGap),
                child: Container(
                  height: lineThickness,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(lineThickness / 2),
                  ),
                ),
              ),
              // 미완료 구간 라인 (Holo → Seasonal Holo)
              Positioned(
                left: holoX + holoRadius + lineGap,
                top: nodeCenterY - lineThickness / 2,
                width:
                    (seasonalX - seasonalRadius - lineGap) -
                    (holoX + holoRadius + lineGap),
                child: CustomPaint(
                  size: Size(
                    (seasonalX - seasonalRadius - lineGap) -
                        (holoX + holoRadius + lineGap),
                    lineThickness,
                  ),
                  painter: _DashedLinePainter(
                    color: const Color(0xFFE1E7D9),
                    thickness: lineThickness,
                    dashWidth: dashWidth,
                    gapWidth: gapWidth,
                  ),
                ),
              ),
              // Normal 노드
              Positioned(
                left: normalX - nodeLabelWidth / 2,
                top: nodeCenterY - normalRadius,
                width: nodeLabelWidth,
                child: _GradeNode(
                  grade: HoloGrade.normal,
                  isCompleted: currentIndex >= 0,
                  isCurrent: currentIndex == 0,
                  isLocked: currentIndex < 0,
                  scaleFactor: scaleFactor,
                ),
              ),
              // Holo 노드
              Positioned(
                left: holoX - nodeLabelWidth / 2,
                top: nodeCenterY - holoRadius,
                width: nodeLabelWidth,
                child: _GradeNode(
                  grade: HoloGrade.holo,
                  isCompleted: currentIndex >= 1,
                  isCurrent: currentIndex == 1,
                  isLocked: currentIndex < 1,
                  scaleFactor: scaleFactor,
                ),
              ),
              // Seasonal Holo 노드
              Positioned(
                left: seasonalX - nodeLabelWidth / 2,
                top: nodeCenterY - seasonalRadius,
                width: nodeLabelWidth,
                child: _GradeNode(
                  grade: HoloGrade.seasonalHolo,
                  isCompleted: currentIndex >= 2,
                  isCurrent: currentIndex == 2,
                  isLocked: currentIndex < 2,
                  scaleFactor: scaleFactor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNextGradeConditions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '다음 단계 조건',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...data.nextGradeConditions.map((condition) {
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(
                    condition.isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    size: 16,
                    color: condition.isCompleted
                        ? AppColors.success
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      condition.label,
                      style: AppTextStyles.body.copyWith(
                        color: condition.isCompleted
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: condition.isCompleted
                          ? AppColors.primarySoft
                          : AppColors.divider,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '${condition.current}/${condition.required}',
                      style: AppTextStyles.captionMedium.copyWith(
                        color: condition.isCompleted
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '조건을 모두 완료하면 Seasonal Holo로 업그레이드돼요!',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 등급 단계 노드.
class _GradeNode extends StatelessWidget {
  final HoloGrade grade;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final double scaleFactor;

  const _GradeNode({
    required this.grade,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    final size = (isCurrent ? 48.0 : 40.0) * scaleFactor;
    final backgroundColor = isLocked ? AppColors.surface : AppColors.primary;
    final iconColor = isLocked ? AppColors.textTertiary : AppColors.textInverse;

    IconData icon;
    switch (grade) {
      case HoloGrade.normal:
        icon = Icons.eco;
      case HoloGrade.holo:
        icon = Icons.auto_awesome;
      case HoloGrade.seasonalHolo:
        icon = isLocked ? Icons.lock : Icons.local_florist;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: isLocked ? Border.all(color: AppColors.divider) : null,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: const Color(0xFF4A90A4).withValues(alpha: 0.45),
                      blurRadius: 8 * scaleFactor,
                      spreadRadius: 1 * scaleFactor,
                    ),
                    BoxShadow(
                      color: const Color(0xFF6BB3C7).withValues(alpha: 0.25),
                      blurRadius: 16 * scaleFactor,
                      spreadRadius: 4 * scaleFactor,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              icon,
              size: (isCurrent ? 24.0 : 20.0) * scaleFactor,
              color: iconColor,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md * scaleFactor),
        // 등급별 라벨 영역 높이를 통일하여 정렬
        SizedBox(
          height: 76 * scaleFactor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                grade.label,
                textAlign: TextAlign.center,
                style: isCurrent
                    ? AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14 * scaleFactor,
                      )
                    : AppTextStyles.captionMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12 * scaleFactor,
                      ),
              ),
              SizedBox(height: AppSpacing.xs * scaleFactor),
              Text(
                grade.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 12 * scaleFactor,
                ),
              ),
              SizedBox(height: AppSpacing.xs * scaleFactor),
              // 달성/잠금 표시 영역은 항상 동일한 높이를 차지
              if (isCurrent)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm * scaleFactor,
                    vertical: 2 * scaleFactor,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '달성!',
                    style: AppTextStyles.label.copyWith(
                      fontSize: 10 * scaleFactor,
                    ),
                  ),
                )
              else if (isLocked)
                Icon(
                  Icons.lock,
                  size: 14 * scaleFactor,
                  color: AppColors.textTertiary,
                )
              else
                SizedBox(height: 14 * scaleFactor),
            ],
          ),
        ),
      ],
    );
  }
}

/// 점선 라인 painter.
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double dashWidth;
  final double gapWidth;

  const _DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.dashWidth,
    required this.gapWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    var startX = 0.0;
    while (startX < size.width) {
      final endX = (startX + dashWidth).clamp(0.0, size.width);
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(endX, size.height / 2),
        paint,
      );
      startX += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
