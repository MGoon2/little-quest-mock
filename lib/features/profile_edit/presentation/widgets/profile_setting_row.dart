import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 개인정보 수정 공통 row.
class ProfileSettingRow extends StatelessWidget {
  final Widget leadingIcon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const ProfileSettingRow({
    super.key,
    required this.leadingIcon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: LqColors.border))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: LqColors.softGreen,
                shape: BoxShape.circle,
              ),
              child: Center(child: leadingIcon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: LqColors.textDark),
              ),
            ),
            if (value != null)
              Flexible(
                child: Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: LqColors.textSubtle,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            trailing ?? const SizedBox.shrink(),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: LqColors.textSubtle,
            ),
          ],
        ),
      ),
    );
  }
}
