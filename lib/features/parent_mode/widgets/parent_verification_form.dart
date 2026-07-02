import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_social_auth_button.dart';

/// 보호자 확인 폼.
class ParentVerificationForm extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final bool obscurePassword;
  final bool obscurePasswordConfirm;
  final bool isValid;
  final bool isSubmitting;
  final int selectedMethodIndex;
  final VoidCallback onTogglePassword;
  final VoidCallback onTogglePasswordConfirm;
  final ValueChanged<int> onMethodChanged;
  final VoidCallback onSubmit;
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;

  const ParentVerificationForm({
    super.key,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.obscurePassword,
    required this.obscurePasswordConfirm,
    required this.isValid,
    required this.isSubmitting,
    required this.selectedMethodIndex,
    required this.onTogglePassword,
    required this.onTogglePasswordConfirm,
    required this.onMethodChanged,
    required this.onSubmit,
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: LqColors.cardCream,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: LqColors.border),
          ),
          child: Row(
            children: [
              _MethodTab(
                label: '비밀번호로 확인',
                selected: selectedMethodIndex == 0,
                onTap: () => onMethodChanged(0),
              ),
              _MethodTab(
                label: '다른 방법으로 확인',
                selected: selectedMethodIndex == 1,
                onTap: () => onMethodChanged(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        if (selectedMethodIndex == 0) ...[
          _ParentPasswordField(
            key: const ValueKey('parent_password'),
            controller: passwordController,
            label: '비밀번호',
            hintText: '비밀번호를 입력해주세요',
            obscureText: obscurePassword,
            onToggleObscure: onTogglePassword,
          ),
          const SizedBox(height: 14),
          _ParentPasswordField(
            key: const ValueKey('parent_password_confirm'),
            controller: passwordConfirmController,
            label: '비밀번호 확인',
            hintText: '비밀번호를 다시 입력해주세요',
            obscureText: obscurePasswordConfirm,
            onToggleObscure: onTogglePasswordConfirm,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: 보호자 비밀번호 재설정 화면 연결
              },
              child: const Text(
                '비밀번호를 잊으셨나요?',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: LqColors.textSubtle,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: isValid && !isSubmitting ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: LqColors.primaryGreen,
                disabledBackgroundColor: LqColors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      '확인',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ] else ...[
          const _SocialMethodNotice(),
        ],
        const SizedBox(height: 24),
        Row(
          children: const [
            Expanded(child: Divider(color: LqColors.border)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '또는',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: LqColors.textSubtle,
                ),
              ),
            ),
            Expanded(child: Divider(color: LqColors.border)),
          ],
        ),
        const SizedBox(height: 18),
        ParentSocialAuthButton(
          provider: ParentSocialProvider.google,
          onPressed: onGooglePressed,
        ),
        const SizedBox(height: 10),
        ParentSocialAuthButton(
          provider: ParentSocialProvider.apple,
          onPressed: onApplePressed,
        ),
      ],
    );
  }
}

class _MethodTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? LqColors.softGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.full),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: selected ? LqColors.deepGreen : LqColors.textSubtle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ParentPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final VoidCallback onToggleObscure;

  const _ParentPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.obscureText,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: LqColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              color: LqColors.textSubtle,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            suffixIcon: IconButton(
              tooltip: obscureText ? '비밀번호 보기' : '비밀번호 숨기기',
              icon: Icon(
                obscureText ? Icons.visibility_outlined : Icons.visibility_off,
                size: 20,
                color: LqColors.textSubtle,
              ),
              onPressed: onToggleObscure,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: LqColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: LqColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: LqColors.primaryGreen),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialMethodNotice extends StatelessWidget {
  const _SocialMethodNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LqColors.softGreen,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Text(
        '가입한 계정으로 다시 확인하면 보호자 모드에 들어갈 수 있어요.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 13,
          height: 1.5,
          color: LqColors.textDark,
        ),
      ),
    );
  }
}
