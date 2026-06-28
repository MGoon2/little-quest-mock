import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';

/// 계정 확인 메인 안내 문구.
class AccountVerificationTitleSection extends StatelessWidget {
  final String? title;
  final String? description;

  const AccountVerificationTitleSection({
    super.key,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title ?? '개인정보 보호를 위해\n계정을 다시 확인해 주세요',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.35,
            color: LqColors.deepGreen,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description ?? '안전한 서비스 이용을 위해\n본인 확인이 필요합니다.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: LqColors.textSubtle,
          ),
        ),
      ],
    );
  }
}
