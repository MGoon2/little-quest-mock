import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/models/parent_menu_item.dart';

/// 부모 홈 메뉴 타일.
class ParentMenuTile extends StatelessWidget {
  final ParentMenuItem item;
  final VoidCallback? onTap;

  const ParentMenuTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LqColors.cardCream,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: LqColors.border),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: LqColors.softGreen,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(item.icon, size: 30, color: LqColors.primaryGreen),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: LqColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11,
                  color: LqColors.textSubtle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
