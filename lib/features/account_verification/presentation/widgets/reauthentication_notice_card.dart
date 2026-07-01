import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 재인증 안내 박스.
class ReauthenticationNoticeCard extends StatelessWidget {
  final int validMinutes;

  const ReauthenticationNoticeCard({super.key, this.validMinutes = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/account_verification/little-quest-security-banner-bg.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          '본인 확인 후 $validMinutes분 동안\n개인정보 수정을 이용할 수 있어요.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: LqColors.textDark,
          ),
        ),
      ),
    );
  }
}
