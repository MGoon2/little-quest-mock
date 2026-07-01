import 'discovery_category.dart';

/// 발견 카드 도감 아이템.
class DiscoveryCard {
  final String id;
  final String name;
  final DiscoveryCategory category;
  final int rating; // 1~5
  final DateTime discoveredAt;
  final String? imageUrl;

  const DiscoveryCard({
    required this.id,
    required this.name,
    required this.category,
    this.rating = 1,
    required this.discoveredAt,
    this.imageUrl,
  });
}

/// 카테고리별 그룹화된 발견 카드 목록.
class DiscoveryCardGroup {
  final DiscoveryCategory category;
  final List<DiscoveryCard> cards;

  const DiscoveryCardGroup({required this.category, required this.cards});
}
