import '../models/quest_detail_data.dart';

/// UI 확인용 퀘스트 상세 fixture 데이터.
///
/// 이 파일은 개발/테스트 목적으로만 사용하며, 실제 API 연동 시 제거한다.
abstract final class QuestDetailFixture {
  static final QuestDetailData springPlants = QuestDetailData(
    id: 'spring-plants-2024',
    type: QuestType.seasonal,
    badgeLabel: '시즌 퀘스트',
    title: '봄을 알리는\n식물 친구들',
    description: '봄에 만날 수 있는 식물 5종을 발견하고 카드로 모아봐요!',
    startDate: DateTime(2024, 3, 1),
    endDate: DateTime(2024, 5, 31),
    participantCount: 1248,
    requiredCount: 5,
    completedCount: 3,
    rewardLabel: '골드 홀로 카드 팩 1개',
    targetItems: [
      const QuestTargetItem(
        id: 'dandelion',
        name: '민들레',
        completed: true,
        completedAt: '2024-03-12',
        currentCount: 1,
        requiredCount: 1,
      ),
      const QuestTargetItem(
        id: 'forsythia',
        name: '개나리',
        completed: true,
        completedAt: '2024-03-18',
        currentCount: 1,
        requiredCount: 1,
      ),
      const QuestTargetItem(
        id: 'violet',
        name: '제비꽃',
        completed: true,
        completedAt: '2024-03-25',
        currentCount: 1,
        requiredCount: 1,
      ),
      const QuestTargetItem(
        id: 'cornus',
        name: '산수유',
        currentCount: 0,
        requiredCount: 1,
      ),
      const QuestTargetItem(
        id: 'azalea',
        name: '진달래',
        currentCount: 0,
        requiredCount: 1,
      ),
    ],
    missions: const [
      QuestMissionItem(
        id: 'mission-create-card',
        title: '식물을 발견하고 카드로 기록하기',
        description: '봄 식물을 사진으로 찍어 카드로 만들어봐요.',
        rewardPoint: 100,
        completed: true,
        type: QuestMissionType.createCard,
      ),
      QuestMissionItem(
        id: 'mission-write-memo',
        title: '관찰 메모 남기기',
        description: '식물의 특징이나 느낌을 메모로 남겨봐요.',
        rewardPoint: 50,
        completed: true,
        type: QuestMissionType.writeMemo,
      ),
      QuestMissionItem(
        id: 'mission-record-location',
        title: '발견 장소 기록하기',
        description: '식물을 발견한 장소를 지도에 기록해봐요.',
        rewardPoint: 50,
        completed: false,
        type: QuestMissionType.recordLocation,
      ),
    ],
  );
}
