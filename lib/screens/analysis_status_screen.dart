import 'package:flutter/material.dart';

import '../components/primary_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'camera_screen.dart';
import 'discovery_card_screen.dart';

/// AI 분석 상태 화면.
class AnalysisStatusScreen extends StatefulWidget {
  const AnalysisStatusScreen({super.key});

  @override
  State<AnalysisStatusScreen> createState() => _AnalysisStatusScreenState();
}

class _AnalysisStatusScreenState extends State<AnalysisStatusScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _step = 0;

  final List<String> _steps = [
    '사진에서 대상을 찾는 중...',
    '종을 분석하는 중...',
    '안전 정보를 확인하는 중...',
    '도감 카드를 만들어요!',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _simulateAnalysis();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _simulateAnalysis() async {
    for (var i = 0; i < _steps.length - 1; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) setState(() => _step = i + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildAnimatedIcon(),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'AI가 열심히 분석 중이에요',
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _steps[_step],
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildProgressIndicator(),
              const Spacer(),
              if (_step == _steps.length - 1)
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: '카드 더 만들기',
                        isSecondary: true,
                        icon: const Icon(Icons.camera_alt, size: 20),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const CameraScreen(),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: '카드 확인하기',
                        icon: const Icon(Icons.style, size: 20),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const DiscoveryCardScreen(),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Transform.rotate(
            angle: _controller.value * 2 * 3.14159,
            child: const Icon(
              Icons.local_florist,
              size: 56,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: LinearProgressIndicator(
          value: (_step + 1) / _steps.length,
          backgroundColor: AppColors.surface,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
    );
  }
}
