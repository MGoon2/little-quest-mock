import 'package:flutter/material.dart';

/// 최근 관찰 기록 아이템.
class RecentObservationItem {
  final String id;
  final String name;
  final String observedAt;
  final String? imageAssetPath;

  const RecentObservationItem({
    required this.id,
    required this.name,
    required this.observedAt,
    this.imageAssetPath,
  });
}

/// 배지 아이템.
class BadgeItem {
  final String id;
  final String label;
  final bool unlocked;
  final IconData icon;

  const BadgeItem({
    required this.id,
    required this.label,
    required this.unlocked,
    required this.icon,
  });
}

/// 마이페이지 데이터.
class MyPageData {
  final String greetingName;
  final String levelName;
  final int currentExp;
  final int nextLevelRequiredExp;
  final int cardCount;
  final int observationCount;
  final int questCount;
  final int likeCount;
  final int weeklyDiscoveryCount;
  final int weeklyExp;
  final List<RecentObservationItem> recentObservations;
  final List<BadgeItem> badges;

  const MyPageData({
    required this.greetingName,
    required this.levelName,
    required this.currentExp,
    required this.nextLevelRequiredExp,
    required this.cardCount,
    required this.observationCount,
    required this.questCount,
    required this.likeCount,
    required this.weeklyDiscoveryCount,
    required this.weeklyExp,
    required this.recentObservations,
    required this.badges,
  });

  double get progressRatio {
    if (nextLevelRequiredExp == 0) return 0;
    return currentExp / nextLevelRequiredExp;
  }

  int get remainingExp => nextLevelRequiredExp - currentExp;
}
