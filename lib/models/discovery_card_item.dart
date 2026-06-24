import 'package:flutter/material.dart';

/// 나의 발견 카드 아이템 (식물, 곤충, 동물 등).
class DiscoveryCardItem {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final Color backgroundColor;
  final bool isNew;
  final String? subtitle;

  const DiscoveryCardItem({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.backgroundColor,
    this.isNew = false,
    this.subtitle,
  });
}
