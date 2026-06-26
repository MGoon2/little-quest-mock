import 'package:flutter/material.dart';

/// 퀘스트 종류.
enum QuestType {
  daily,
  weekly,
  seasonal,
  place,
  collectionSet,
  revisit,
}

/// 퀘스트 미션 종류.
enum QuestMissionType {
  createCard,
  writeMemo,
  recordLocation,
}

extension QuestMissionTypeX on QuestMissionType {
  IconData get icon {
    switch (this) {
      case QuestMissionType.createCard:
        return Icons.camera_alt;
      case QuestMissionType.writeMemo:
        return Icons.edit_note;
      case QuestMissionType.recordLocation:
        return Icons.location_on;
    }
  }
}

/// 퀘스트 대상 아이템.
class QuestTargetItem {
  final String id;
  final String name;
  final bool completed;
  final String? completedAt;
  final int currentCount;
  final int requiredCount;
  final String? imageAssetPath;

  const QuestTargetItem({
    required this.id,
    required this.name,
    this.completed = false,
    this.completedAt,
    this.currentCount = 0,
    this.requiredCount = 1,
    this.imageAssetPath,
  });
}

/// 퀘스트 미션 아이템.
class QuestMissionItem {
  final String id;
  final String title;
  final String description;
  final int rewardPoint;
  final bool completed;
  final QuestMissionType type;

  const QuestMissionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoint,
    this.completed = false,
    required this.type,
  });
}

/// 퀘스트 상세 데이터.
class QuestDetailData {
  final String id;
  final QuestType type;
  final String badgeLabel;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int participantCount;
  final int requiredCount;
  final int completedCount;
  final String rewardLabel;
  final List<QuestTargetItem> targetItems;
  final List<QuestMissionItem> missions;

  QuestDetailData({
    required this.id,
    required this.type,
    required this.badgeLabel,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.participantCount,
    required this.requiredCount,
    required this.completedCount,
    required this.rewardLabel,
    required this.targetItems,
    required this.missions,
  });

  double get progressRatio {
    if (requiredCount == 0) return 0;
    return completedCount / requiredCount;
  }

  int get progressPercent => (progressRatio * 100).round();
}
