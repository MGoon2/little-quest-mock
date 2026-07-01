import 'package:flutter/material.dart';

import 'package:little_quest/features/account_verification/data/models/social_account_verification_data.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/account_verification_app_bar.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/account_verification_hero_illustration.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/account_verification_title_section.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/reauthentication_notice_card.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/social_verification_card.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// SNS 가입자용 계정 확인 화면.
class AccountVerificationScreenSocial extends StatelessWidget {
  final SocialAccountVerificationData? data;

  const AccountVerificationScreenSocial({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final verificationData =
        data ??
        const SocialAccountVerificationData(
          providers: [
            AuthProvider.google,
            AuthProvider.apple,
            AuthProvider.naver,
            AuthProvider.kakao,
          ],
        );

    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const AccountVerificationAppBar(title: '계정 확인'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AccountVerificationHeroIllustration(),
              const SizedBox(height: 10),
              const AccountVerificationTitleSection(
                description: '사용 중인 계정으로 다시 확인해 주세요.',
              ),
              const SizedBox(height: 20),
              SocialVerificationCard(
                providers: verificationData.providers,
                onProviderTap: (provider) {
                  // TODO: call provider reauthentication flow
                },
              ),
              const SizedBox(height: 18),
              ReauthenticationNoticeCard(
                validMinutes: verificationData.reauthenticationValidMinutes,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
