import '../models/discovery_card.dart';
import '../models/discovery_category.dart';
import 'discovery_fixtures.dart';

/// 발견 카드 데이터 소스 인터페이스.
///
/// 실제 백엔드 API 연동 시 이 인터페이스를 구현한 클래스를 사용한다.
abstract class DiscoveryDataSource {
  Future<List<DiscoveryCard>> fetchByCategory(DiscoveryCategory category);
  Future<List<DiscoveryCardGroup>> fetchAllGrouped();
}

/// 프로덕션 API 연동용 stub.
///
/// 현재는 로컬 fixture를 반환하지만, 추후 HTTP 클라이언트로 교체한다.
class DiscoveryRepository implements DiscoveryDataSource {
  const DiscoveryRepository();

  @override
  Future<List<DiscoveryCard>> fetchByCategory(DiscoveryCategory category) async {
    // TODO: API 연결 시 제거
    if (category == DiscoveryCategory.all) {
      return DiscoveryFixtures.all;
    }
    return DiscoveryFixtures.all
        .where((card) => card.category == category)
        .toList();
  }

  @override
  Future<List<DiscoveryCardGroup>> fetchAllGrouped() async {
    // TODO: API 연결 시 제거
    return DiscoveryFixtures.groups;
  }
}
