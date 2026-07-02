# Little Quest New Architecture Analize

> 작성 목적: 현재 목업 기반 Little Quest Flutter 프로젝트의 최신 구조를 백엔드 연동 준비 관점에서 다시 조사하고, 기존 구조 문서가 놓친 신규 feature와 mock 접점을 별도 스냅샷으로 남긴다.
>
> 범위: `lib/`, `test/`, `pubspec.yaml`, 기존 `docs/flutter-*.md`, `docs/main-feature-integration-plan.md`
>
> 주의: 파일명은 요청에 따라 `analize` 표기를 그대로 사용한다.

## 1. 현재 요약

현재 프로젝트는 feature-first 구조로 이동 중인 과도기 상태다. `main.dart`는 앱 실행만 담당하고, 앱 조립은 `lib/app/app.dart`, named route 목록은 `lib/app/router/app_router.dart`로 분리되어 있다. 그러나 Home, Discovery 목록, Auth/Login, Camera flow, Map, Plan 화면은 아직 `lib/screens/`에 남아 있고, Discovery 목록 데이터는 전역 `lib/data/`, `lib/models/`, `lib/components/`에 남아 있다.

최신 구조에서 가장 큰 변화는 `features/parent_mode`가 추가되어 보호자 확인, 아이 정보, 개인정보/동의, 탐험 기록, 위치 기록, 구독, 데이터 삭제, 설정 화면을 한 feature 안에 포함한다는 점이다. 기존 `docs/flutter-structure-audit.md`는 feature 폴더를 6개로 설명하지만, 현재 코드는 `parent_mode`를 포함해 7개 feature 폴더를 가진다.

현재 런타임 API 클라이언트, 인증 토큰 저장소, JSON 직렬화 계층, 상태관리 라이브러리는 없다. 앱은 Flutter 기본 `Navigator`, `StatefulWidget`, `setState`, fixture fallback, 일부 mock repository로 목업 화면을 구동한다.

## 2. 파일 구조 스냅샷

`lib/` 하위 Dart 파일 수는 현재 170개다.

| 위치 | 파일 수 | 현재 역할 |
| --- | ---: | --- |
| `lib/main.dart` | 1 | `runApp(const LittleQuestApp())`만 수행하는 엔트리포인트 |
| `lib/app/` | 9 | 앱 조립, 라우터, theme token |
| `lib/core/` | 5 | 앱 전역 재사용 UI 위젯 |
| `lib/screens/` | 13 | 아직 feature로 이동되지 않은 화면 |
| `lib/components/` | 4 | Discovery/Quest/Plan 도메인성 카드 위젯 |
| `lib/models/` | 5 | Discovery/Home/Quest/Plan 전역 모델 |
| `lib/data/` | 2 | Discovery 목록 fixture/repository |
| `lib/features/` | 131 | feature별 data/model/page/widget 및 parent mode |

현재 feature 폴더:

| feature | 구조 | 상태 |
| --- | --- | --- |
| `account_verification` | `data/models`, `data/repositories`, `presentation/pages`, `presentation/widgets` | 재인증 화면과 mock repository가 feature 내부에 있음 |
| `card_detail` | `data`, `models`, `widgets` | 상세 모델/fixture/widget은 feature 내부, route page는 아직 `screens/`에 있음 |
| `my_page` | `data/datasources`, `data/models`, `presentation/pages`, `presentation/widgets` | fixture fallback 구조 |
| `parent_mode` | `fixtures`, `models`, root page files, `widgets` | 새 보호자 모드. 목표 구조의 `presentation/pages` 하위로는 아직 정리되지 않음 |
| `profile_edit` | `data/datasources`, `data/models`, `presentation/pages`, `presentation/widgets` | fixture fallback 구조 |
| `quest_detail` | `data/datasources`, `data/models`, `presentation/pages`, `presentation/widgets` | fixture fallback 구조 |
| `signup` | `data/models`, `presentation/pages`, `presentation/widgets` | 이메일 회원가입 입력과 소셜 가입 버튼 UI |

## 3. 앱 조립과 라우팅

`lib/main.dart`는 `LittleQuestApp`만 실행한다. `LittleQuestApp`은 `MaterialApp`을 만들고 `AppRouter.routes`, `AppRouter.onGenerateRoute`, `AppTheme.light`를 연결한다. `LQ_INITIAL_ROUTE` compile-time environment 값이 있으면 초기 라우트를 덮어쓸 수 있다.

`AppRouter.routes`의 named route:

| route | 화면 | 현재 위치 |
| --- | --- | --- |
| `/` | Welcome | `lib/screens/welcome_screen.dart` |
| `/login` | Login | `lib/screens/login_screen.dart` |
| `/mode-selection` | Child/Parent mode 선택 | `lib/screens/mode_selection_screen.dart` |
| `/signup` | Signup method | `lib/features/signup/presentation/pages/signup_method_page.dart` |
| `/signup/email` | Email signup | `lib/features/signup/presentation/pages/email_signup_page.dart` |
| `/home` | Home | `lib/screens/home_screen.dart` |
| `/discovery-cards` | Discovery 목록 | `lib/screens/discovery_card_screen.dart` |
| `/map` | Map | `lib/screens/map_screen.dart` |
| `/quest-detail` | Quest detail | `lib/features/quest_detail/presentation/pages/quest_detail_screen.dart` |
| `/my-page` | My page | `lib/features/my_page/presentation/pages/my_page_screen.dart` |
| `/account-verification` | Password reauthentication | `lib/features/account_verification/presentation/pages/account_verification_screen_password.dart` |
| `/account-verification-social` | Social reauthentication | `lib/features/account_verification/presentation/pages/account_verification_screen_social.dart` |
| `/account-verification-method` | Reauthentication method | `lib/features/account_verification/presentation/pages/account_verification_screen_method.dart` |
| `/profile-edit` | Profile edit | `lib/features/profile_edit/presentation/pages/profile_edit_screen.dart` |
| `/card-detail` | Canonical discovery card detail | `lib/screens/discovery_card_detail_screen.dart` |
| `/parent/entry` | Parent mode entry | `lib/features/parent_mode/parent_mode_entry_page.dart` |
| `/parent/verify` | Parent verification | `lib/features/parent_mode/parent_verification_page.dart` |
| `/parent/home` | Parent home | `lib/features/parent_mode/parent_home_page.dart` |
| `/parent/children` | Child list | `lib/features/parent_mode/parent_child_list_page.dart` |
| `/parent/guardian-info` | Guardian info | `lib/features/parent_mode/parent_guardian_info_page.dart` |
| `/parent/account-security` | Account security | `lib/features/parent_mode/parent_account_security_page.dart` |
| `/parent/privacy-consent` | Privacy/consent | `lib/features/parent_mode/parent_privacy_consent_page.dart` |
| `/parent/records` | Parent discovery records | `lib/features/parent_mode/parent_discovery_record_page.dart` |
| `/parent/location` | Parent location records | `lib/features/parent_mode/parent_location_record_page.dart` |
| `/parent/subscription` | Subscription/payment | `lib/features/parent_mode/parent_subscription_page.dart` |
| `/parent/data` | Data deletion/account management | `lib/features/parent_mode/parent_data_management_page.dart` |
| `/parent/settings` | Parent settings | `lib/features/parent_mode/parent_settings_page.dart` |

`AppRouter.onGenerateRoute`의 동적/legacy route:

| route pattern | 처리 |
| --- | --- |
| `/parent/children/{childId}` | `ParentChildInfoPage(childId: childId)`로 연결 |
| `/card-detail-legacy` | `DiscoveryCardItem` argument를 받아 `CardDetailScreen`으로 연결 |

## 4. 현재 화면과 데이터 공급 방식

| 영역 | 화면/파일 | 현재 데이터 방식 | 백엔드 전환 난이도 |
| --- | --- | --- | --- |
| Welcome/Mode selection | `welcome_screen.dart`, `mode_selection_screen.dart` | 정적 UI, route 이동 | 낮음 |
| Login | `login_screen.dart` | 입력값 검증 없이 `_login()`에서 Home으로 이동 | 높음 |
| Signup | `features/signup/*` | local form state, backend TODO | 중간 |
| Home | `home_screen.dart` | `_quests`, `_discoveries`, `_banners`, `_logs` 하드코딩 | 높음 |
| Discovery 목록 | `discovery_card_screen.dart` | `DiscoveryRepository`가 fixture 반환 | 중간 |
| Discovery 상세 | `discovery_card_detail_screen.dart` | `sampleCardDetail` fixture fallback, favorite local toggle | 중간 |
| Legacy card detail | `card_detail_screen.dart` | `DiscoveryCardItem` argument | 중간 |
| Quest detail | `features/quest_detail/*` | `QuestDetailFixture.springPlants` fallback | 중간 |
| My page | `features/my_page/*` | `MyPageFixture.sample` fallback | 중간 |
| Profile edit | `features/profile_edit/*` | `ProfileEditFixture.sample` fallback, save TODO | 높음 |
| Account verification | `features/account_verification/*` | `MockAccountVerificationRepository`, static method/social data | 높음 |
| Camera flow | `camera_screen.dart`, `photo_preview_screen.dart`, `analysis_status_screen.dart` | camera placeholder, fake preview, `Future.delayed` analysis simulation | 높음 |
| Map | `map_screen.dart` | 지도 placeholder와 하드코딩 위치 카드 | 높음 |
| Plan | `plan_screen.dart` | plan list in widget state | 중간 |
| Parent mode | `features/parent_mode/*` | `ParentModeFixture`, `parent_profile_fixture.dart`, TODO actions | 높음 |

## 5. Mock, fixture, hard-coded 데이터 목록

### 5.1 Fixture/mock 파일

| 파일 | 제공 데이터 | 교체 방향 |
| --- | --- | --- |
| `lib/data/discovery_fixtures.dart` | Discovery 카드 28개와 category group | Discovery API repository로 교체 |
| `lib/data/discovery_repository.dart` | `DiscoveryDataSource` + fixture 반환 repository | 실제 HTTP data source 구현 |
| `lib/features/card_detail/data/card_detail_fixtures.dart` | `sampleCardDetail` 1건 | `GET /cards/{id}` 상세 응답 |
| `lib/features/my_page/data/datasources/my_page_fixture.dart` | 마이페이지 요약, 최근 관찰, 배지 | `GET /users/me/summary` 계열 |
| `lib/features/profile_edit/data/datasources/profile_edit_fixture.dart` | 프로필 편집 기본값 | `GET/PATCH /users/me/profile` |
| `lib/features/quest_detail/data/datasources/quest_detail_fixture.dart` | 퀘스트 상세 1건 | `GET /quests/{id}` |
| `lib/features/account_verification/data/repositories/account_verification_repository.dart` | 비어 있지 않은 password면 성공 처리 | 서버 재인증 API |
| `lib/features/parent_mode/fixtures/parent_mode_fixture.dart` | 보호자 홈/동의/구독/삭제/위치/최근 사진 fixture | parent API 전체 |
| `lib/features/parent_mode/fixtures/parent_profile_fixture.dart` | 아이 목록, 보호자 정보, 로그인 방법/이력 | child/guardian/security API |

### 5.2 화면 내부 하드코딩

| 파일 | 데이터 |
| --- | --- |
| `lib/screens/home_screen.dart` | 오늘 퀘스트, 최근 발견, 배너, 위치 로그 |
| `lib/screens/login_screen.dart` | 소셜 로그인 버튼 콜백 비어 있음, `_login()` 무조건 Home 이동 |
| `lib/screens/camera_screen.dart` | 카메라 UI placeholder, 카테고리 문자열 |
| `lib/screens/photo_preview_screen.dart` | 촬영 사진 대신 gradient placeholder |
| `lib/screens/analysis_status_screen.dart` | AI 분석 4단계 문자열과 `Future.delayed` 진행 |
| `lib/screens/map_screen.dart` | `서울숲 가족마당`, `12종류 발견`, `2024.05.20` |
| `lib/screens/plan_screen.dart` | Free/Plus/Family plan 가격과 benefit |
| `features/account_verification/presentation/pages/*` | 재인증 방법/provider 표시 데이터 |
| `features/signup/presentation/pages/*` | 소셜 가입 TODO, 약관/개인정보 상세 TODO |

## 6. 모델과 DTO 상태

현재 모델은 대부분 UI 표시용 DTO에 가깝고 JSON serialization, API response DTO, domain entity, mapper가 분리되어 있지 않다.

| 모델 그룹 | 위치 | 비고 |
| --- | --- | --- |
| Discovery list | `lib/models/discovery_card.dart`, `lib/models/discovery_category.dart` | `DiscoveryCard` 모델과 `components/discovery_card.dart` 위젯명이 충돌 |
| Home discovery item | `lib/models/discovery_card_item.dart` | legacy detail route argument에도 사용 |
| Quest summary | `lib/models/quest.dart` | Home용 간단 모델 |
| Plan | `lib/models/plan_tier.dart`, `lib/components/plan_card.dart` | Plan screen 전용에 가까움 |
| Card detail | `features/card_detail/models/card_detail_data.dart` | Holo grade, discovery record, observation record 포함 |
| Quest detail | `features/quest_detail/data/models/quest_detail_data.dart` | target, mission, progress 계산 포함 |
| My page | `features/my_page/data/models/my_page_data.dart` | profile summary, stats, recent observation, badge |
| Profile edit | `features/profile_edit/data/models/profile_edit_data.dart` | 편집 화면 표시값 |
| Account verification | `features/account_verification/data/models/*` | method/social/provider state |
| Signup | `features/signup/data/models/*` | form validation state, provider enum |
| Parent mode | `features/parent_mode/models/*` | child, guardian, consent, login history, subscription, menu |

백엔드 연동 전 결정할 점:

- API response DTO와 UI model을 같은 class로 쓸지 분리할지 결정해야 한다.
- 날짜는 현재 `DateTime`과 문자열이 섞여 있다. API 계약에서는 ISO-8601, timezone, 표시 포맷의 책임을 분리해야 한다.
- `IconData`, `Color`가 포함된 UI 모델은 서버 응답 DTO로 직접 쓰기 어렵다. 서버는 icon key/color token key를 내려주고 클라이언트에서 theme token으로 매핑하는 편이 안전하다.
- `DiscoveryCard` 모델명과 위젯명 충돌을 API DTO 추가 전 먼저 정리하거나 import alias 규칙을 세워야 한다.

## 7. 상태관리와 의존성 주입 상태

현재 상태관리는 Flutter 기본 local state가 중심이다.

| 패턴 | 사용처 | 설명 |
| --- | --- | --- |
| `StatefulWidget` + `setState` | Home, Discovery, Login, Camera, Analysis, Parent verification 등 | 화면별 local state |
| fixture fallback parameter | MyPage, ProfileEdit, QuestDetail, DiscoveryDetail | `widget.data ?? Fixture.sample` 형태 |
| repository interface | Discovery, AccountVerification | `DiscoveryDataSource`, `AccountVerificationRepository`만 존재 |
| `Future.delayed` simulation | Analysis, Parent verification | 실제 API pending 상태처럼 보이는 mock |
| `Navigator` 직접 호출 | 대부분 화면 | route name과 `MaterialPageRoute` 혼재 |

API 연동 시 우선 도입해야 할 공통 상태:

- loading, empty, error, retry 상태
- auth required/reauth required 상태
- network timeout/offline 상태
- optimistic update rollback 상태
- paginated list loading 상태
- upload/analysis progress 상태

## 8. 디자인 시스템과 공통 UI

Theme은 `lib/app/theme`에 있으며 `AppColors`와 `LqColors`가 함께 사용된다. `AppColors`는 기존 screen/core 위젯에서 넓게 쓰이고, `LqColors`는 feature로 이동된 화면과 parent/signup/account 계열에서 많이 쓰인다. 색상 토큰 통합은 API 문서 작업과 분리해야 하며, 백엔드 연동과 동시에 색상 token 변경을 섞으면 visual regression 추적이 어려워진다.

공통 위젯은 `lib/core/widgets` 아래에 있고, domain-specific 위젯은 아직 `lib/components`와 feature widgets에 섞여 있다. API 연동 작업에서는 UI 이동보다 data source 교체와 상태 표현 추가를 우선해야 한다.

## 9. 테스트 상태

`test/widget_test.dart` 하나가 존재한다. 현재 커버하는 범위:

- Welcome 화면 렌더링
- mode selection에서 아이/부모 모드 진입
- signup method와 email signup form 일부
- parent mode entry, parent home menu, parent route smoke
- parent data deletion confirmation
- child profile edit에서 account deletion 미노출 확인

아직 부족한 범위:

- Login 성공/실패/소셜 로그인
- Home 데이터 표시와 banner URL launch
- Discovery list loading/error/empty/category filter
- Card detail favorite/share/observation action
- Camera/photo preview/analysis 실제 업로드와 polling
- Profile edit save/error/reauth required
- Quest detail mission action
- Map/location permission and marker rendering

API 연동 전 최소 smoke test는 route별 렌더링, repository loading/error state, auth guard/reauth guard 중심으로 확장해야 한다.

## 10. 백엔드 연동 관점의 구조 위험

| 위험 | 근거 | 권장 처리 |
| --- | --- | --- |
| 네트워크 인프라 없음 | `pubspec.yaml`에 HTTP client, storage, JSON generator 없음 | `core/network`, `core/storage`, feature repository 계층 설계 후 도입 |
| fixture 위치 불일치 | Discovery만 전역 `lib/data`, 다른 fixture는 feature 내부 | Discovery feature 이동 또는 adapter boundary 먼저 확정 |
| parent mode 구조가 목표 구조와 다름 | `features/parent_mode` root에 page 파일 13개 | API 연동 전 최소한 repository/fixture 위치만 정리하거나 문서화 |
| auth flow가 fake navigation | Login이 검증 없이 Home 이동 | token/session/refresh/guard 설계 선행 |
| analysis flow가 fake async | `_simulateAnalysis()`로 완료 상태 표현 | upload job/polling/cancel/error contract 필요 |
| UI model에 Flutter type 포함 | `IconData`, `Color` 포함 모델 존재 | API DTO와 UI mapper 분리 필요 |
| route argument 불일치 | `/card-detail`은 argument를 받지 않고, legacy route만 item 사용 | 상세 진입 시 card id 전달 방식 정리 필요 |
| child safety/privacy 민감 데이터 | parent mode에 아이/위치/사진/동의/삭제 기능 존재 | 권한, 동의, 감사 로그, 삭제 API 계약 선행 |

## 11. 다음 문서와 연결

백엔드 연동에 필요한 API, 라이브러리, 인프라 준비사항은 `docs/little-quest-backend-required-library.md`에 정리한다. 이 문서는 구조 스냅샷이며, 코드 변경이나 package 추가는 포함하지 않는다.
