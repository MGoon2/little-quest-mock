import 'package:flutter/material.dart';

import '../features/account_verification/models/account_verification_method_data.dart';
import '../features/account_verification/widgets/reauthentication_notice_card.dart';

import '../features/account_verification/repositories/account_verification_repository.dart';
import '../features/account_verification/widgets/account_verification_app_bar.dart';
import '../features/account_verification/widgets/account_verification_hero_illustration.dart';
import '../features/account_verification/widgets/account_verification_title_section.dart';
import '../features/account_verification/widgets/password_verification_card.dart';
import '../theme/lq_colors.dart';

/// 이메일/비밀번호 가입자용 계정 확인 화면.
///
/// 개인정보 수정 진입 전 재인증을 처리한다.
/// 재인증 성공 후 10분 동안 개인정보 수정이 허용되며,
/// 실제 서비스에서는 서버에서 재인증 상태를 검증해야 한다.
class AccountVerificationScreen extends StatefulWidget {
  const AccountVerificationScreen({super.key});

  @override
  State<AccountVerificationScreen> createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  final _passwordController = TextEditingController();
  final _repository = const MockAccountVerificationRepository();
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  final methodData = const AccountVerificationMethodData(
      methods: [
        VerificationMethod.password
      ],
    );

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() => _errorMessage = '비밀번호를 입력해 주세요.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final success = await _repository.verifyPassword(password);
      if (!mounted) return;
      if (success) {
        await Navigator.of(context).pushNamed('/profile-edit');
      } else {
        setState(() => _errorMessage = '비밀번호가 올바르지 않아요.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = '연결 상태를 확인하고 다시 시도해 주세요.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const AccountVerificationAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AccountVerificationHeroIllustration(),
              const SizedBox(height: 10),
              const AccountVerificationTitleSection(),
              const SizedBox(height: 20),
              PasswordVerificationCard(
                passwordController: _passwordController,
                obscurePassword: _obscurePassword,
                onToggleObscure: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                onForgotPassword: () {
                  // TODO: password reset page
                },
                onSubmit: _handleSubmit,
                isSubmitting: _isSubmitting,
                errorMessage: _errorMessage,
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
}
