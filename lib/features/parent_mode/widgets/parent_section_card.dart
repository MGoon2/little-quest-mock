import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 부모 모드 공통 섹션 카드.
class ParentSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final bool showBorder;

  const ParentSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor = LqColors.cardCream,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: showBorder ? Border.all(color: LqColors.border) : null,
        boxShadow: AppShadows.soft,
      ),
      child: child,
    );
  }
}
