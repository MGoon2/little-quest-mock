import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Little Quest의 타이포그래피 스케일.
///
/// 모든 폰트는 pubspec.yaml에 번들링하여 CDN 의존 없이 동작한다.
/// - 영문 로고: Fredoka Bold
/// - 한글 타이틀/헤딩 문구: Jua
/// - 앱 본문/UI: Pretendard
abstract final class AppTextStyles {
  // 본문/UI 기본 폰트. Pretendard는 pubspec에 번들링한 에셋 폰트.
  static TextStyle get _base => const TextStyle(fontFamily: 'Pretendard');
  // 한글 타이틀/헤딩용 장식 폰트.
  static TextStyle get _display => const TextStyle(fontFamily: 'Jua');
  // 영문 로고용 폰트.
  static TextStyle get _logo =>
      const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w700);

  /// 영문 로고 전용 스타일. AppBar의 "Little Quest" 타이틀 등에 사용.
  static TextStyle get logo => _logo.copyWith(
    fontSize: 20,
    color: AppColors.primary,
    letterSpacing: -0.3,
  );

  static TextStyle get display => _display.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get titleLarge => _display.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get titleMedium => _display.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle get titleSmall => _display.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle get heading => _display.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle get body => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle get bodyMedium => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle get caption => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: -0.2,
  );

  static TextStyle get captionMedium => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: -0.2,
  );

  static TextStyle get button => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textInverse,
    letterSpacing: -0.2,
  );

  static TextStyle get label => _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textInverse,
    letterSpacing: 0.2,
  );
}
