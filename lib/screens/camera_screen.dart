import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'analysis_status_screen.dart';

/// 카메라 촬영 화면.
///
/// 실제 카메라 프리뷰는 `camera` 패키지로 연동할 수 있으며,
/// 현재는 녹색 보케 배경 위에 UI 오버레이만 구성한다.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String _selectedCategory = '식물';
  final String _mode = '식물 인식 모드';
  bool _flashOn = false;

  final List<String> _categories = ['식물', '동물', '곤충', '건축물'];
  final List<IconData> _categoryIcons = [
    Icons.eco,
    Icons.pets,
    Icons.bug_report,
    Icons.account_balance,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 카메라 프리뷰 플레이스홀더
          const _CameraPreviewPlaceholder(),
          // 상단 컨트롤
          _buildTopControls(),
          // 중앙 발견 배너
          _buildDiscoveryBanner(),
          // 포커스 프레임
          _buildFocusFrame(),
          // 오른쪽 카테고리 선택
          _buildCategoryPanel(),
          // 하단 컨트롤
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    final rightItems = [
      _TopItem(icon: Icons.flash_on, label: '플래시', onTap: () => setState(() => _flashOn = !_flashOn)),
      _TopItem(icon: Icons.timer, label: '타이머', onTap: () {}),
      _TopItem(icon: Icons.bolt, label: '라이브', onTap: () {}),
      _TopItem(icon: Icons.settings, label: '설정', onTap: () {}),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 28,
              ),
            ),
            Row(
              children: rightItems
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        onTap: item.onTap,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              color: item.label == '플래시' && _flashOn
                                  ? AppColors.accentYellow
                                  : Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryBanner() {
    return Positioned(
      top: 110,
      left: AppSpacing.screenPadding,
      right: AppSpacing.screenPadding,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.eco, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  '자연을 발견해보세요!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '식물, 동물, 곤충, 건축물 모두 좋아요.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusFrame() {
    return Center(
      child: SizedBox(
        width: 260,
        height: 320,
        child: Stack(
          children: [
            // 좌상단
            Positioned(
              top: 0,
              left: 0,
              child: _corner(),
            ),
            // 우상단
            Positioned(
              top: 0,
              right: 0,
              child: Transform.rotate(
                angle: 1.5708,
                child: _corner(),
              ),
            ),
            // 좌하단
            Positioned(
              bottom: 0,
              left: 0,
              child: Transform.rotate(
                angle: -1.5708,
                child: _corner(),
              ),
            ),
            // 우하단
            Positioned(
              bottom: 0,
              right: 0,
              child: Transform.rotate(
                angle: 3.14159,
                child: _corner(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _corner() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white, width: 3),
          left: BorderSide(color: Colors.white, width: 3),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildCategoryPanel() {
    return Positioned(
      right: AppSpacing.screenPadding,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.9)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _categoryIcons[index],
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.96),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.lg),
              // 모드/줌/필터
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildModeChip(_mode, Icons.keyboard_arrow_down),
                  const SizedBox(width: AppSpacing.lg),
                  _buildZoomChip('1.0x'),
                  const SizedBox(width: AppSpacing.lg),
                  _buildIconChip(Icons.eco),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              // 탭 바
              _buildTabBar(),
              const SizedBox(height: AppSpacing.lg),
              // 촬영 컨트롤
              _buildCaptureControls(),
              const SizedBox(height: AppSpacing.md),
              // 팁 배너
              _buildTipBanner(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          const Icon(Icons.eco, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.captionMedium.copyWith(
              color: Colors.white,
            ),
          ),
          Icon(icon, size: 16, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildZoomChip(String label) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.backgroundElevated,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.captionMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildIconChip(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      _TabItem(icon: Icons.local_florist, label: '탐험'),
      _TabItem(icon: Icons.camera_alt, label: '사진', isSelected: true),
      _TabItem(icon: Icons.flag, label: '퀘스트'),
      _TabItem(icon: Icons.edit, label: '메모'),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tabs.map((tab) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: tab.isSelected
                  ? BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: AppShadows.card,
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    tab.icon,
                    size: 18,
                    color: tab.isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tab.label,
                    style: AppTextStyles.captionMedium.copyWith(
                      color: tab.isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCaptureControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 앨범
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/login_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '앨범',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          // 촬영 버튼
          GestureDetector(
            onTap: () => _analyze(context),
            child: Container(
              width: 88,
              height: 88,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppShadows.soft,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // 바로 인식
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppShadows.card,
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '바로 인식',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.accentYellowLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb,
              size: 18,
              color: AppColors.accentYellow,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '가까이에서 선명하게, 여러 각도에서 찍어보세요!',
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'AI가 더 정확하게 분석할 수 있어요.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: AppColors.textSecondary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _analyze(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AnalysisStatusScreen()),
    );
  }
}

class _CameraPreviewPlaceholder extends StatelessWidget {
  const _CameraPreviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8FB573),
            Color(0xFF5A8F4E),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 흐릿한 보케 원
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 잎사귀 형태의 포커스 가이드
          Center(
            child: Opacity(
              opacity: 0.12,
              child: Icon(
                Icons.eco,
                size: 280,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _TopItem({required this.icon, required this.label, required this.onTap});
}

class _TabItem {
  final IconData icon;
  final String label;
  final bool isSelected;

  _TabItem({required this.icon, required this.label, this.isSelected = false});
}
