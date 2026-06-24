import '../models/discovery_card.dart';
import '../models/discovery_category.dart';

/// UI 확인용 fixture 데이터.
///
/// 이 파일은 개발/테스트 목적에서만 사용하며, 프로덕션 API 연동 시 제거한다.
abstract final class DiscoveryFixtures {
  static final List<DiscoveryCard> plants = [
    _card('p1', '은행나무', DiscoveryCategory.plant, 4),
    _card('p2', '민들레', DiscoveryCategory.plant, 3),
    _card('p3', '단풍잎', DiscoveryCategory.plant, 5),
    _card('p4', '소나무', DiscoveryCategory.plant, 4),
    _card('p5', '벚꽃', DiscoveryCategory.plant, 3),
    _card('p6', '강아지풀', DiscoveryCategory.plant, 2),
    _card('p7', '토끼풀', DiscoveryCategory.plant, 3),
    _card('p8', '라벤더', DiscoveryCategory.plant, 4),
    _card('p9', '수국', DiscoveryCategory.plant, 5),
    _card('p10', '해바라기', DiscoveryCategory.plant, 4),
    _card('p11', '팬더grass', DiscoveryCategory.plant, 3),
    _card('p12', '무궁화', DiscoveryCategory.plant, 5),
  ];

  static final List<DiscoveryCard> animals = [
    _card('a1', '집고양이', DiscoveryCategory.animal, 4),
    _card('a2', '참새', DiscoveryCategory.animal, 3),
    _card('a3', '다람쥐', DiscoveryCategory.animal, 5),
    _card('a4', '까치', DiscoveryCategory.animal, 4),
    _card('a5', '비둘기', DiscoveryCategory.animal, 3),
  ];

  static final List<DiscoveryCard> insects = [
    _card('i1', '나비', DiscoveryCategory.insect, 5),
    _card('i2', '무당벌레', DiscoveryCategory.insect, 4),
    _card('i3', '개미', DiscoveryCategory.insect, 3),
  ];

  static final List<DiscoveryCard> buildings = [
    _card('b1', '서울숲 정자', DiscoveryCategory.building, 4),
    _card('b2', '나무계단', DiscoveryCategory.building, 3),
    _card('b3', '생태연못', DiscoveryCategory.building, 5),
    _card('b4', '탐험 놀이터', DiscoveryCategory.building, 4),
    _card('b5', '숲속 도서관', DiscoveryCategory.building, 5),
    _card('b6', '야외 무대', DiscoveryCategory.building, 3),
    _card('b7', '연못 다리', DiscoveryCategory.building, 4),
    _card('b8', '전망대', DiscoveryCategory.building, 5),
  ];

  static List<DiscoveryCard> get all => [
        ...plants,
        ...animals,
        ...insects,
        ...buildings,
      ];

  static List<DiscoveryCardGroup> get groups => [
        DiscoveryCardGroup(category: DiscoveryCategory.plant, cards: plants),
        DiscoveryCardGroup(category: DiscoveryCategory.animal, cards: animals),
        DiscoveryCardGroup(category: DiscoveryCategory.insect, cards: insects),
        DiscoveryCardGroup(category: DiscoveryCategory.building, cards: buildings),
      ];

  static DiscoveryCard _card(
    String id,
    String name,
    DiscoveryCategory category,
    int rating,
  ) {
    return DiscoveryCard(
      id: id,
      name: name,
      category: category,
      rating: rating,
      discoveredAt: DateTime(2024, 5, 20),
    );
  }
}
