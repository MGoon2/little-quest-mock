import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/account_verification_method_data.dart';

/// 계정 확인 방법 버튼.
class VerificationMethodButton extends StatelessWidget {
  final VerificationMethod method;
  final VoidCallback? onTap;

  const VerificationMethodButton({
    super.key,
    required this.method,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: LqColors.cardCream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: LqColors.border),
        ),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: LqColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (method) {
      case VerificationMethod.password:
        return Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: LqColors.softGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock,
            size: 18,
            color: LqColors.primaryGreen,
          ),
        );
      case VerificationMethod.google:
        return const Icon(Icons.g_mobiledata, size: 28, color: Colors.red);
      case VerificationMethod.apple:
        return const Icon(Icons.apple, size: 24, color: LqColors.textDark);
      case VerificationMethod.naver:
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
      case VerificationMethod.kakao:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE812),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'K',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C1E1E),
              ),
            ),
          ),
        );
    }
  }

  String get _label {
    switch (method) {
      case VerificationMethod.password:
        return '비밀번호로 확인하기';
      case VerificationMethod.google:
        return 'Google로 확인하기';
      case VerificationMethod.apple:
        return 'Apple로 확인하기';
      case VerificationMethod.naver:
        return 'Naver로 확인하기';
      case VerificationMethod.kakao:
        return 'Kakao로 확인하기';
    }
  }
}
