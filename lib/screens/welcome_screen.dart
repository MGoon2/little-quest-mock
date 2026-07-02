import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/core/widgets/primary_button.dart';

/// 앱 진입 시 보여지는 웰컴 화면.
///
/// 이미지를 전체 배경으로 사용하고, 실제 버튼은 Flutter 컴포넌트로 유지한다.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 웰컴 배경 이미지
          Image.asset(
            'assets/images/welcome_background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // 하단 버튼 영역
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  PrimaryButton(
                    label: '퀘스트 시작하기',
                    onPressed: () => _navigateToModeSelection(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: '로그인',
                    isSecondary: true,
                    onPressed: () => _navigateToLogin(context),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToModeSelection(BuildContext context) {
    Navigator.of(context).pushNamed('/mode-selection');
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamed('/login');
  }
}
