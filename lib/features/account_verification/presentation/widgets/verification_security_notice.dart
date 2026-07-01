import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 보안 안내 박스.
class VerificationSecurityNotice extends StatelessWidget {
  const VerificationSecurityNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: LqColors.softGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user,
              size: 20,
              color: LqColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              '본인 확인 후 10분 동안\n개인정보 수정을 이용할 수 있어요.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: LqColors.textDark,
              ),
            ),
          ),
          Icon(
            Icons.eco,
            size: 28,
            color: LqColors.mutedGreen.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
