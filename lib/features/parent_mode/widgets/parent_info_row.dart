import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

class ParentInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool showDivider;
  final double labelWidth;

  const ParentInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.showChevron = true,
    this.showDivider = true,
    this.labelWidth = 84,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: LqColors.border))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 13,
                color: LqColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: LqColors.textDark,
              ),
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 19,
              color: LqColors.textSubtle,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
