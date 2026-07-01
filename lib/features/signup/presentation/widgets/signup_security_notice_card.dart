import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_dimensions.dart';

class SignupSecurityNoticeCard extends StatelessWidget {
  const SignupSecurityNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SignupDimensions.cardRadius),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/account_verification/little-quest-security-banner-bg.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: LqColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              '안전한 서비스 이용을 위해\n개인정보는 안전하게 보호해요.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: LqColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
