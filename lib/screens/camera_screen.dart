import 'package:flutter/material.dart';

import '../components/primary_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'analysis_status_screen.dart';

/// 카메라 화면.
///
/// 실제 카메라 기능 연동 전까지는 사진 촬영/선택 플레이스홀더를 제공한다.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('카메라', style: AppTextStyles.titleMedium),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.card,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: '사진 분석하기',
                icon: const Icon(Icons.search, size: 20),
                onPressed: () => _analyze(context),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _analyze(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AnalysisStatusScreen()),
    );
  }
}
