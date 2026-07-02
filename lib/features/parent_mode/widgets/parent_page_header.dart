import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

class ParentPageHeader extends StatelessWidget {
  final String title;
  final String description;

  const ParentPageHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 32,
            height: 1.2,
            fontWeight: FontWeight.w900,
            color: LqColors.deepGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 15,
            height: 1.45,
            color: LqColors.textDark,
          ),
        ),
      ],
    );
  }
}
