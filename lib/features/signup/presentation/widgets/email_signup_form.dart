import 'package:flutter/material.dart';

import 'package:little_quest/features/signup/data/models/email_signup_form_state.dart';
import 'package:little_quest/features/signup/presentation/widgets/birth_date_selector.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_text_field.dart';

class EmailSignupForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final TextEditingController nameController;
  final TextEditingController nicknameController;
  final EmailSignupFormState formState;
  final bool obscurePassword;
  final bool obscurePasswordConfirm;
  final VoidCallback onTogglePassword;
  final VoidCallback onTogglePasswordConfirm;
  final ValueChanged<EmailSignupFormState> onChanged;

  const EmailSignupForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.nameController,
    required this.nicknameController,
    required this.formState,
    required this.obscurePassword,
    required this.obscurePasswordConfirm,
    required this.onTogglePassword,
    required this.onTogglePasswordConfirm,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SignupTextField(
          controller: emailController,
          label: '이메일',
          hintText: '이메일을 입력해주세요',
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => onChanged(formState.copyWith(email: value)),
        ),
        const SizedBox(height: 22),
        SignupTextField(
          controller: passwordController,
          label: '비밀번호',
          hintText: '비밀번호를 입력해주세요',
          obscureText: obscurePassword,
          helperText: '영문, 숫자, 특수문자 포함 8자 이상',
          onChanged: (value) => onChanged(formState.copyWith(password: value)),
          suffixIcon: _PasswordVisibilityButton(
            isObscured: obscurePassword,
            onPressed: onTogglePassword,
            semanticLabel: obscurePassword ? '비밀번호 보기' : '비밀번호 숨기기',
          ),
        ),
        const SizedBox(height: 22),
        SignupTextField(
          controller: passwordConfirmController,
          label: '비밀번호 확인',
          hintText: '비밀번호를 다시 입력해주세요',
          obscureText: obscurePasswordConfirm,
          onChanged: (value) {
            onChanged(formState.copyWith(passwordConfirm: value));
          },
          suffixIcon: _PasswordVisibilityButton(
            isObscured: obscurePasswordConfirm,
            onPressed: onTogglePasswordConfirm,
            semanticLabel: obscurePasswordConfirm
                ? '비밀번호 확인 보기'
                : '비밀번호 확인 숨기기',
          ),
        ),
        const SizedBox(height: 22),
        SignupTextField(
          controller: nameController,
          label: '이름',
          hintText: '이름을 입력해주세요',
          onChanged: (value) => onChanged(formState.copyWith(name: value)),
        ),
        const SizedBox(height: 22),
        SignupTextField(
          controller: nicknameController,
          label: '닉네임 (선택)',
          hintText: '닉네임을 입력해주세요',
          helperText: '다른 친구들에게 보여질 이름이에요.',
          onChanged: (value) => onChanged(
            formState.copyWith(nickname: value.trim().isEmpty ? null : value),
          ),
        ),
        const SizedBox(height: 22),
        BirthDateSelector(
          year: formState.birthYear,
          month: formState.birthMonth,
          day: formState.birthDay,
          onYearChanged: (value) {
            onChanged(formState.copyWith(birthYear: value));
          },
          onMonthChanged: (value) {
            onChanged(formState.copyWith(birthMonth: value));
          },
          onDayChanged: (value) {
            onChanged(formState.copyWith(birthDay: value));
          },
        ),
      ],
    );
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  final bool isObscured;
  final VoidCallback onPressed;
  final String semanticLabel;

  const _PasswordVisibilityButton({
    required this.isObscured,
    required this.onPressed,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: semanticLabel,
      onPressed: onPressed,
      icon: Icon(
        isObscured ? Icons.visibility : Icons.visibility_off,
        color: const Color(0xFF8E8E88),
      ),
    );
  }
}
