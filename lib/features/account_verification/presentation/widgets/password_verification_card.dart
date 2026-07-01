import 'package:flutter/material.dart';

import 'package:little_quest/features/account_verification/presentation/widgets/lq_password_text_field.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 비밀번호 확인 카드.
class PasswordVerificationCard extends StatelessWidget {
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onSubmit;
  final bool isSubmitting;
  final String? errorMessage;

  const PasswordVerificationCard({
    super.key,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    this.onForgotPassword,
    this.onSubmit,
    this.isSubmitting = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LqColors.border),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 카드 제목
          Row(
            children: [
              const Icon(Icons.spa, size: 18, color: LqColors.primaryGreen),
              const SizedBox(width: 8),
              const Text(
                '이메일로 가입한 계정이에요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: LqColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // 입력 안내
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: LqColors.softGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 22,
                  color: LqColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '비밀번호를 입력해 주세요',
                style: TextStyle(fontSize: 14, color: LqColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // 비밀번호 입력
          LqPasswordTextField(
            controller: passwordController,
            obscureText: obscurePassword,
            onToggleObscure: onToggleObscure,
            errorText: errorMessage,
          ),
          const SizedBox(height: 12),
          // 비밀번호 찾기
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onForgotPassword,
              child: const Text(
                '비밀번호를 잊으셨나요?',
                style: TextStyle(
                  fontSize: 13,
                  color: LqColors.deepGreen,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 확인 버튼
          GestureDetector(
            onTap: isSubmitting ? null : onSubmit,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: LqColors.primaryGreen,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: LqColors.primaryGreen.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
