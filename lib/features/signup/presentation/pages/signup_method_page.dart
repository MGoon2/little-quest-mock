import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/signup/data/models/signup_provider.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_dimensions.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_hero_illustration.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_method_button.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_security_notice_card.dart';

class SignupMethodPage extends StatelessWidget {
  const SignupMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            SignupDimensions.screenPadding,
            48,
            SignupDimensions.screenPadding,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SignupTitleSection(),
              const SizedBox(height: 20),
              const SignupHeroIllustration(),
              const SizedBox(height: 28),
              SignupMethodButton.email(
                label: '이메일로 회원가입',
                onPressed: () =>
                    Navigator.of(context).pushNamed('/signup/email'),
              ),
              const SizedBox(height: 12),
              SignupMethodButton.social(
                provider: SignupProvider.google,
                label: 'Google로 계속하기',
                onPressed: () {
                  // TODO: Google signup flow
                },
              ),
              const SizedBox(height: 12),
              SignupMethodButton.social(
                provider: SignupProvider.apple,
                label: 'Apple로 계속하기',
                onPressed: () {
                  // TODO: Apple signup flow
                },
              ),
              const SizedBox(height: 12),
              SignupMethodButton.social(
                provider: SignupProvider.naver,
                label: 'Naver로 계속하기',
                onPressed: () {
                  // TODO: Naver signup flow
                },
              ),
              const SizedBox(height: 12),
              SignupMethodButton.social(
                provider: SignupProvider.kakao,
                label: 'Kakao로 계속하기',
                onPressed: () {
                  // TODO: Kakao signup flow
                },
              ),
              const SizedBox(height: 28),
              const _SignupDividerWithText(text: '또는'),
              const SizedBox(height: 18),
              const _LoginLinkText(),
              const SizedBox(height: 28),
              const SignupSecurityNoticeCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupTitleSection extends StatelessWidget {
  const _SignupTitleSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          '회원가입',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Jua',
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: LqColors.deepGreen,
            height: 1.15,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Little Quest와 함께\n아이의 자연 모험을 시작해요!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: LqColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _SignupDividerWithText extends StatelessWidget {
  final String text;

  const _SignupDividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: LqColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              color: LqColors.textSubtle,
            ),
          ),
        ),
        const Expanded(child: Divider(color: LqColors.border)),
      ],
    );
  }
}

class _LoginLinkText extends StatelessWidget {
  const _LoginLinkText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            '이미 계정이 있으신가요? ',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15,
              height: 1.4,
              color: LqColors.textDark,
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: LoginPage로 이동
              Navigator.of(context).pushNamed('/login');
            },
            child: const Text(
              '로그인하기',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w800,
                color: LqColors.deepGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
