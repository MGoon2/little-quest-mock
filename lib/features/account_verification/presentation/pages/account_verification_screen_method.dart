import 'package:flutter/material.dart';

import 'package:little_quest/features/account_verification/data/models/account_verification_method_data.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/account_verification_app_bar.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/account_verification_hero_illustration.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/account_verification_title_section.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/reauthentication_notice_card.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/verification_method_card.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 계정 확인 방법 선택 화면.
class AccountVerificationScreenMethod extends StatelessWidget {
  final AccountVerificationMethodData? data;

  const AccountVerificationScreenMethod({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final methodData =
        data ??
        const AccountVerificationMethodData(
          methods: [
            VerificationMethod.password,
            VerificationMethod.google,
            VerificationMethod.apple,
            VerificationMethod.naver,
            VerificationMethod.kakao,
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
                description: '확인 방법을 선택해 주세요.',
              ),
              const SizedBox(height: 20),
              VerificationMethodCard(
                methods: methodData.methods,
                onMethodTap: (method) => _handleMethodTap(context, method),
              ),
              const SizedBox(height: 18),
              ReauthenticationNoticeCard(
                validMinutes: methodData.reauthenticationValidMinutes,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMethodTap(BuildContext context, VerificationMethod method) {
    switch (method) {
      case VerificationMethod.password:
        Navigator.of(context).pushNamed('/account-verification');
      case VerificationMethod.google:
      case VerificationMethod.apple:
      case VerificationMethod.naver:
      case VerificationMethod.kakao:
        // TODO: call provider reauthentication flow
        break;
    }
  }
}
