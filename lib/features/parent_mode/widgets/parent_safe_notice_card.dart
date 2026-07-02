import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

class ParentSafeNoticeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ParentSafeNoticeCard({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.privacy_tip_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return ParentSectionCard(
      backgroundColor: LqColors.softGreen,
      showBorder: false,
      child: Row(
        children: [
          Icon(icon, size: 32, color: LqColors.primaryGreen),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                    color: LqColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    height: 1.45,
                    color: LqColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
