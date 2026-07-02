import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_verification_form.dart';

class ParentVerificationPage extends StatefulWidget {
  const ParentVerificationPage({super.key});

  @override
  State<ParentVerificationPage> createState() => _ParentVerificationPageState();
}

class _ParentVerificationPageState extends State<ParentVerificationPage> {
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  String _password = '';
  String _passwordConfirm = '';
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  bool _isSubmitting = false;
  int _selectedMethodIndex = 0;

  bool get _isValid =>
      _password.isNotEmpty &&
      _passwordConfirm.isNotEmpty &&
      _password == _passwordConfirm;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_syncPasswordState);
    _passwordConfirmController.addListener(_syncPasswordState);
  }

  @override
  void dispose() {
    _passwordController
      ..removeListener(_syncPasswordState)
      ..dispose();
    _passwordConfirmController
      ..removeListener(_syncPasswordState)
      ..dispose();
    super.dispose();
  }

  void _syncPasswordState() {
    setState(() {
      _password = _passwordController.text.trim();
      _passwordConfirm = _passwordConfirmController.text.trim();
    });
  }

  Future<void> _handlePasswordSubmit() async {
    if (!_isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    // TODO: 보호자 재인증 API 연결
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    await Navigator.of(context).pushReplacementNamed('/parent/home');
  }

  Future<void> _handleGoogleSubmit() async {
    await _handleSocialSubmit(
      providerLabel: 'Google',
      onConnectApi: () {
        // TODO: Google 보호자 재인증 API 연결
      },
    );
  }

  Future<void> _handleAppleSubmit() async {
    await _handleSocialSubmit(
      providerLabel: 'Apple',
      onConnectApi: () {
        // TODO: Apple 보호자 재인증 API 연결
      },
    );
  }

  Future<void> _handleSocialSubmit({
    required String providerLabel,
    required VoidCallback onConnectApi,
  }) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    onConnectApi();
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$providerLabel 재인증은 API 연동 후 연결합니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: '보호자 확인'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '보호자 확인',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Jua',
                  fontSize: 32,
                  height: 1.15,
                  color: LqColors.deepGreen,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '아이의 정보를 보호하기 위해\n보호자 확인이 필요해요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  height: 1.55,
                  color: LqColors.textDark,
                ),
              ),
              const SizedBox(height: 28),
              ParentSectionCard(
                child: ParentVerificationForm(
                  passwordController: _passwordController,
                  passwordConfirmController: _passwordConfirmController,
                  obscurePassword: _obscurePassword,
                  obscurePasswordConfirm: _obscurePasswordConfirm,
                  isValid: _isValid,
                  isSubmitting: _isSubmitting,
                  selectedMethodIndex: _selectedMethodIndex,
                  onTogglePassword: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  onTogglePasswordConfirm: () {
                    setState(
                      () => _obscurePasswordConfirm = !_obscurePasswordConfirm,
                    );
                  },
                  onMethodChanged: (index) {
                    setState(() => _selectedMethodIndex = index);
                  },
                  onSubmit: _handlePasswordSubmit,
                  onGooglePressed: _handleGoogleSubmit,
                  onApplePressed: _handleAppleSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
