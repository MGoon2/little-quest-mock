import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/models/parent_record_summary.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

/// 탐험 기록 숫자 요약 카드.
class ParentRecordSummaryCard extends StatelessWidget {
  final ParentRecordSummary summary;

  const ParentRecordSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return ParentSectionCard(
      backgroundColor: LqColors.softGreen,
      child: Row(
        children: [
          _SummaryItem(
            icon: Icons.photo_library_outlined,
            label: '촬영한 사진',
            value: '${summary.photoCount}장',
          ),
          _SummaryItem(
            icon: Icons.style_outlined,
            label: '생성한 카드',
            value: '${summary.cardCount}개',
          ),
          _SummaryItem(
            icon: Icons.place_outlined,
            label: '탐험한 장소',
            value: '${summary.placeCount}곳',
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: LqColors.primaryGreen, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 11,
              color: LqColors.textDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: LqColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
