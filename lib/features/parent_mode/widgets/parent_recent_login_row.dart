import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

class ParentRecentLoginRow extends StatelessWidget {
  final String loggedInAtLabel;
  final String deviceName;
  final bool showDivider;

  const ParentRecentLoginRow({
    super.key,
    required this.loggedInAtLabel,
    required this.deviceName,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: LqColors.border))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              loggedInAtLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 13,
                color: LqColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '· $deviceName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              color: LqColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
