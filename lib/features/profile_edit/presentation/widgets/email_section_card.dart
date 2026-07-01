import 'package:flutter/material.dart';

import 'package:little_quest/features/profile_edit/data/models/profile_edit_data.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 이메일 섹션 카드.
class EmailSectionCard extends StatelessWidget {
  final ProfileEditData data;

  const EmailSectionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: LqColors.softGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.email,
              size: 20,
              color: LqColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              data.email,
              style: const TextStyle(fontSize: 14, color: LqColors.textDark),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // TODO: email change flow
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: LqColors.cream,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: LqColors.mutedGreen),
              ),
              child: const Text(
                '변경',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: LqColors.deepGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LqColors.border),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
