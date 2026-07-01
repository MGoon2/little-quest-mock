# Flutter Structure Audit

## 범위와 기준

- 분석 범위: `lib/` 하위 Dart 파일 전체와 구조 판단에 필요한 `pubspec.yaml`, `analysis_options.yaml`, `test/widget_test.dart`
- 변경 범위: 이 문서는 현재 리팩토링 상태를 추적한다. 구조 변경 시 사실 관계를 갱신하되, 삭제 후보는 별도 문서에 기록한다.
- 판단 기준:
  - Evidence: 현재 파일 구조, import, 클래스명, 라우트, 파일 크기에서 직접 확인한 사실
  - Inference: 위 근거에서 도출한 리팩토링 후보와 위험도 판단

## 1. 현재 폴더 구조 요약

현재 `lib/`에는 총 116개 Dart 파일이 있다.

| 위치 | 파일 수 | 역할 |
| --- | ---: | --- |
| `lib/` | 1 | 앱 엔트리포인트 (`main.dart`) |
| `lib/app/` | 9 | 앱 조립, 라우터, theme token |
| `lib/core/` | 5 | 앱 전체에서 재사용되는 공통 UI 위젯 |
| `lib/screens/` | 12 | 아직 feature로 이동되지 않은 화면 구현 |
| `lib/components/` | 4 | 아직 feature 귀속 판단이 필요한 도메인성 UI 카드 |
| `lib/models/` | 5 | 전역 모델. Discovery, Quest, Plan 관련 데이터가 섞여 있음 |
| `lib/data/` | 2 | Discovery 목록용 fixture/repository |
| `lib/features/` | 78 | 일부 기능의 data/presentation 및 기존 models/widgets/repositories |

현재 feature 폴더는 아래 6개만 존재한다.

| feature | 하위 구성 | 성격 |
| --- | --- | --- |
| `account_verification` | `data/models/`, `data/repositories/`, `presentation/pages/`, `presentation/widgets/` | 목표 feature 구조로 1차 정리됨 |
| `card_detail` | `data/`, `models/`, `widgets/` | 발견 카드 상세 UI, fixture, 상세 모델 |
| `my_page` | `data/datasources/`, `data/models/`, `presentation/pages/`, `presentation/widgets/` | 목표 feature 구조로 1차 정리됨 |
| `profile_edit` | `data/datasources/`, `data/models/`, `presentation/pages/`, `presentation/widgets/` | 목표 feature 구조로 1차 정리됨 |
| `quest_detail` | `data/datasources/`, `data/models/`, `presentation/pages/`, `presentation/widgets/` | 목표 feature 구조로 1차 정리됨 |
| `signup` | `data/models/`, `presentation/pages/`, `presentation/widgets/` | 이메일 회원가입 플로우가 목표 feature 구조로 추가됨 |

Evidence:
- `main.dart`는 `runApp(const LittleQuestApp())`만 수행하고, `LittleQuestApp`은 `lib/app/app.dart`에 있다.
- `lib/app/router/app_router.dart`가 아직 남은 `screens/*`와 이동 완료된 feature page를 import하고 `routes` 및 `onGenerateRoute`를 등록한다.
- theme 파일은 `lib/app/theme/` 아래에 있다.
- 공통 UI 위젯 중 `AppScaffold`, `BottomNavigation`, `PrimaryButton`, `SectionHeader`, `SideMenu`는 `lib/core/widgets/` 아래로 이동했다.
- `quest_detail`, `my_page`, `profile_edit`, `account_verification`, `signup`은 page와 widgets가 `presentation/`, fixture/model/repository가 `data/` 하위 구조로 이동했거나 추가되었다.
- `screens/discovery_card_detail_screen.dart`는 아직 feature `card_detail` 하위 모델/위젯/fixture를 import해서 화면을 조립한다.
- `screens/discovery_card_screen.dart`는 아직 전역 `data/`, `models/`, `components/`를 직접 사용한다.

## 2. 문제점

### 2.1 전역 `screens/`와 `app/router` 사이에 과도기 경계가 남아 있다

Evidence:
- `lib/screens/`에 아직 라우트 화면 12개가 남아 있다.
- `lib/app/router/app_router.dart`는 `screens/`의 라우트 대상 화면을 직접 import한다.
- `quest_detail`은 feature 내부 page로 이동했지만, 일부 화면은 실제 feature 구현의 thin wrapper에 가까운 상태로 `screens/`에 남아 있다.

Inference:
- 라우트 테이블은 app 계층으로 분리되었지만, 실제 page 위치는 아직 전역 `screens/`에 남아 있다.
- 기능별 이동을 시작하면 `app/router/app_router.dart`, 화면 간 `Navigator.push`, 상대 import가 함께 흔들릴 가능성이 높다.

### 2.2 feature 구조와 전역 구조가 섞여 있다

Evidence:
- `quest_detail`, `my_page`, `profile_edit`, `account_verification`, `signup`은 목표 feature 구조에 맞춰 1차 정리되었다.
- `card_detail`은 아직 기존 `lib/features/*`의 위젯/모델/fixture 구조를 사용한다.
- `discovery_card_screen.dart`는 `lib/data/discovery_repository.dart`, `lib/models/discovery_card.dart`, `lib/components/discovery_mini_card.dart`를 사용한다.
- `home_screen.dart`는 전역 `models/discovery_card_item.dart`, `models/quest.dart`, `components/discovery_card.dart`, `components/quest_card.dart`를 사용한다.

Inference:
- 프로젝트가 feature-first 구조로 이동 중이지만 Discovery 목록, Home, Camera/Login/Plan 계열은 아직 전역 폴더에 남아 있다.
- 새 기능을 추가할 때 “전역에 둘지 feature에 둘지” 기준이 불명확해질 수 있다.

### 2.3 색상 토큰이 두 벌이다

Evidence:
- `app/theme/app_colors.dart`는 31개 이상 파일에서 사용된다.
- `app/theme/lq_colors.dart`는 40개 이상 파일에서 사용된다.
- `LqColors` 주석은 “카드 상세/퀘스트 상세 페이지용 색상 토큰”이라고 되어 있지만 실제로 `account_verification`, `my_page`, `profile_edit`, `quest_detail` 등 여러 feature에서 사용된다.

Inference:
- `AppColors`와 `LqColors`의 역할 경계가 흐려졌다.
- 테마 리팩토링 시 화면별 색감 차이가 의도인지, 과도기 산물인지 먼저 결정해야 한다.

### 2.4 데이터/fixture 위치가 일관되지 않다

Evidence:
- `DiscoveryFixtures`와 `DiscoveryRepository`는 전역 `lib/data/`에 있다.
- `MyPageFixture`, `ProfileEditFixture`, `QuestDetailFixture`는 각 feature의 `data/datasources/`로 이동했다.
- `CardDetailFixtures`는 아직 기존 `features/card_detail/data/`에 있다.
- `MockAccountVerificationRepository`는 `features/account_verification/data/repositories/`에 있다.

Inference:
- Discovery만 feature 밖에 남아 있어 backend/API 연동 시 repository 위치와 import 방향이 흔들릴 수 있다.

### 2.5 테스트 커버리지가 구조 리팩토링을 보호하기 어렵다

Evidence:
- `test/widget_test.dart`는 `LittleQuestApp`을 띄우고 웰컴 화면의 두 버튼만 확인한다.
- CodeGraph 기준 주요 화면/fixture에는 별도 covering test가 없다.

Inference:
- 파일 이동이나 import 변경만 해도 컴파일 오류는 잡을 수 있지만, 화면 간 네비게이션/데이터 표시 회귀는 테스트가 거의 보호하지 못한다.

## 3. 중복되거나 역할이 겹치는 패키지/폴더

| 겹치는 지점 | Evidence | 문제 |
| --- | --- | --- |
| `lib/components/` vs `lib/features/*/widgets/` | 범용 UI는 일부 `core/widgets`로 이동했지만, Discovery/Quest/Plan 카드류는 아직 전역 `components`에 있음 | 남은 컴포넌트의 feature 귀속 판단 필요 |
| `lib/models/` vs `lib/features/*/models/` | Discovery/Quest/Plan 일부는 전역, 상세/마이페이지/프로필/계정확인은 feature 내부 | 도메인 모델과 화면 DTO가 섞일 수 있음 |
| `lib/data/` vs `lib/features/*/data/` | Discovery data만 전역, 나머지 fixture는 feature 내부 | repository/fixture 배치 규칙이 다름 |
| `AppColors` vs `LqColors` | 둘 다 `app/theme` 아래에 있고 여러 화면에서 직접 import | 디자인 토큰 변경 시 영향 범위 예측이 어려움 |
| `DiscoveryCard` 모델 vs `DiscoveryCard` 위젯 | `lib/models/discovery_card.dart`와 `lib/components/discovery_card.dart`에 같은 클래스명 존재 | import alias 없이는 충돌 가능성이 높음 |
| `card_detail_screen.dart` vs `discovery_card_detail_screen.dart` | `main.dart`에 `/card-detail`과 `/card-detail-legacy`가 함께 존재 | 현재 canonical 상세와 legacy 상세 경계가 코드에 남아 있음 |

## 4. feature 후보 목록

| 후보 feature | 현재 관련 파일 | 근거와 제안 경계 |
| --- | --- | --- |
| `home` | `screens/home_screen.dart`, `core/widgets/app_scaffold.dart`, `core/widgets/bottom_navigation.dart`, `core/widgets/side_menu.dart`, `components/discovery_card.dart`, `components/quest_card.dart`, `core/widgets/section_header.dart`, `models/discovery_card_item.dart`, `models/quest.dart` | 홈 화면이 샘플 데이터, 배너, 로그, 네비게이션을 모두 포함한다. 홈 전용 카드/데이터는 `features/home` 후보 |
| `discovery` 또는 `discovery_cards` | `screens/discovery_card_screen.dart`, `data/discovery_repository.dart`, `data/discovery_fixtures.dart`, `models/discovery_card.dart`, `models/discovery_category.dart`, `components/discovery_mini_card.dart` | 목록, 카테고리, repository, fixture가 한 도메인으로 묶인다 |
| `card_detail` | `screens/discovery_card_detail_screen.dart`, `features/card_detail/*`, `screens/card_detail_screen.dart` | 이미 feature 폴더가 있으나 화면 wrapper와 legacy 상세가 `screens/`에 남아 있다 |
| `quest_detail` | `features/quest_detail/data/*`, `features/quest_detail/presentation/*` | 목표 feature 구조로 1차 정리 완료 |
| `my_page` | `features/my_page/data/*`, `features/my_page/presentation/*` | 목표 feature 구조로 1차 정리 완료 |
| `profile_edit` | `features/profile_edit/data/*`, `features/profile_edit/presentation/*` | 목표 feature 구조로 1차 정리 완료 |
| `account_verification` | `features/account_verification/data/*`, `features/account_verification/presentation/*` | 목표 feature 구조로 1차 정리 완료 |
| `signup` | `features/signup/data/models/*`, `features/signup/presentation/pages/*`, `features/signup/presentation/widgets/*` | 회원가입 방식 선택과 이메일 회원가입 입력 플로우 |
| `camera_flow` | `screens/camera_screen.dart`, `screens/photo_preview_screen.dart`, `screens/analysis_status_screen.dart`, `screens/discovery_intro_screen.dart` | 사진 촬영, 미리보기, 분석 상태, 발견 intro가 같은 플로우로 보인다 |
| `auth` | `screens/login_screen.dart`, `screens/welcome_screen.dart` | 로그인/웰컴 진입 흐름. 단, welcome은 onboarding으로 분리할 수도 있음 |
| `map` | `screens/map_screen.dart` | 단독 feature 후보. Home/Detail/Analysis에서 라우팅 대상이 될 가능성이 있음 |
| `plan` | `screens/plan_screen.dart`, `models/plan_tier.dart`, `components/plan_card.dart` | 구독/요금제 성격의 독립 feature 후보 |

## 5. core/shared로 이동할 후보

### `core` 후보

앱 전역 정책이나 인프라로 쓰이는 코드:

- `app/router/app_router.dart`: route table은 app 계층으로 분리됨. 이후 feature page 이동에 맞춰 import만 축소하면 된다.
- `app/theme/app_theme.dart`
- `app/theme/app_spacing.dart`
- `app/theme/app_radius.dart`
- `app/theme/app_shadows.dart`
- `app/theme/app_text_styles.dart`
- 색상 토큰은 우선 `AppColors`/`LqColors` 역할을 정리한 뒤 하나의 semantic color 체계로 정리할 후보

### `shared` 후보

여러 feature가 실제로 재사용하는 UI:

- `core/widgets/primary_button.dart`
- `core/widgets/app_scaffold.dart`
- `core/widgets/bottom_navigation.dart`
- `core/widgets/side_menu.dart`
- `core/widgets/section_header.dart`

주의:
- `components/discovery_card.dart`, `components/discovery_mini_card.dart`, `components/quest_card.dart`, `components/plan_card.dart`는 이름상 공통처럼 보이지만 특정 도메인 모델에 묶여 있다. 바로 `shared`로 올리기보다 각 feature 귀속 여부를 먼저 판단하는 편이 안전하다.

### feature 전용으로 남기는 편이 나은 후보

- `features/*/widgets/*SectionCard.dart`
- `features/*/widgets/*AppBar.dart`
- `features/*/data/*Fixture.dart`
- `features/*/models/*Data.dart`

Inference:
- 현재 feature 내부 모델은 대부분 화면 표시용 DTO에 가깝다. 앱 전역 도메인 모델로 승격하기 전 API 계약과 재사용 범위를 먼저 확인해야 한다.

## 6. import 경로 충돌 가능성

### 6.1 같은 클래스명 `DiscoveryCard`

Evidence:
- `lib/models/discovery_card.dart`에 데이터 모델 `class DiscoveryCard`가 있다.
- `lib/components/discovery_card.dart`에 위젯 `class DiscoveryCard extends StatelessWidget`가 있다.

Risk:
- 같은 파일에서 두 타입이 동시에 필요해지면 import alias 없이는 충돌한다.
- CodeGraph도 이름 기반 탐색에서 두 `DiscoveryCard`를 함께 잡아 blast radius가 섞일 수 있다.

Recommendation:
- 리팩토링 시 모델은 `DiscoveryCardModel`, UI는 `DiscoveryCardTile`/`DiscoveryCardWidget`처럼 이름을 분리하거나 import alias 규칙을 명확히 둔다.

### 6.2 상대 import depth 증가

Evidence:
- 기존 feature 위젯들은 `../../../../theme/lq_colors.dart` 같은 깊은 상대 import를 사용했다.
- 현재 theme import는 `package:little_quest/app/theme/...`로 정리되었다.
- 전역 screen은 아직 `../features/...`, `../components/...`, `../models/...` 상대 import를 섞어 사용한다.

Risk:
- theme import 위험은 줄었지만, feature/screen/component/model 간 상대 import 위험은 남아 있다.
- `package:little_quest/...` import로 전환하지 않은 영역에서 대규모 이동을 하면 충돌 탐지가 어렵다.

### 6.3 route name과 screen 파일의 의미 불일치

Evidence:
- `app/router/app_router.dart`에서 `/card-detail`은 `DiscoveryCardDetailScreen`을 사용한다.
- `/card-detail-legacy`는 `CardDetailScreen(item: DiscoveryCardItem)`을 사용한다.

Risk:
- `card_detail` feature를 정리할 때 legacy route가 실제로 필요한지 확인하지 않으면 잘못된 상세 화면으로 연결될 수 있다.

### 6.4 색상 import의 의미 충돌

Evidence:
- 전역/초기 화면은 주로 `AppColors`를 사용한다.
- feature 화면과 상세 화면은 주로 `LqColors`를 사용한다.

Risk:
- 단순 통합 시 화면별 visual regression 가능성이 있다.

## 7. 리팩토링 우선순위

### P0: 리팩토링 전 안전장치

1. 라우트 smoke/widget test를 추가한다.
2. `flutter analyze`가 깨끗한지 기준선을 잡는다. 현재 app 계층 분리 후 `flutter analyze`는 통과했다.
3. `/card-detail`과 `/card-detail-legacy`의 의도를 확인한다.
4. `DiscoveryCard` 모델/위젯 이름 충돌을 먼저 해소하거나 alias 규칙을 정한다.

### P1: 경계가 이미 뚜렷한 feature부터 정리

1. `quest_detail`, `my_page`, `profile_edit`, `account_verification`, `signup`은 1차 이동 완료.
2. 다음 안전 후보는 `card_detail`이지만 `/card-detail`과 `/card-detail-legacy`의 의도 확인이 선행되어야 한다.

### P2: Discovery 도메인 정리

1. `lib/data/discovery_*`와 `lib/models/discovery_*`, `components/discovery_mini_card.dart`를 `features/discovery` 또는 `features/discovery_cards` 후보로 묶는다.
2. `card_detail`과 Discovery 목록의 관계를 명확히 한다.
3. 모델/위젯 이름 충돌을 함께 해결한다.

### P3: Home과 공통 UI 분리

1. `home_screen.dart`의 fixture성 리스트, 배너 데이터, 로그 데이터를 `features/home/data` 또는 model로 분리한다.
2. `app_scaffold`, `bottom_navigation`, `side_menu`, `primary_button`, `section_header`를 `shared/widgets` 후보로 분류한다.
3. 홈 전용 discovery/quest 카드가 shared로 남아야 하는지 feature 전용인지 재판단한다.

### P4: Camera/Auth/Plan/Map 후보 정리

1. `camera_flow`: `camera_screen`, `photo_preview_screen`, `analysis_status_screen`, `discovery_intro_screen`
2. `auth/onboarding`: `welcome_screen`, `login_screen`
3. `plan`: `plan_screen`, `plan_tier`, `plan_card`
4. `map`: `map_screen`

### P5: theme 정리

1. `AppColors`와 `LqColors`의 역할을 문서화한다.
2. 한 번에 통합하지 말고 feature별 시각 회귀를 확인하면서 정리한다.

## 8. 위험도 높은 파일 목록

| 위험도 | 파일 | 근거 | 주요 위험 |
| --- | --- | --- | --- |
| 높음 | `lib/screens/home_screen.dart` | 569줄, 샘플 데이터/배너/로그/네비게이션/하위 private class 포함, 3개 파일에서 사용 | Home feature 분리 시 네비게이션과 카드 모델이 동시에 흔들림 |
| 높음 | `lib/screens/discovery_card_screen.dart` | 431줄, repository/model/component/theme를 전역에서 직접 사용 | Discovery feature 이동 시 import, 데이터 로딩, grid/list UI가 함께 영향 |
| 높음 | `lib/app/router/app_router.dart` | 전체 route table과 legacy route 보유 | 화면 이동 시 라우트 등록 누락 또는 잘못된 상세 화면 연결 가능 |
| 높음 | `lib/models/discovery_card.dart` | `DiscoveryCard` 데이터 모델명 | 위젯 `DiscoveryCard`와 이름 충돌 |
| 높음 | `lib/components/discovery_card.dart` | `DiscoveryCard` 위젯명 | 모델 `DiscoveryCard`와 이름 충돌 |
| 중간-높음 | `lib/app/theme/app_colors.dart` | 31개 이상 파일에서 사용 | 색상 token 변경 시 넓은 화면 영향 |
| 중간-높음 | `lib/app/theme/lq_colors.dart` | 40개 이상 파일에서 사용 | feature 화면 전반 visual regression 가능 |
| 중간 | `lib/screens/camera_screen.dart` | 457줄, 촬영 화면과 preview route 연결 | camera flow 분리 시 상태/라우팅 영향 |
| 중간 | `lib/screens/login_screen.dart` | 343줄, 로그인 완료 후 route 전환 | auth/onboarding 분리 시 진입 흐름 영향 |
| 중간 | `lib/core/widgets/side_menu.dart` | 252줄, 전역 메뉴와 route 연결 | core 공통 위젯으로 이동했지만 navigation dependency 영향이 남아 있음 |
| 중간 | `lib/screens/photo_preview_screen.dart` | 254줄, analysis status로 pushReplacement | camera flow 이동 시 route 흐름 영향 |
| 중간 | `lib/screens/plan_screen.dart` | 222줄, `PlanTier`, `PlanCard`와 결합 | plan feature 분리 후보지만 현재 전역 model/component에 의존 |
| 중간 | `lib/screens/discovery_card_detail_screen.dart` | feature `card_detail`의 fixture/model/widgets를 조립 | canonical detail screen으로 보이며 legacy와 함께 정리 필요 |
| 중간 | `lib/features/account_verification/presentation/pages/account_verification_screen_password.dart` | mock repository 직접 생성 | 실제 인증 연동 시 repository 주입 구조 영향 |

## 결론

현재 구조는 feature-first로 일부 이동된 과도기 상태다. `features/*` 내부가 비교적 잘 정리된 영역과, `screens/components/models/data` 전역 구조에 남은 영역이 공존한다.

이미 1차 정리된 지점은 `quest_detail`, `my_page`, `profile_edit`, `account_verification`, `signup`이다. 다음으로 건드릴 만한 지점은 `card_detail`이지만, 가장 조심해야 할 지점은 `home`, `discovery`, `card_detail`, theme 색상 토큰이다. 특히 `DiscoveryCard` 이름 충돌과 `/card-detail-legacy` route는 리팩토링 전에 의도를 확인해야 한다.
