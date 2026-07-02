import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/models/parent_child_profile.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_image_placeholder.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_status_badge.dart';

class ParentChildListCard extends StatelessWidget {
  final ParentChildProfile child;
  final VoidCallback? onTap;

  const ParentChildListCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 14, 18),
          decoration: BoxDecoration(
            color: LqColors.cardCream,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: child.isSelected ? LqColors.primaryGreen : LqColors.border,
              width: child.isSelected ? 1.5 : 1,
            ),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _ChildAvatar(child: child),
                  if (child.isSelected)
                    const Positioned(
                      left: -2,
                      top: -14,
                      child: ParentStatusBadge(
                        label: '현재 선택됨',
                        backgroundColor: LqColors.primaryGreen,
                        textColor: Colors.white,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w900,
                        color: LqColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${child.age}세 (${_formatDate(child.birthDate)})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        height: 1.35,
                        color: LqColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '탐험 레벨 ${child.explorerLevel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        height: 1.35,
                        color: LqColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ParentStatusBadge(
                        label: child.gradeLabel,
                        backgroundColor: LqColors.softGreen,
                        textColor: LqColors.deepGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                size: 28,
                color: LqColors.textDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day';
  }
}

class _ChildAvatar extends StatelessWidget {
  final ParentChildProfile child;

  const _ChildAvatar({required this.child});

  @override
  Widget build(BuildContext context) {
    if (child.avatarAssetPath == null) {
      return const ParentImagePlaceholder(
        label: '아이 이미지',
        shape: BoxShape.circle,
        size: 92,
      );
    }

    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: LqColors.lightGreen, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(child.avatarAssetPath!, fit: BoxFit.cover),
    );
  }
}
