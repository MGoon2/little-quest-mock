import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

enum ParentSocialProvider { google, apple }

/// 부모 재인증용 소셜 버튼.
class ParentSocialAuthButton extends StatelessWidget {
  final ParentSocialProvider provider;
  final VoidCallback? onPressed;

  const ParentSocialAuthButton({
    super.key,
    required this.provider,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: LqColors.cardCream,
          foregroundColor: LqColors.textDark,
          side: const BorderSide(color: LqColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: _iconSize, color: _iconColor),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                _label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (provider) {
      case ParentSocialProvider.google:
        return Icons.g_mobiledata;
      case ParentSocialProvider.apple:
        return Icons.apple;
    }
  }

  double get _iconSize {
    switch (provider) {
      case ParentSocialProvider.google:
        return 30;
      case ParentSocialProvider.apple:
        return 23;
    }
  }

  Color get _iconColor {
    switch (provider) {
      case ParentSocialProvider.google:
        return Colors.red;
      case ParentSocialProvider.apple:
        return Colors.black;
    }
  }

  String get _label {
    switch (provider) {
      case ParentSocialProvider.google:
        return 'Google로 계속하기';
      case ParentSocialProvider.apple:
        return 'Apple로 계속하기';
    }
  }
}
