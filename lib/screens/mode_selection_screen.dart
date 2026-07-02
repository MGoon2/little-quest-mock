import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 퀘스트 시작 전 아이 모드와 부모 모드를 선택하는 랜딩 화면.
class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: AppBar(
        backgroundColor: LqColors.cream,
        elevation: 0,
        leading: IconButton(
          tooltip: '뒤로가기',
          icon: const Icon(Icons.arrow_back, color: LqColors.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.lg,
            AppSpacing.screenPadding,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: LqColors.cardCream,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: LqColors.border),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _ModeIllustration(),
                          const SizedBox(height: AppSpacing.xxl),
                          Text(
                            '어떤 모드로 시작할까요?',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: LqColors.deepGreen,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '아이 모드는 탐험을 시작해요.\n부모 모드는 기록을 관리해요.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              height: 1.5,
                              color: LqColors.textSubtle,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          _ModeButton(
                            icon: Icons.explore_outlined,
                            label: '아이 모드',
                            description: '퀘스트와 탐험을 이어가요',
                            onTap: () => Navigator.of(
                              context,
                            ).pushReplacementNamed('/home'),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _ModeButton(
                            icon: Icons.family_restroom,
                            label: '부모 모드',
                            description: '아이의 정보와 기록을 관리해요',
                            isPrimary: false,
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed('/parent/entry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeIllustration extends StatelessWidget {
  const _ModeIllustration();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '아이 모드와 부모 모드를 선택하는 안내 그림',
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: LqColors.softGreen,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 24,
              bottom: 28,
              child: _LeafBubble(
                size: 54,
                color: LqColors.lightGreen,
                icon: Icons.eco_outlined,
              ),
            ),
            Positioned(
              right: 22,
              top: 24,
              child: _LeafBubble(
                size: 46,
                color: LqColors.warning,
                icon: Icons.auto_awesome_outlined,
              ),
            ),
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: LqColors.cardCream,
                shape: BoxShape.circle,
                border: Border.all(color: LqColors.border),
                boxShadow: AppShadows.card,
              ),
              child: const Icon(
                Icons.hiking_outlined,
                size: 44,
                color: LqColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeafBubble extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;

  const _LeafBubble({
    required this.size,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: LqColors.mutedGreen, size: size * 0.52),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary ? LqColors.primaryGreen : Colors.white;
    final foregroundColor = isPrimary ? Colors.white : LqColors.deepGreen;

    return Semantics(
      button: true,
      label: label,
      hint: description,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isPrimary ? LqColors.primaryGreen : LqColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: foregroundColor, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          color: foregroundColor,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: isPrimary
                              ? Colors.white.withValues(alpha: 0.82)
                              : LqColors.textSubtle,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: foregroundColor, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
