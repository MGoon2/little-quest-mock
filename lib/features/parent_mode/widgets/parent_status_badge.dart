import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

/// 부모 모드 상태 표시 배지.
class ParentStatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const ParentStatusBadge({
    super.key,
    required this.label,
    this.backgroundColor = LqColors.softGreen,
    this.textColor = LqColors.deepGreen,
  });

  const ParentStatusBadge.danger({super.key, required this.label})
    : backgroundColor = LqColors.dangerSoft,
      textColor = LqColors.danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}
