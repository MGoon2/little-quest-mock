import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

class ParentAddChildCard extends StatelessWidget {
  final VoidCallback? onTap;

  const ParentAddChildCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: LqColors.cardCream,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: LqColors.border),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: const [
              _AddIcon(),
              SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '아이 추가하기',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: LqColors.deepGreen,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '새로운 아이를 추가하고 관리할 수 있어요.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13,
                        height: 1.35,
                        color: LqColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.chevron_right, size: 24, color: LqColors.textDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddIcon extends StatelessWidget {
  const _AddIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: LqColors.softGreen,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, size: 34, color: LqColors.primaryGreen),
    );
  }
}
