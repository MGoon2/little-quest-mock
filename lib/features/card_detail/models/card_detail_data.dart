/// Holo 등급 단계.
enum HoloGrade { normal, holo, seasonalHolo }

extension HoloGradeX on HoloGrade {
  String get label {
    switch (this) {
      case HoloGrade.normal:
        return 'Normal';
      case HoloGrade.holo:
        return 'Holo';
      case HoloGrade.seasonalHolo:
        return 'Seasonal Holo';
    }
  }

  String get description {
    switch (this) {
      case HoloGrade.normal:
        return '기본 발견';
      case HoloGrade.holo:
        return '관찰 품질 우수';
      case HoloGrade.seasonalHolo:
        return '계절 기록 완료';
    }
  }
}

/// 카드 상세 전체 데이터.
class CardDetailData {
  final String id;
  final String nameKo;
  final String nameEn;
  final String categoryLabel;
  final String subCategoryLabel;
  final HoloGrade currentGrade;
  final String oneLineDescription;
  final DiscoveryRecord discoveryRecord;
  final List<HoloCondition> nextGradeConditions;
  final List<ObservationRecord> observations;
  final bool isFavorite;

  const CardDetailData({
    required this.id,
    required this.nameKo,
    required this.nameEn,
    required this.categoryLabel,
    required this.subCategoryLabel,
    required this.currentGrade,
    required this.oneLineDescription,
    required this.discoveryRecord,
    required this.nextGradeConditions,
    required this.observations,
    this.isFavorite = false,
  });
}

/// 최초 발견 기록.
class DiscoveryRecord {
  final DateTime discoveredAt;
  final String locationName;
  final String memo;
  final String? thumbnailAssetPath;

  const DiscoveryRecord({
    required this.discoveredAt,
    required this.locationName,
    required this.memo,
    this.thumbnailAssetPath,
  });
}

/// 다음 Holo 등급 조건.
class HoloCondition {
  final String label;
  final int current;
  final int required;

  const HoloCondition({
    required this.label,
    required this.current,
    required this.required,
  });

  bool get isCompleted => current >= required;
}

/// 재관찰 기록.
class ObservationRecord {
  final String id;
  final DateTime observedAt;
  final String locationName;
  final String memo;
  final String? thumbnailAssetPath;
  final bool isPrimary;

  const ObservationRecord({
    required this.id,
    required this.observedAt,
    required this.locationName,
    required this.memo,
    this.thumbnailAssetPath,
    this.isPrimary = false,
  });
}
