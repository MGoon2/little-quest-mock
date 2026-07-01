import 'package:flutter/material.dart';

/// 이미지 카드와 FAB의 부드러운 그림자 토큰.
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0D2D3A2D), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(color: Color(0x1A2D3A2D), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> soft = [
    BoxShadow(color: Color(0x082D3A2D), blurRadius: 16, offset: Offset(0, 6)),
  ];
}
