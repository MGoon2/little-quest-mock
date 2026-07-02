import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

class ParentDangerOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ParentDangerOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: LqColors.danger,
          backgroundColor: Colors.white,
          side: const BorderSide(color: LqColors.danger),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
