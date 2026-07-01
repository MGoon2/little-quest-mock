import 'package:flutter/material.dart';

/// 계정 확인 상단 탐험가 일러스트.
class AccountVerificationHeroIllustration extends StatelessWidget {
  const AccountVerificationHeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Image.asset(
        'assets/images/account_verification/explorer_verification_header.png',
        fit: BoxFit.contain,
        width: double.infinity,
        height: 200,
      ),
    );
  }
}
