import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/models/parent_child_summary.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

/// 부모 홈의 아이 프로필 요약 카드.
class ParentChildProfileCard extends StatelessWidget {
  final ParentChildSummary child;
  final VoidCallback? onViewProfile;

  const ParentChildProfileCard({
    super.key,
    required this.child,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return ParentSectionCard(
      child: Row(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: LqColors.softGreen,
              shape: BoxShape.circle,
              border: Border.all(color: LqColors.lightGreen, width: 3),
            ),
            child: ClipOval(
              child: child.avatarAssetPath == null
                  ? const Icon(
                      Icons.child_care,
                      size: 40,
                      color: LqColors.primaryGreen,
                    )
                  : Image.asset(child.avatarAssetPath!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.childName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: LqColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${child.age}세 · 탐험 레벨 ${child.explorerLevel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    color: LqColors.textSubtle,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 34,
                  child: OutlinedButton(
                    onPressed: onViewProfile,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: LqColors.primaryGreen,
                      side: const BorderSide(color: LqColors.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Text('아이 프로필 보기'),
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
