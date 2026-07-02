import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';

/// 최근 사진 6개 그리드. 실제 사진 연동 전에는 자연물 placeholder를 사용한다.
class ParentRecentPhotoGrid extends StatelessWidget {
  final List<ParentRecentPhoto> photos;

  const ParentRecentPhotoGrid({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        return Semantics(
          label: '최근 자연 사진 ${photo.label}',
          image: true,
          child: Container(
            decoration: BoxDecoration(
              color: photo.color,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: LqColors.border),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    photo.icon,
                    size: 34,
                    color: LqColors.primaryGreen.withValues(alpha: 0.86),
                  ),
                ),
                Positioned(
                  right: 7,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      photo.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 9,
                        color: LqColors.textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
