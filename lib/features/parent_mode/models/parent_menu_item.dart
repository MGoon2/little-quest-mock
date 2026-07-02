import 'package:flutter/material.dart';

enum ParentMenuType {
  privacyConsent,
  discoveryRecord,
  locationRecord,
  subscription,
  notification,
  dataManagement,
  settings,
}

/// 부모 모드 홈 메뉴 항목.
class ParentMenuItem {
  final String title;
  final String description;
  final IconData icon;
  final ParentMenuType type;

  const ParentMenuItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
  });
}
