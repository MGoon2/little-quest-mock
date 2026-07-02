import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 부모 모드 위험 액션 버튼.
class ParentDangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ParentDangerButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: LqColors.danger,
          side: const BorderSide(color: LqColors.danger),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
