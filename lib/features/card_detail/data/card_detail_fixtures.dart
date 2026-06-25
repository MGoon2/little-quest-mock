import '../models/card_detail_data.dart';

/// UI 확인용 fixture 데이터.
///
/// 백엔드 API 연결 후에는 실제 repository에서 동일한 모델을 반환하도록 교체한다.
final sampleCardDetail = CardDetailData(
  id: 'ginkgo-001',
  nameKo: '은행나무',
  nameEn: 'Ginkgo biloba',
  categoryLabel: '식물',
  subCategoryLabel: '나무',
  currentGrade: HoloGrade.holo,
  oneLineDescription: '은행나무는 약 2억 7천만 년 전부터 지구에 살아온 아주 오래된 나무예요.',
  discoveryRecord: DiscoveryRecord(
    discoveredAt: DateTime(2024, 5, 20, 10, 32),
    locationName: '서울숲 가족마당',
    memo: '멋진 부채 모양의 잎을 가져왔어요!',
    thumbnailAssetPath: null,
  ),
  nextGradeConditions: [
    HoloCondition(label: '다른 계절 관찰', current: 1, required: 2),
    HoloCondition(label: '다른 장소 관찰', current: 0, required: 2),
    HoloCondition(label: '관찰 메모 추가', current: 1, required: 1),
  ],
  observations: [
    ObservationRecord(
      id: 'obs-001',
      observedAt: DateTime(2024, 5, 20),
      locationName: '서울숲',
      memo: '잎이 연두색이고 아주 싱그러워요!',
      thumbnailAssetPath: null,
      isPrimary: true,
    ),
    ObservationRecord(
      id: 'obs-002',
      observedAt: DateTime(2024, 11, 2),
      locationName: '서울숲',
      memo: '노랗게 물든 잎이 정말 아름다워요.',
      thumbnailAssetPath: null,
      isPrimary: false,
    ),
    ObservationRecord(
      id: 'obs-003',
      observedAt: DateTime(2025, 4, 6),
      locationName: '서울숲',
      memo: '새로운 잎눈이 보였어요!',
      thumbnailAssetPath: null,
      isPrimary: false,
    ),
  ],
  isFavorite: false,
);
