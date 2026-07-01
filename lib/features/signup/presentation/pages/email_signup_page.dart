import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/signup/data/models/email_signup_form_state.dart';
import 'package:little_quest/features/signup/presentation/widgets/email_signup_app_bar.dart';
import 'package:little_quest/features/signup/presentation/widgets/email_signup_form.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_agreement_section.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_dimensions.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_next_button.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_step_indicator.dart';

class EmailSignupPage extends StatefulWidget {
  const EmailSignupPage({super.key});

  @override
  State<EmailSignupPage> createState() => _EmailSignupPageState();
}

class _EmailSignupPageState extends State<EmailSignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();

  var _formState = const EmailSignupFormState();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            SignupDimensions.screenPadding,
            8,
            SignupDimensions.screenPadding,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const EmailSignupAppBar(),
              const SizedBox(height: 28),
              const SignupStepIndicator(currentStep: 1),
              const SizedBox(height: 32),
              EmailSignupForm(
                emailController: _emailController,
                passwordController: _passwordController,
                passwordConfirmController: _passwordConfirmController,
                nameController: _nameController,
                nicknameController: _nicknameController,
                formState: _formState,
                obscurePassword: _obscurePassword,
                obscurePasswordConfirm: _obscurePasswordConfirm,
                onTogglePassword: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                onTogglePasswordConfirm: () {
                  setState(() {
                    _obscurePasswordConfirm = !_obscurePasswordConfirm;
                  });
                },
                onChanged: _updateFormState,
              ),
              const SizedBox(height: 24),
              SignupAgreementSection(
                agreedTerms: _formState.agreedTerms,
                agreedPrivacy: _formState.agreedPrivacy,
                onTermsChanged: (value) {
                  _updateFormState(_formState.copyWith(agreedTerms: value));
                },
                onPrivacyChanged: (value) {
                  _updateFormState(_formState.copyWith(agreedPrivacy: value));
                },
                onTermsView: () {
                  // TODO: terms detail page or bottom sheet
                },
                onPrivacyView: () {
                  // TODO: privacy policy detail page or bottom sheet
                },
              ),
              const SizedBox(height: 28),
              SignupNextButton(
                enabled: _formState.isValid,
                onPressed: _handleNext,
              ),
              const SizedBox(height: 22),
              const _SignupSecureFooterText(),
            ],
          ),
        ),
      ),
    );
  }

  void _updateFormState(EmailSignupFormState nextState) {
    setState(() => _formState = nextState);
  }

  void _handleNext() {
    if (!_formState.isValid) return;

    // TODO: validate form with backend constraints.
    // TODO: call signup pre-register API.
    // TODO: EmailVerificationPage로 이동.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('이메일 인증 단계는 API 연동 후 연결합니다.')));
  }
}

class _SignupSecureFooterText extends StatelessWidget {
  const _SignupSecureFooterText();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 18, color: LqColors.textSubtle),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            '안전한 환경에서 정보를 보호해요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              height: 1.4,
              color: LqColors.textSubtle,
            ),
          ),
        ),
      ],
    );
  }
}
