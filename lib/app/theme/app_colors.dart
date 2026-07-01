import 'package:flutter/material.dart';

/// Little Quest의 자연 탐험 컨셉에 맞는 색상 팔레트.
///
/// 이미지에서 추출한 크림/베이지 배경과 식물 녹색을 기반으로 하며,
/// 모든 화면에서 동일한 색상을 사용한다.
abstract final class AppColors {
  // Primary (Deep forest green)
  static const Color primary = Color(0xFF4A6B3E);
  static const Color primaryDark = Color(0xFF3A5A30);
  static const Color primaryLight = Color(0xFF6B8E4E);
  static const Color primarySoft = Color(0xFFE6EFDE);

  // Background (Cream / beige)
  static const Color background = Color(0xFFF7F5E8);
  static const Color backgroundElevated = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF1F0E3);

  // Accent (butterfly / badge)
  static const Color accentYellow = Color(0xFFF2C94C);
  static const Color accentYellowLight = Color(0xFFFFF5D6);
  static const Color accentCoral = Color(0xFFE8A58F);
  static const Color accentCoralLight = Color(0xFFFBE9E3);

  // Text
  static const Color textPrimary = Color(0xFF2D3A2D);
  static const Color textSecondary = Color(0xFF6B7A6B);
  static const Color textTertiary = Color(0xFF9BA89B);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Utility
  static const Color divider = Color(0xFFE6E6DC);
  static const Color shadow = Color(0xFF2D3A2D);
  static const Color error = Color(0xFFD65745);
  static const Color success = Color(0xFF4A6B3E);

  // Discovery card backgrounds
  static const Color leafLight = Color(0xFFE6EFDE);
  static const Color flowerLight = Color(0xFFEDE4F2);
  static const Color pawLight = Color(0xFFF3E9D8);
}
