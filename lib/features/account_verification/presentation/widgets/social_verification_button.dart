import 'package:flutter/material.dart';

import 'package:little_quest/features/account_verification/data/models/social_account_verification_data.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// SNS 재인증 버튼.
class SocialVerificationButton extends StatelessWidget {
  final AuthProvider provider;
  final VoidCallback? onTap;

  const SocialVerificationButton({
    super.key,
    required this.provider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = _providerLabel;
    final isKakao = provider == AuthProvider.kakao;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // color: isKakao ? const Color(0xFFFFE812) : LqColors.cardCream,
          color: LqColors.cardCream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            // color: isKakao ? const Color(0xFFE0C000) : LqColors.border,
            color: LqColors.border,
          ),
        ),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isKakao ? LqColors.textDark : LqColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case AuthProvider.google:
        return const Icon(Icons.g_mobiledata, size: 28, color: Colors.red);
      case AuthProvider.apple:
        return const Icon(Icons.apple, size: 24, color: LqColors.textDark);
      case AuthProvider.naver:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF03C75A),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      case AuthProvider.kakao:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF3C1E1E),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'K',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
    }
  }

  String get _providerLabel {
    switch (provider) {
      case AuthProvider.google:
        return 'Google로 다시 확인하기';
      case AuthProvider.apple:
        return 'Apple로 다시 확인하기';
      case AuthProvider.naver:
        return 'Naver로 다시 확인하기';
      case AuthProvider.kakao:
        return 'Kakao로 다시 확인하기';
    }
  }
}
