import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';

/// 비밀번호 섹션 카드.
class PasswordSectionCard extends StatelessWidget {
  const PasswordSectionCard({super.key});

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
              Icons.lock,
              size: 20,
              color: LqColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              '********',
              style: TextStyle(
                fontSize: 14,
                color: LqColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // TODO: password change flow
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
