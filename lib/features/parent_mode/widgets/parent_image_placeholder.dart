import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

class ParentImagePlaceholder extends StatelessWidget {
  final String label;
  final BoxShape shape;
  final double size;

  const ParentImagePlaceholder({
    super.key,
    required this.label,
    this.shape = BoxShape.rectangle,
    this.size = 92,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = shape == BoxShape.rectangle
        ? BorderRadius.circular(18)
        : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: LqColors.softGreen,
        shape: shape,
        borderRadius: borderRadius,
        border: Border.all(color: LqColors.lightGreen, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.image_outlined,
                size: 26,
                color: LqColors.primaryGreen,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: LqColors.primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
