import 'package:flutter/material.dart';

import '../models/my_page_data.dart';

/// UI 확인용 마이페이지 fixture 데이터.
///
/// 이 파일은 개발/테스트 목적으로만 사용하며, 실제 API 연동 시 제거한다.
abstract final class MyPageFixture {
  static const MyPageData sample = MyPageData(
    greetingName: '탐험가',
    levelName: '새싹 탐험가',
    currentExp: 80,
    nextLevelRequiredExp: 200,
    cardCount: 128,
    observationCount: 56,
    questCount: 12,
    likeCount: 32,
    weeklyDiscoveryCount: 7,
    weeklyExp: 230,
    recentObservations: [
      RecentObservationItem(
        id: 'violet',
        name: '제비꽃',
        observedAt: '2024-05-20',
      ),
      RecentObservationItem(
        id: 'forsythia',
        name: '개나리',
        observedAt: '2024-05-18',
      ),
      RecentObservationItem(
        id: 'ginkgo',
        name: '은행나무',
        observedAt: '2024-05-15',
      ),
    ],
    badges: [
      BadgeItem(
        id: 'first',
        label: '첫 발견',
        unlocked: true,
        icon: Icons.eco,
      ),
      BadgeItem(
        id: 'observe',
        label: '관찰왕',
        unlocked: true,
        icon: Icons.search,
      ),
      BadgeItem(
        id: 'memo',
        label: '메모왕',
        unlocked: true,
        icon: Icons.assignment,
      ),
      BadgeItem(
        id: 'season',
        label: '계절 탐험가',
        unlocked: false,
        icon: Icons.lock,
      ),
    ],
  );
}
