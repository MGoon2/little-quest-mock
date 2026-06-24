import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_text_styles.dart';

/// 메인 녹색 버튼.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final bool isFullWidth;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isSecondary = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSecondary ? AppColors.backgroundElevated : AppColors.primary;
    final foregroundColor =
        isSecondary ? AppColors.primary : AppColors.textInverse;
    final borderColor = isSecondary ? AppColors.primary : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: isSecondary ? null : AppShadows.button,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: isFullWidth ? double.infinity : null,
        height: 54,
        color: backgroundColor,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.button.copyWith(color: foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
