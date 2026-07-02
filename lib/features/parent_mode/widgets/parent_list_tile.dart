import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

/// 부모 모드 카드 안에서 쓰는 행 항목.
class ParentListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color iconBackgroundColor;
  final Color iconColor;

  const ParentListTile({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.iconBackgroundColor = LqColors.softGreen,
    this.iconColor = LqColors.primaryGreen,
  });

  @override
  Widget build(BuildContext context) {
    final row = Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: LqColors.border))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: LqColors.textDark,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      height: 1.35,
                      color: LqColors.textSubtle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing ??
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: LqColors.textSubtle,
              ),
        ],
      ),
    );

    if (onTap == null) return row;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: row,
      ),
    );
  }
}
