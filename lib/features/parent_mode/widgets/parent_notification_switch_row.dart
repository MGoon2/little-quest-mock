import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

class ParentNotificationSwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const ParentNotificationSwitchRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: LqColors.border))
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: LqColors.textDark),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
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
          Switch.adaptive(
            value: value,
            activeThumbColor: LqColors.primaryGreen,
            activeTrackColor: LqColors.lightGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
