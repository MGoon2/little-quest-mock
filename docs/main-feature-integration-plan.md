# Main-Project 기능 통합 계획

> **역할**: 시니어 풀스택 엔지니어 관점에서, main-project(`little-quest/little_quest`)의 **목업 단계 구조를 보존하면서** sample-project에서 추출한 요구사항(`docs/sample-feature-requirements.md`의 7장 API 목록을 backend-spec 대신 사용)과 통합하기 위한 계획.
>
> **현재 상황 전제**:
> 1. sample-project는 백엔드 없는 프론트 샘플.
> 2. main-project도 목업 단계, 실제 백엔드 연결점 없음.
> 3. **지금 단계에서 백엔드 API를 구현하거나 프론트를 바로 연결하지 않는다.**
> 4. 먼저 main-project의 목업 화면/임시 데이터/상태 흐름/컴포넌트 구조를 분석한다.
> 5. 이후 sample 요구사항과 main 목업 구조를 비교해 통합 계획을 수립한다.
>
> **주의사항**:
> - 실제 백엔드 구현/연결은 이 계획의 범위 밖 (마지막 "다음 구현 단계 제안"의 5~6단계).
> - mock 데이터를 무작정 제거하지 않는다. **API 계약 기반 adapter로 점진적 교체**가 핵심 전략.
> - main-project의 목업 흐름을 보존하면서 API 계약 기반 구조로 전환.
> - sample-project의 UI를 그대로 복사하지 않는다.
> - main-project의 디자인 시스템과 화면 구조를 우선하고, 기존 컴포넌트/패턴을 최대한 재사용.
>
> **참고 문서**:
> - `docs/sample-feature-requirements.md` — 기능 요구사항 역추출 + API 목록(7장 40+ API) — 본 문서에서 backend-spec 대신 사용
> - `docs/sample-feature-frontend-porting-plan.md` — 홀로 카드 렌더링 이식 계획 (본 통합 계획과 독립적이나 참고)
>
> **본 문서는 계획만 작성하며, 코드 수정은 수반하지 않는다.**

---

## 1. main-project의 현재 목업 화면 목록

> `lib/screens/` 기준. 라우트는 `lib/main.dart` named routes + `onGenerateRoute`로 정의.

| # | 화면 | 파일 | 라우트 | 목업 상태 |
|---|------|------|--------|-----------|
| 1 | 웰컴 | `welcome_screen.dart` | `/` | 정적(배경 이미지 + 버튼) |
| 2 | 로그인 | `login_screen.dart` | `/login` | UI만, `_login()`이 검증 없이 Home으로 이동(가짜 로그인) |
| 3 | 홈 | `home_screen.dart` | `/home` | 화면 내 하드코딩(`_quests`/`_discoveries`/`_banners`/`_logs`) |
| 4 | 발견 카드 목록 | `discovery_card_screen.dart` | `/discovery-cards` | `DiscoveryRepository`(Mock→fixture) 사용 |
| 5 | 발견 카드 상세 | `discovery_card_detail_screen.dart` | `/card-detail` | `sampleCardDetail` fixture 직접 참조 |
| 6 | (레거시) 카드 상세 | `card_detail_screen.dart` | `/card-detail-legacy`(onGenerateRoute) | `DiscoveryCardItem` 파라미터 |
| 7 | 마이페이지 | `my_page_screen.dart` | `/my-page` | `MyPageFixture.sample` 직접 참조 |
| 8 | 프로필 수정 | `profile_edit_screen.dart` | `/profile-edit` | `ProfileEditFixture.sample` 직접 참조, 저장 TODO |
| 9 | 퀘스트 상세 | `quest_detail_screen.dart` | `/quest-detail` | `QuestDetailFixture.springPlants` 직접 참조 |
| 10 | 계정 확인(방법 선택) | `account_verification_screen_method.dart` | `/account-verification-method` | 하드코딩 `AccountVerificationMethodData` |
| 11 | 계정 확인(비밀번호) | `account_verification_screen_password.dart` | `/account-verification` | `MockAccountVerificationRepository` |
| 12 | 계정 확인(소셜) | `account_verification_screen_social.dart` | `/account-verification-social` | 하드코딩 `SocialAccountVerificationData` |
| 13 | 카메라 | `camera_screen.dart` | (FAB/`push`) | 플레이스홀더(녹색 보케), `camera` 패키지 없음 |
| 14 | 사진 미리보기 | `photo_preview_screen.dart` | (`pushReplacement`) | 플레이스홀더(그라데이션 + 보케 원) |
| 15 | AI 분석 상태 | `analysis_status_screen.dart` | (`pushReplacement`) | `Future.delayed` 가짜 시뮬레이션(4단계) |
| 16 | 지도 | `map_screen.dart` | `/map` | 플레이스홀더(아이콘 + 하드코딩 위치 카드) |
| 17 | 발견 인트로 | `discovery_intro_screen.dart` | (별도 라우트 없음) | 정적 |
| 18 | 구독 플랜 | `plan_screen.dart` | (별도 라우트 없음) | 하드코딩 `Plan` 데이터 |

> 총 18개 화면. 이 중 13~16(카메라/사진/분석/지도)이 가장 목업 성격이 강하고 백엔드/외부 SDK 의존도가 높음.

---

## 2. main-project에서 사용 중인 mock 데이터 구조

### 2.1 Fixture 파일 (5개)

| 파일 | 제공 데이터 | 형태 | 제거 대상 |
|------|------------|------|-----------|
| `lib/data/discovery_fixtures.dart` | `DiscoveryFixtures.plants/animals/insects/buildings/all/groups` (`abstract final class` + static) | 28장 카드(id/name/category/rating/discoveredAt) | API 연동 후 제거 |
| `lib/features/card_detail/data/card_detail_fixtures.dart` | `sampleCardDetail` (top-level 변수) | 카드 상세 1건(은행나무, HoloGrade.holo, 관찰 3건, 조건 3건) | API 연동 후 제거 |
| `lib/features/my_page/data/my_page_fixture.dart` | `MyPageFixture.sample` (`abstract final class` + static const) | 마이페이지 요약(통계/배지 4개/최근관찰 3개) | API 연동 후 제거 |
| `lib/features/profile_edit/data/profile_edit_fixture.dart` | `ProfileEditFixture.sample` (`abstract final class` + static const) | 프로필(닉네임/이메일/소셜연결 등) | API 연동 후 제거 |
| `lib/features/quest_detail/data/quest_detail_fixture.dart` | `QuestDetailFixture.springPlants` (`abstract final class` + static final) | 퀘스트 1건(봄 식물, 대상 5개/미션 3개) | API 연동 후 제거 |

### 2.2 화면 내 하드코딩 데이터 (fixture 없이 화면 State에 직접)

| 화면 | 하드코딩 데이터 | 위치 |
|------|----------------|------|
| `home_screen.dart` | `_quests`(1개), `_discoveries`(10개 `DiscoveryCardItem`), `_banners`(2개), `_logs`(3개 `_LogData`) | `_HomeScreenState` 필드 |
| `account_verification_screen_method.dart` | `AccountVerificationMethodData`(methods 5개) | `build` 내 지역 변수 |
| `account_verification_screen_social.dart` | `SocialAccountVerificationData`(providers) | (추정) 화면 내 |
| `map_screen.dart` | "서울숲 가족마당 / 12종류 발견 / 2024.05.20" | 위젯 트리 내 문자열 |
| `plan_screen.dart` | `Plan` 데이터 | (추정) 화면 내 |

### 2.3 도메인 모델 (mock 데이터가 채우는 구조)

> `docs/sample-feature-requirements.md` 부록 및 8장 참조. 주요 모델:
> - `DiscoveryCard`, `DiscoveryCardGroup`, `DiscoveryCategory`, `DiscoveryCardItem`
> - `CardDetailData`, `HoloGrade`, `DiscoveryRecord`, `HoloCondition`, `ObservationRecord`
> - `QuestDetailData`, `QuestTargetItem`, `QuestMissionItem`, `QuestType`, `QuestMissionType`
> - `MyPageData`, `RecentObservationItem`, `BadgeItem`
> - `ProfileEditData`
> - `AccountVerificationState`, `AccountVerificationMethodData`, `SocialAccountVerificationData`
> - `Quest`, `Plan`, `PlanTier`

> **주의**: 이 모델 클래스 자체는 mock이 아님. **모델은 유지**하고, **모델을 채우는 fixture/하드코딩만 교체 대상**.

---

## 3. main-project에서 임시로 처리 중인 상태관리 방식

> 상태관리 라이브러리(Provider/Riverpod/Bloc) **미사용**. Flutter 기본 `StatefulWidget` + `setState` + `ValueNotifier` 패턴.

### 3.1 화면 단위 State

| 화면 | State 클래스 | 관리 상태 | 패턴 |
|------|-------------|-----------|------|
| HomeScreen | `_HomeScreenState` | `_currentIndex`(하단네비), `_currentBannerIndex`, `_bannerController` | `setState` |
| DiscoveryCardScreen | `_DiscoveryCardScreenState` | `_selectedCategory`, `_groups?`, `_cards?` | `setState` + Repository 비동기 로드(`initState` → `_loadData`) |
| DiscoveryCardDetailScreen | `_DiscoveryCardDetailScreenState` | `_data`(`CardDetailData`), `_onToggleFavorite` 로컬 토글 | `setState` (fixture 직접 참조) |
| LoginScreen | `_LoginScreenState` | `_emailController`, `_passwordController`, `_rememberMe`, `_obscurePassword` | `setState` |
| AccountVerificationScreen(Password) | `_AccountVerificationScreenState` | `_passwordController`, `_repository`(Mock), `_obscurePassword`, `_isSubmitting`, `_errorMessage` | `setState` + Repository 비동기 |
| AnalysisStatusScreen | `_AnalysisStatusScreenState` | `_controller`(AnimationController), `_step` | `setState` + `Future.delayed` 시뮬레이션 |
| CameraScreen | `_CameraScreenState` | `_selectedCategory`, `_categoryPanelVisible`, `_isCapturing` | `setState` |

### 3.2 컴포넌트 단위 State (내부 애니메이션 등)

| 컴포넌트 | State | 용도 |
|---------|-------|------|
| SideMenu | `_SideMenuState` | 슬라이드 애니메이션(`AnimationController`) |
| PhotoPreviewScreen | `_PhotoPreviewScreenState` | fade-in 애니메이션 |

### 3.3 비동기 데이터 로드 패턴 (현재 2곳만)

```dart
// DiscoveryCardScreen 패턴 (Repository 사용)
final _repository = const DiscoveryRepository();
@override
void initState() {
  super.initState();
  _loadData();
}
Future<void> _loadData() async {
  final groups = await _repository.fetchAllGrouped();
  if (mounted) setState(() => _groups = groups);
}

// AccountVerificationScreen(Password) 패턴 (Repository + try/catch)
try {
  final success = await _repository.verifyPassword(password);
  if (success) { ... } else { setState(() => _errorMessage = '...'); }
} catch (e) {
  setState(() => _errorMessage = '연결 상태를 확인하고 다시 시도해 주세요.');
} finally {
  if (mounted) setState(() => _isSubmitting = false);
}
```

> 이 두 패턴이 **adapter 교체의 기본 틀**이 됨. 나머지 화면( fixture 직접 참조)도 이 패턴으로 통일해야 함.

### 3.4 의존성 주입 패턴 (이미 부분적으로 존재)

| 화면 | 주입 방식 | 비고 |
|------|-----------|------|
| `DiscoveryCardDetailScreen` | `final CardDetailData? data;` + `widget.data ?? sampleCardDetail` | 외부 주입 가능하나 현재는 fixture fallback |
| `MyPageScreen` | `final MyPageData? data;` + `widget.data ?? MyPageFixture.sample` | 동일 |
| `QuestDetailScreen` | `final QuestDetailData? quest;` + `widget.quest ?? QuestDetailFixture.springPlants` | 동일 |
| `ProfileEditScreen` | `final ProfileEditData? data;` + `widget.data ?? ProfileEditFixture.sample` | 동일 |

> **핵심 관찰**: 이 "파라미터 주입 + fixture fallback" 패턴은 이미 **Repository 주입으로 자연스럽게 확장 가능**한 구조. `widget.data ?? sampleCardDetail`를 `await _repository.fetchCardDetail(id)`로 교체하면 됨.

---

## 4. main-project에서 실제 API 연결이 필요해지는 지점

> `docs/sample-feature-requirements.md` 6장/부록 B의 TODO 주석 40+곳 + 가짜 시뮬레이션 1곳을 통합 정리.

### 4.1 데이터 조회/변경 (fixture → API)

| 지점 | 파일:라인 | 현재 | 필요 API |
|------|-----------|------|---------|
| 발견 카드 목록 | `discovery_repository.dart:21,32` | fixture 반환 | `GET /cards`, `GET /cards/grouped` |
| 카드 상세 | `discovery_card_detail_screen.dart:34` | `sampleCardDetail` | `GET /cards/{id}` |
| 카드 좋아요 | `discovery_card_detail_screen.dart:91,119` | 로컬 `setState` | `POST /cards/{id}/favorite` |
| 카드 공유 | `discovery_card_detail_screen.dart:57` | TODO | `POST /cards/{id}/share` |
| 카드 검색 | `discovery_card_screen.dart:73` | TODO | `GET /cards?q=` |
| 마이페이지 요약 | `my_page_screen.dart`(전체) | `MyPageFixture.sample` | `GET /users/me/summary` |
| 프로필 조회/수정 | `profile_edit_screen.dart:49` | `ProfileEditFixture.sample` | `GET/PATCH /users/me` |
| 회원 탈퇴 | `profile_edit_screen.dart:55` | TODO | `DELETE /auth/account` |
| 퀘스트 상세 | `quest_detail_screen.dart`(전체) | `QuestDetailFixture.springPlants` | `GET /quests/{id}` |
| 퀘스트 대상 목록 | `quest_detail_screen.dart:42` | TODO | `GET /quests/{id}/targets` |
| 미션 완료 | `quest_mission_card.dart:50` | TODO | `POST /quests/{id}/missions/{mid}/complete` |
| 오늘 퀘스트 | `home_screen.dart` `_quests` | 하드코딩 1개 | `GET /quests/today` |
| 최근 발견 카드 | `home_screen.dart` `_discoveries` | 하드코딩 10개 | `GET /cards/recent` (또는 요약 API) |
| 배지 목록 | `my_page_screen.dart:68` | TODO | `GET /users/me/badges` |
| 관찰 기록 목록 | `my_page_screen.dart:46,61` | TODO | `GET /cards/{id}/observations` |
| 관찰 기록 추가 | `discovery_card_detail_screen.dart:89,98` | TODO | `POST /cards/{id}/observations` |
| Holo 등급 조건 | `card_detail_data.dart` `nextGradeConditions` | fixture | `GET /cards/{id}/grade-conditions` |

### 4.2 인증 (가짜 → 실제)

| 지점 | 파일 | 현재 | 필요 API |
|------|------|------|---------|
| 이메일 로그인 | `login_screen.dart:309` `_login` | 검증 없이 Home 이동 | `POST /auth/login` |
| 소셜 로그인 | `login_screen.dart` 소셜 버튼 | `onTap: () {}` 빈 콜백 | `POST /auth/oauth/{provider}` |
| 회원가입 | `login_screen.dart` "회원가입" | `onTap: () {}` | `POST /auth/signup` |
| 비밀번호 재설정 | `account_verification_screen_password.dart:97` | TODO | `POST /auth/password/reset` |
| 비밀번호 재인증 | `account_verification_repository.dart` | `Mock`(비어있지 않으면 true) | `POST /auth/reverify/password` |
| 소셜 재인증 | `account_verification_screen_method.dart:67`, `account_verification_screen_social.dart:46` | TODO | `POST /auth/reverify/oauth/{provider}` |
| 토큰 갱신 | (없음) | — | `POST /auth/refresh` |

### 4.3 외부 리소스 (플레이스홀더 → 실제)

| 지점 | 파일 | 현재 | 필요 |
|------|------|------|------|
| 카메라 촬영 | `camera_screen.dart` | 녹색 보케 플레이스홀더 | `camera` 패키지 + 권한 |
| 사진 미리보기 | `photo_preview_screen.dart` | 그라데이션 플레이스홀더 | 촬영 이미지 표시 |
| AI 종 식별 | `analysis_status_screen.dart:47` `_simulateAnalysis` | **`Future.delayed` 가짜 4단계 시뮬레이션** | `POST /analysis/identify` + `GET /analysis/{id}` 폴링 |
| 이미지 업로드 | (없음) | — | `POST /uploads/image` |
| 카드 생성 확정 | (없음, 분석 완료 후 `DiscoveryCardScreen`으로 이동만) | — | `POST /cards` |
| 지도 표시 | `map_screen.dart` | 아이콘 플레이스홀더 | 지도 SDK(`google_maps_flutter`/`flutter_map`) |
| 위치 정보 | `map_screen.dart` 하드코딩 "서울숣" | 문자열 | `geolocator` + `GET /locations` |
| 프로필 이미지 변경 | `profile_edit_header_card.dart:58` | TODO | `POST /users/me/profile-image` |
| 프로필 섹션별 변경 | `basic_info_section_card.dart`/`email_section_card.dart`/`password_section_card.dart`/`connected_accounts_section_card.dart`/`notification_settings_section_card.dart` 다수 TODO | TODO | `PATCH /users/me/*` |

### 4.4 가짜 시뮬레이션(핵심)
`analysis_status_screen.dart`의 `_simulateAnalysis()`는 **유일하게 "진행 중인 비동기 작업을 흉내 내는" 코드**. 다른 TODO들은 "아직 구현 안 함"이지만, 이것은 "구현된 척한다"는 점에서 가장 주의. 백엔드 연동 시 가장 먼저 실제 폴링 흐름으로 교체해야 함.

---

## 5. sample-feature-requirements.md의 기능 요구사항과 main-project 목업 화면의 매핑

> requirements.md 10장(새로 추가할 기능)을 main 화면에 대응.

### 5.1 홀로 카드 렌더링 (sample 이식, 클라이언트 로직)

| requirements 기능 | main 화면/위젯 | 매핑 |
|-------------------|---------------|------|
| 홀로그래픽 포일 렌더링(셰이더) | `DiscoveryHeroCard._buildHeroImage` | placeholder(은행잎 CustomPaint) → `HoloCardRender` 교체. **별도 화면 없음**. `frontend-porting-plan.md` 참조 |
| 글레어 레이어 | 동일 | `HoloCardRender` 내부 |
| 3D 틸트 + 포인터 인터랙션 | 동일 | `HoloCardRender` 내부, 터치 드래그 대응 추가 |
| HoloGrade → 효과 매핑 | `HoloGrade` enum(수정 없음) + 신규 매핑 유틸 | `normal`=글레어만, `holo`/`seasonalHolo`=홀로+글레어 |

> **비고**: 홀로 카드 렌더링은 **API 연결 없이 클라이언트에서 완결**되므로, 본 통합 계획의 백엔드 연결 대상이 아님. `frontend-porting-plan.md`의 Phase 0~5로 별도 진행. 본 문서에서는 백엔드 연결이 필요한 부분에 집중.

### 5.2 백엔드 연동이 필요한 기능 (requirements 10.2)

| requirements 기능 | main 화면 | 매핑 |
|-------------------|----------|------|
| 인증 시스템 실구현 | `LoginScreen`, `AccountVerificationScreen*` | 가짜 로그인/Mock 재인증 → 실제 API |
| 사진 업로드 + AI 종 식별 | `CameraScreen`→`PhotoPreviewScreen`→`AnalysisStatusScreen` | 플레이스홀더/가짜 시뮬레이션 → 업로드 + 폴링 |
| 발견 카드 CRUD | `DiscoveryCardScreen`, `DiscoveryCardDetailScreen` | fixture → API |
| 카드 좋아요/공유 | `DiscoveryCardDetailScreen` | 로컬 토글/TODO → API |
| 퀘스트 API | `QuestDetailScreen`, `HomeScreen` 오늘 퀘스트 | fixture/하드코딩 → API |
| 마이페이지 API | `MyPageScreen` | fixture → API |
| 프로필 수정 API | `ProfileEditScreen` + 섹션 카드들 | fixture/TODO → API |
| 지도/위치 | `MapScreen` | 플레이스홀더 → SDK + API |

### 5.3 인프라 (requirements 10.3)

| requirements 항목 | main 적용 |
|-------------------|-----------|
| HTTP 클라이언트(Dio/http) | 신규 도입 — `lib/data/api/` 또는 `lib/core/api/` |
| 인증 토큰 저장 | 신규 도입 — `flutter_secure_storage` 권장 |
| image_picker/croppy/path_provider | (사진 선택 기능 추가 시) — 본 통합에서는 AI 파이프라인에 필요 |
| 지도 SDK | `MapScreen` 실구현 시 |
| camera 패키지 | `CameraScreen` 실구현 시 |

---

## 6. API 스펙과 main-project 화면의 매핑

> `docs/sample-feature-requirements.md` 7장의 9개 API 영역을 main 화면에 대응. (backend-spec 대신 requirements의 API 표 사용)

### 6.1 인증/계정 (Auth)

| API | 화면 | 교체 대상 |
|-----|------|-----------|
| `POST /auth/login` | `LoginScreen._login` | 가짜 이동 → 토큰 획득 + Home 이동 |
| `POST /auth/oauth/{provider}` | `LoginScreen._buildSocialLoginRow` | 빈 `onTap` → 소셜 SDK 연동 후 토큰 교환 |
| `POST /auth/signup` | `LoginScreen` "회원가입" | 빈 `onTap` → 회원가입 화면(신규) 또는 다이얼로그 |
| `POST /auth/password/reset` | `AccountVerificationScreen(Password).onForgotPassword` | TODO → 재설정 화면/플로우 |
| `POST /auth/reverify/password` | `AccountVerificationScreen(Password)._handleSubmit` | `MockAccountVerificationRepository` → 실제 |
| `POST /auth/reverify/oauth/{provider}` | `AccountVerificationScreen(Method/Social)` | TODO → 소셜 재인증 플로우 |
| `DELETE /auth/account` | `ProfileEditScreen.DeleteAccountButton` | TODO → 탈퇴 확인 + API |
| `POST /auth/refresh` | (전역) | 신규 — 토큰 만료 시 자동 갱신(interceptor) |

### 6.2 사용자/프로필 (User)

| API | 화면 | 교체 대상 |
|-----|------|-----------|
| `GET /users/me` | `ProfileEditScreen` | `ProfileEditFixture.sample` → API |
| `PATCH /users/me` | `ProfileEditScreen.ProfileSaveButton` | TODO → 폼 검증 + API |
| `POST /users/me/profile-image` | `ProfileEditHeaderCard` | TODO → 이미지 피커 + 업로드 |
| `PATCH /users/me/password` | `PasswordSectionCard` | TODO → 비밀번호 변경 플로우 |
| `PATCH /users/me/email` | `EmailSectionCard` | TODO → 이메일 변경 플로우 |
| `POST/DELETE /users/me/oauth/{provider}` | `ConnectedAccountsSectionCard` | TODO → 연결/해제 |
| `PATCH /users/me/notification-settings` | `NotificationSettingsSectionCard` | TODO → 알림 설정 |
| `GET /users/me/summary` | `MyPageScreen` | `MyPageFixture.sample` → API |
| `GET /users/me/badges` | `MyBadgesSection`(my_page) | TODO → 배지 목록 |

### 6.3 발견 카드 (Discovery Card)

| API | 화면 | 교체 대상 |
|-----|------|-----------|
| `GET /cards?category=` | `DiscoveryCardScreen` | `DiscoveryRepository.fetchByCategory`(Mock) → 실제 |
| `GET /cards/grouped` | `DiscoveryCardScreen` | `DiscoveryRepository.fetchAllGrouped`(Mock) → 실제 |
| `GET /cards?q=` | `DiscoveryCardScreen` 검색 아이콘 | TODO → 검색 API |
| `GET /cards/{id}` | `DiscoveryCardDetailScreen` | `sampleCardDetail` → API |
| `POST /cards/{id}/favorite` | `DiscoveryCardDetailScreen._onToggleFavorite` | 로컬 `setState` → API |
| `POST /cards/{id}/share` | `DiscoveryCardDetailScreen` 공유 아이콘 | TODO → 공유 링크 생성 |

### 6.4 카드 생성 (AI 분석 파이프라인)

| API | 화면 | 교체 대상 |
|-----|------|-----------|
| `POST /uploads/image` | `PhotoPreviewScreen` "카드 만들기" | 플레이스홀더 → 이미지 업로드 |
| `POST /analysis/identify` | `AnalysisStatusScreen` 진입 | 가짜 시뮬레이션 시작 → 식별 요청 |
| `GET /analysis/{id}` | `AnalysisStatusScreen._simulateAnalysis` | **`Future.delayed` 가짜 → 실제 폴링** |
| `POST /cards` | `AnalysisStatusScreen` 완료 후 | (현재 바로 `DiscoveryCardScreen`으로 이동) → 카드 생성 확정 후 이동 |

### 6.5 관찰 기록 (Observation)

| API | 화면 | 교체 대상 |
|-----|------|-----------|
| `POST /cards/{id}/observations` | `DiscoveryCardDetailScreen._onObserveMore` | TODO → 관찰 추가 플로우(카메라 연동) |
| `GET /cards/{id}/observations` | `ObservationHistoryCard` | fixture(`sampleCardDetail.observations`) → API |
| `GET /cards/{id}/discovery-record` | `DiscoveryRecordCard` | fixture → API |
| `GET /cards/{id}/grade-conditions` | `HoloProgressCard` | fixture(`nextGradeConditions`) → API |

### 6.6 퀘스트 (Quest)

| API | 화면 | 교체 대상 |
|-----|------|-----------|
| `GET /quests/today` | `HomeScreen._quests` | 하드코딩 1개 → API |
| `GET /quests?type=` | (퀘스트 목록 화면 없음) | 신규 화면 필요(선택) |
| `GET /quests/{id}` | `QuestDetailScreen` | `QuestDetailFixture.springPlants` → API |
| `GET /quests/{id}/targets` | `RequiredQuestItemsSection` "전체보기" | TODO → 대상 목록 화면 |
| `POST /quests/{id}/missions/{mid}/complete` | `QuestMissionCard` | TODO → 미션 완료 처리 |

### 6.7 배지 (Badge)
- `GET /users/me/badges` → `MyBadgesSection`(my_page) — 6.2에 포함

### 6.8 지도/위치 (Location)

| API | 화면 | 교체 대상 |
|-----|------|-----------|
| `GET /locations?cardId=` | `MapScreen` | 플레이스홀더 → 지도 SDK + 위치 목록 |
| `POST /quests/place/start` | `MapScreen` "이 위치에서 퀘스트 시작" | 빈 `onPressed` → 위치 기반 퀘스트 시작 |

### 6.9 홀로 카드 렌더링 데이터
- (API 아님, 클라이언트 로직) — `HoloGrade`는 `GET /cards/{id}` 응답에 포함. 별도 API 불필요. `frontend-porting-plan.md` 참조.

---

## 7. 현재 main-project에서 유지할 화면

> **구조/레이아웃/디자인 시스템 준수 여부**와 **목업 흐름 보존** 관점에서 유지 판단. 데이터 소스만 교체.

| 화면 | 유지 사유 | 변경 범위 |
|------|-----------|-----------|
| `WelcomeScreen` | 정적 진입점, 변경 불필요 | 없음 |
| `LoginScreen` | UI 완성, 로직만 교체 | `_login`/소셜/회원가입 콜백 → API |
| `HomeScreen` | 레이아웃/컴포넌트 재사용 가치 높음 | 하드코딩 데이터 → API (State 구조 유지) |
| `DiscoveryCardScreen` | Repository 패턴 이미 적용, 가장 모범적 | Mock 구현체 → 실제 구현체만 교체 |
| `DiscoveryCardDetailScreen` | 화면 구조 양호, `DiscoveryHeroCard` 교체는 별도(porting-plan) | fixture 직접 참조 → Repository 경유 |
| `MyPageScreen` | 위젯 구조 양호 | fixture → API |
| `ProfileEditScreen` | 섹션 카드 구조 양호 | fixture/TODO → API |
| `QuestDetailScreen` | 위젯 구조 양호 | fixture → API |
| `AccountVerificationScreen(Method/Password/Social)` | UI 양호, Password는 Repository 이미 사용 | Mock/TODO → 실제 API |
| `MapScreen` | 플레이스홀더이나 레이아웃 유지 | SDK 연동 + API |
| `DiscoveryIntroScreen` | 정적 | 없음 |
| `PlanScreen` | 구독 플랜 UI | (결제 API는 본 범위 밖) 하드코딩 → API |

> **원칙**: 화면의 위젯 트리/디자인 토큰 사용은 최대한 유지. "화면을 갈아엎는" 변경은 하지 않음. 변경은 **데이터 소스(Repository/fixture/하드코딩) → API adapter**로 한정.

---

## 8. 수정해야 할 화면

> 데이터 소스 교체 + 가짜 로직 제거 + TODO 구현. 화면 구조 자체는 유지.

| 화면 | 수정 내용 | 우선순위 |
|------|-----------|---------|
| `LoginScreen` | `_login` → `AuthRepository.login`, 소셜/회원가입 콜백 연결, 토큰 저장 | 높음 |
| `HomeScreen` | `_quests`/`_discoveries`/`_banners`/`_logs` 하드코딩 → Repository 호출. `_HomeScreenState`에 비동기 로드 패턴 추가(`DiscoveryCardScreen` 패턴 적용) | 중 |
| `DiscoveryCardDetailScreen` | `sampleCardDetail` 직접 참조 → `CardDetailRepository.fetchById(id)`. `_onToggleFavorite` 로컬 → API. `_onObserveMore`/공유 TODO 구현 | 높음 |
| `MyPageScreen` | `MyPageFixture.sample` → `MyPageRepository.fetchSummary()`. `MyPageScreen`을 StatefulWidget으로 전환(비동기 로드) | 중 |
| `ProfileEditScreen` | `ProfileEditFixture.sample` → `UserRepository.fetchMe()`. `ProfileSaveButton`/`DeleteAccountButton`/각 섹션 카드 TODO → API | 중 |
| `QuestDetailScreen` | `QuestDetailFixture.springPlants` → `QuestRepository.fetchById(id)`. StatelessWidget → StatefulWidget 전환 | 중 |
| `AccountVerificationScreen(Password)` | `MockAccountVerificationRepository` → 실제 `AccountVerificationRepository` 구현체 | 높음 |
| `AccountVerificationScreen(Method/Social)` | 하드코딩 `AccountVerificationMethodData`/`SocialAccountVerificationData` → API(사용 가능한 인증 방법 조회) | 중 |
| `AnalysisStatusScreen` | **`_simulateAnalysis` 가짜 시뮬레이션 → 실제 폴링**(`AnalysisRepository.poll(jobId)`). 가짜 `Future.delayed` 제거 | 높음 |
| `CameraScreen` | 플레이스홀더 → `camera` 패키지 연동 + 촬영 이미지를 `PhotoPreviewScreen`에 전달 | 중 |
| `PhotoPreviewScreen` | 플레이스홀더 → 전달받은 이미지 표시 + "카드 만들기" → 업로드 API | 중 |
| `MapScreen` | 플레이스홀더 → 지도 SDK + 위치 API. 하드코딩 "서울숲" → API | 낮음(외부 SDK 의존) |
| `DiscoveryCardScreen` | (이미 Repository 사용) Mock 구현체 → 실제 구현체 교체만. 검색 TODO → 검색 API | 중 |

---

## 9. 새로 추가해야 할 화면 또는 컴포넌트

> 본 통합에서 **새 화면은 최소화**. 필요한 것만.

### 9.1 신규 화면 (필요 최소)

| 화면 | 사유 | 비고 |
|------|------|------|
| (회원가입 화면) | `LoginScreen` "회원가입" 연결점. 다이얼로그 또는 별도 화면 | 우선순위 중 |
| (비밀번호 재설정 화면) | `AccountVerificationScreen(Password).onForgotPassword` 연결점 | 우선순위 중 |
| (퀘스트 목록 화면) | `MyPageScreen` "퀘스트" shortcut(`TODO: quest list page`) | 우선순위 낮음 |
| (배지 목록 화면) | `MyPageScreen` "배지 전체보기"(`TODO: badge list page`) | 우선순위 낮음 |
| (관찰 기록 목록 화면) | `MyPageScreen` "관찰 기록" shortcut | 우선순위 낮음 |
| (좋아요 카드 목록 화면) | `MyPageScreen` "좋아요" shortcut | 우선순위 낮음 |

> 이 목록 화면들은 본 통합의 핵심이 아님. main의 기존 `DiscoveryCardScreen`/`QuestDetailScreen` 패턴을 복제하는 수준이므로, 백엔드 연동 후 필요 시점에 추가.

### 9.2 신규 컴포넌트/인프라 (필수)

| 컴포넌트 | 위치 | 역할 |
|---------|------|------|
| `ApiClient` (Dio 인스턴스) | `lib/data/api/api_client.dart` (또는 `lib/core/api/`) | HTTP 클라이언트, baseUrl, 인터셉터(토큰 주입/갱신/에러) |
| `AuthInterceptor` | `lib/data/api/auth_interceptor.dart` | 토큰 헤더 주입, 401 시 갱신/로그아웃 |
| `TokenStore` | `lib/data/api/token_store.dart` | `flutter_secure_storage` 기반 토큰 저장/조회/삭제 |
| 각 도메인 Repository 실제 구현체 | `lib/data/repositories/` 또는 각 `features/*/repositories/` | 인터페이스 구현, API 호출, 모델 매핑 |
| `Result<T>` 래퍼 (선택) | `lib/data/api/result.dart` | 성공/실패 캡슐화 (Dio 예외 → 도메인 에러) |
| `ApiError` 도메인 에러 | `lib/data/api/api_error.dart` | 네트워크/인증/서버/알 수 없음 분류 |
| 로딩/에러 공통 위젯 | `lib/components/` | `LoadingIndicator`, `ErrorRetryView`, `EmptyStateView` (현재 부재) |

### 9.3 홀로 카드 관련 신규 (별도 진행, frontend-porting-plan 참조)
- `HoloCardRender`, `HoloShineLayer`, `HoloGlareLayer`, `PointerMath`, `HoloGradeEffect`, `holo.frag`, `assets/holo_test/` — 본 통합과 독립적, 클라이언트 로직이므로 API 없음.

---

## 10. 제거해야 할 mock 데이터

> **무작정 제거 금지**. API 계약 기반 adapter로 교체 후 제거. 제거 순서는 12장/16장 참조.

### 10.1 Fixture 파일 (API 연동 검증 후 제거)

| 파일 | 제거 조건 | 제거 시점 |
|------|-----------|-----------|
| `lib/data/discovery_fixtures.dart` | `DiscoveryRepository` 실제 구현체가 API 호출로 교체 완료 후 | 16장 Phase 4 |
| `lib/features/card_detail/data/card_detail_fixtures.dart` | `CardDetailRepository` 연동 완료 후 | 16장 Phase 4 |
| `lib/features/my_page/data/my_page_fixture.dart` | `MyPageRepository` 연동 완료 후 | 16장 Phase 4 |
| `lib/features/profile_edit/data/profile_edit_fixture.dart` | `UserRepository` 연동 완료 후 | 16장 Phase 4 |
| `lib/features/quest_detail/data/quest_detail_fixture.dart` | `QuestRepository` 연동 완료 후 | 16장 Phase 4 |

### 10.2 화면 내 하드코딩 (Repository 경유로 교체 후 제거)

| 화면 | 제거 대상 | 제거 조건 |
|------|-----------|-----------|
| `home_screen.dart` | `_quests`/`_discoveries`/`_banners`/`_logs`/`_LogData`/`_BannerData`(데이터 부분) | 각 Repository 연동 후 |
| `account_verification_screen_method.dart` | `build` 내 `AccountVerificationMethodData` 하드코딩 | 인증 방법 조회 API 연동 후 |
| `account_verification_screen_social.dart` | `SocialAccountVerificationData` 하드코딩 | 동일 |
| `map_screen.dart` | "서울숲 가족마당" 등 하드코딩 문자열 | 위치 API 연동 후 |
| `plan_screen.dart` | `Plan` 하드코딩 | 구독 API 연동 후(본 범위 밖) |

### 10.3 가짜 시뮬레이션 (실제 폴링으로 교체 후 제거)

| 코드 | 제거 조건 |
|------|-----------|
| `analysis_status_screen.dart` `_simulateAnalysis`의 `Future.delayed` 루프 | `AnalysisRepository.poll` 연동 후 |

### 10.4 Mock Repository 구현체 (실제 구현체로 교체 후 제거 또는 보존)

| 코드 | 처리 |
|------|------|
| `MockAccountVerificationRepository` | 실제 구현체 추가 후, **테스트용으로 보존** 가능(주석 명시). 프로덕션에서는 실제 구현체 사용 |
| `DiscoveryRepository`(fixture 반환) | 실제 구현체로 교체. Mock은 테스트용 보존 또는 제거 |

> **주의**: Mock 구현체는 테스트 자산이 될 수 있으므로, 무조건 제거하지 않고 `test/` 또는 `Mock*` 접두사 유형으로 보존 검토.

---

## 11. API 계약 기반으로 교체해야 할 mock 데이터

> 핵심 전략: **fixture/Mock을 "API 계약(Contract)을 만족하는 Adapter"로 재포장한 뒤, 실제 API 구현체로 교체**. 이렇게 하면 화면 코드는 변경 없이 구현체만 교체 가능.

### 11.1 계약(Contract) = Repository 인터페이스

main-project에 이미 존재하는 인터페이스:
- `DiscoveryDataSource`(`discovery_repository.dart`) — `fetchByCategory`, `fetchAllGrouped`
- `AccountVerificationRepository` — `verifyPassword`

**확장 필요 인터페이스**(신규 작성, 기존 패턴 준수):
| 인터페이스 | 메서드 | 대응 API |
|-----------|-------|---------|
| `AuthRepository` | `login`, `signup`, `oauthLogin`, `resetPassword`, `reverifyPassword`, `reverifyOAuth`, `deleteAccount`, `refreshToken` | 7.1 |
| `UserRepository` | `fetchMe`, `updateMe`, `updateProfileImage`, `updatePassword`, `updateEmail`, `connectOAuth`, `disconnectOAuth`, `updateNotificationSettings`, `fetchSummary`, `fetchBadges` | 7.2 |
| `CardRepository` (또는 `CardDetailRepository`) | `fetchByCategory`, `fetchAllGrouped`, `search`, `fetchById`, `toggleFavorite`, `share` | 7.3 |
| `ObservationRepository` | `add`, `fetchAll`, `fetchDiscoveryRecord`, `fetchGradeConditions` | 7.5 |
| `QuestRepository` | `fetchToday`, `fetchAll`, `fetchById`, `fetchTargets`, `completeMission` | 7.6 |
| `AnalysisRepository` | `uploadImage`, `requestIdentify`, `pollResult`, `confirmCardCreation` | 7.4 |
| `LocationRepository` | `fetchByCard`, `startPlaceQuest` | 7.8 |
| (기존) `AccountVerificationRepository` | `verifyPassword` (확장: `fetchMethods`, `verifyOAuth`) | 7.1 |

### 11.2 Adapter = 인터페이스의 두 구현체

각 인터페이스마다 **두 개의 구현체**를 둔다:

1. **`Mock*Repository`** (또는 `Local*Repository`): 현재 fixture/Mock을 감싸는 구현체. **화면 코드 변경 없이 즉시 적용 가능**. 백엔드 구현 전까지 사용.
2. **`Api*Repository`** (또는 `Remote*Repository`): 실제 HTTP 호출 구현체. 백엔드 구현 후 교체.

**교체 방식**: 화면이 주입받는 Repository 인스턴스만 `Mock*` → `Api*`로 변경. 화면 코드는 수정 불필요(의존성 주입 덕분).

### 11.3 교체 대상 mock → adapter 매핑

| 현재 mock | 계약 인터페이스 | Mock adapter | Api adapter |
|-----------|----------------|--------------|-------------|
| `DiscoveryFixtures` + `DiscoveryRepository`(fixture 반환) | `CardRepository`(또는 기존 `DiscoveryDataSource` 확장) | `MockCardRepository`(fixture 감싸기) | `ApiCardRepository` |
| `sampleCardDetail` | `CardRepository.fetchById` | Mock에 포함 | Api에 포함 |
| `MyPageFixture.sample` | `UserRepository.fetchSummary` | `MockUserRepository` | `ApiUserRepository` |
| `ProfileEditFixture.sample` | `UserRepository.fetchMe` | 동일 | 동일 |
| `QuestDetailFixture.springPlants` | `QuestRepository.fetchById` | `MockQuestRepository` | `ApiQuestRepository` |
| `MockAccountVerificationRepository` | `AccountVerificationRepository` + `AuthRepository` | 기존 Mock 보존/확장 | `ApiAuthRepository` |
| `home_screen._quests` | `QuestRepository.fetchToday` | `MockQuestRepository` | `ApiQuestRepository` |
| `home_screen._discoveries` | `CardRepository.fetchRecent`(또는 요약) | `MockCardRepository` | `ApiCardRepository` |
| `analysis_status._simulateAnalysis` | `AnalysisRepository.pollResult` | `MockAnalysisRepository`(지연 + 가짜 단계) | `ApiAnalysisRepository` |

### 11.4 주의: 모델은 그대로, fixture만 adapter 내부로 이동
- **도메인 모델 클래스(`CardDetailData`, `MyPageData` 등)는 수정 없음**
- fixture 데이터는 `Mock*Repository` 내부로 이동(또는 별도 `*_fixtures.dart`를 Mock adapter가 import)
- 화면은 여전히 도메인 모델을 다룸 → 호환성 유지

---

## 12. 프론트와 백엔드의 경계

> **경계 원칙**: 프론트는 "계약(Contract) = Repository 인터페이스 + 도메인 모델"까지만 알고, "어떻게 데이터를 가져오는지(Mock/HTTP/로컬 저장)"는 모른다. 백엔드는 이 계약을 만족하는 API를 제공한다.

### 12.1 경계선

```
┌─────────────────────────────────────────────────────────┐
│ 프론트 (Flutter)                                          │
│                                                          │
│  화면(Screen) ── 주입 ──▶ Repository 인터페이스(Contract)  │
│                              ▲                           │
│                              │ 구현                       │
│              ┌───────────────┴───────────────┐           │
│              │                               │           │
│         Mock*Repository                Api*Repository     │
│         (fixture 감싸기)              (HTTP 호출)          │
│              │                               │           │
│         도메인 모델                    도메인 모델 +        │
│         (CardDetailData 등)          JSON 매핑            │
│                                              │           │
└──────────────────────────────────────────────┼───────────┘
                                               │
═══════════════════════════════════════════════╪═══════════
                                               │ HTTP/JSON
┌──────────────────────────────────────────────┼───────────┐
│ 백엔드 (API 서버)                             ▼           │
│                                              │           │
│         라우터 ──▶ 컨트롤러 ──▶ 서비스 ──▶ DB 모델          │
│                                              │           │
│         응답 JSON ──(계약에 맞춘 스키마)──▶ 프론트           │
└──────────────────────────────────────────────┘
```

### 12.2 계약의 양쪽 책임

| 측 | 책임 |
|----|------|
| 프론트 | 도메인 모델 정의, Repository 인터페이스 정의, 화면이 인터페이스에만 의존, Mock adapter로 목업 동작 보존 |
| 백엔드 | API 엔드포인트 제공, JSON 응답 스키마가 도메인 모델에 매핑 가능하도록 설계, 인증/에러 규약 준수 |
| 계약 문서 | `docs/sample-feature-requirements.md` 7장의 API 표(메서드/경로/요청/응답)가 양쪽의 공통 명세. 추후 `docs/sample-feature-backend-spec.md`로 정식화 권장 |

### 12.3 프론트가 백엔드에 요구하는 것
- REST 엔드포인트(requirements 7장)
- JSON 응답이 도메인 모델로 매핑 가능할 것(`CardDetailData` 필드와 1:1 또는 명시적 매핑)
- 인증: `Authorization: Bearer {token}` 헤더
- 에러 규약: HTTP 상태 코드 + 에러 본문(`{ code, message }`)
- 토큰 만료 시 `401` → 프론트가 자동 갱신 시도

### 12.4 백엔드가 프론트에 요구하는 것
- 표준 HTTP 메서드 준수
- 멀티파트 업로드는 `multipart/form-data`
- 폴링 간격 준수(분석 상태 등)
- 토큰 저장은 안전하게(`flutter_secure_storage`)

---

## 13. API client가 들어갈 위치

> main-project에 HTTP 클라이언트가 전무. 신규 도입 위치 제안.

### 13.1 제안 디렉토리 구조

```
lib/
├── data/
│   ├── api/                          ← 신규 (API 인프라)
│   │   ├── api_client.dart           ← Dio 인스턴스, baseUrl, 공통 헤더
│   │   ├── auth_interceptor.dart     ← 토큰 주입/갱신/401 처리
│   │   ├── token_store.dart          ← flutter_secure_storage 래퍼
│   │   ├── api_error.dart            ← 도메인 에러 분류
│   │   └── result.dart               ← Result<T> (선택, 성공/실패 래퍼)
│   ├── repositories/                 ← 신규 (실제 API 구현체)
│   │   ├── api_card_repository.dart
│   │   ├── api_auth_repository.dart
│   │   ├── api_user_repository.dart
│   │   ├── api_quest_repository.dart
│   │   ├── api_observation_repository.dart
│   │   ├── api_analysis_repository.dart
│   │   └── api_location_repository.dart
│   ├── mocks/                        ← 신규 (Mock adapter, fixture 감싸기)
│   │   ├── mock_card_repository.dart
│   │   ├── mock_auth_repository.dart
│   │   ├── mock_user_repository.dart
│   │   ├── mock_quest_repository.dart
│   │   ├── mock_analysis_repository.dart
│   │   └── ...
│   ├── discovery_fixtures.dart       ← 기존 (Mock adapter가 import, 최종 제거 대상)
│   └── discovery_repository.dart     ← 기존 (인터페이스는 유지, 구현체는 mocks/ 또는 repositories/로 이동 검토)
├── features/
│   ├── card_detail/
│   │   ├── data/
│   │   │   └── card_detail_fixtures.dart  ← 기존 (Mock adapter가 import)
│   │   └── repositories/             ← 신규 (feature 단위 인터페이스)
│   │       └── card_detail_repository.dart
│   └── ...
└── ...
```

### 13.2 ApiClient 설계 요점

```dart
// lib/data/api/api_client.dart (개념)
class ApiClient {
  static late final Dio _dio;
  static Future<void> init() async {
    _dio = Dio(BaseOptions(baseUrl: AppEnv.apiBaseUrl));
    _dio.interceptors.add(AuthInterceptor(await TokenStore.load()));
  }
  static Future<T> get<T>(String path, {Map<String, dynamic>? query, required T Function(Map<String, dynamic>) fromJson});
  static Future<T> post<T>(String path, {Object? body, required T Function(Map<String, dynamic>) fromJson});
  // ... patch, delete, multipart upload
}
```

### 13.3 환경 설정
- `AppEnv.apiBaseUrl` — `dev`/`prod` 분기 (본 통합에서는 상수 또는 `--dart-define` 사용, 추후 정식화)
- baseUrl은 백엔드 구현 전에는 미정 → Mock adapter 사용 시 불필요

### 13.4 의존성 추가 (본 통합 준비 단계에서)
- `dio: ^5.x`(또는 `http`) — HTTP 클라이언트
- `flutter_secure_storage: ^9.x` — 토큰 안전 저장
- (이미지 업로드/카메라 실구현 시) `image_picker`, `camera`, `path_provider` — 본 통합 준비 단계에서는 추가 안 함(실구현 단계에서)

> **주의**: 본 통합 계획의 "준비" 단계(15장/16장 Phase 1~3)에서는 dio/flutter_secure_storage 추가를 **최소화**하거나 지연. 먼저 인터페이스와 Mock adapter로 구조를 잡은 뒤, 실제 API 연결 단계에서 추가.

---

## 14. 상태관리/hook/controller가 들어갈 위치

> main-project는 상태관리 라이브러리 미사용. Flutter 기본 `StatefulWidget` + `setState` + `ValueNotifier` 유지. "hook"은 Flutter에 없으므로 state/controller로 해석.

### 14.1 화면 State (비동기 로드 패턴으로 통일)

현재 `DiscoveryCardScreen`/`AccountVerificationScreen(Password)`만 비동기 로드 패턴을 사용. 이 패턴을 **모든 데이터 조회 화면으로 확장**.

**표준 패턴(제안)**:
```dart
class _XScreenState extends State<XScreen> {
  final _repository = context.read<XRepository>(); // 또는 생성자 주입
  XData? _data;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await _repository.fetchX();
      if (mounted) setState(() { _data = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = '...'; _isLoading = false; });
    }
  }

  // build: _isLoading ? Loading : _error != null ? ErrorRetry : ContentView(_data)
}
```

**적용 화면**: `HomeScreen`, `DiscoveryCardDetailScreen`, `MyPageScreen`, `ProfileEditScreen`, `QuestDetailScreen`, `AnalysisStatusScreen`(폴링) 등.

### 14.2 전역 상태 (인증 토큰/사용자)

> 현재 전역 상태 없음. 백엔드 연동 시 필요.

**도입 옵션**(본 통합에서는 결정만, 구현은 16장 Phase 3 이후):

| 옵션 | 장단 | 비고 |
|------|------|------|
| A. `InheritedWidget`/`InheritedNotifier` | 라이브러리 불필요, main 철학에 부합 | 보일러플레이트 多 |
| B. `Provider` 패키지 | 가장 가벼운 상태관리, main 의존성 최소화 정신에 부합 | 신규 의존성 1개 |
| C. `Riverpod` | 강력하나 러닝커브/의존성 증가 | main 철학에 과잭 가능성 |

**제안**: **B(Provider) 최소 도입** — `ChangeNotifierProvider<AuthSession>` 1개만. 인증 토큰/사용자/로그아웃을 전역으로 관리. 다른 상태는 여전히 `setState` 유지. 단, 본 통합의 "준비" 단계에서는 Provider 도입조차 지연하고, 먼저 인터페이스와 Mock adapter로 구조 잡기.

### 14.3 컨트롤러(비즈니스 로직 캡슐화) 위치

> 복잡한 비동기 플로우(AI 분석 폴링, 인증 플로우)는 State에 직접 두면 복잡해짐. 별도 컨트롤러/서비스 클래스로 분리 검토.

| 컨트롤러 | 위치 | 역할 |
|---------|------|------|
| `AuthSession` | `lib/data/auth/auth_session.dart`(ChangeNotifier) | 로그인/로그아웃/토큰 갱신/사용자 정보 |
| `AnalysisFlowController` | `lib/features/analysis/analysis_flow_controller.dart` | 업로드→식별 요청→폴링→카드 생성 플로우 캡슐화 |

> 본 통합 준비 단계에서는 컨트롤러 도입을 **결정만** 하고 구현은 지연. 먼저 화면 State 내에서 로직을 구현하되, 복잡해지면 컨트롤러로 추출.

### 14.4 홀로 카드 State (별도, frontend-porting-plan 참조)
- `_HoloCardRenderState`(`ValueNotifier` + `AnimationController`) — API 무관, 클라이언트 자체 완결.

---

## 15. 실제 백엔드 구현 전에 필요한 프론트 준비 작업

> **이 단계가 본 통합 계획의 핵심**. 백엔드 구현 전에 프론트 구조를 "API 계약 기반"으로 정비해두면, 백엔드 완성 후 구현체만 교체하면 됨.

### 15.1 준비 작업 목록 (코드 수정 없이 계획만)

1. **도메인 모델 검토/보강**
   - 기존 모델(`CardDetailData` 등)이 API 응답과 매핑 가능한지 검토
   - 필요 시 `fromJson`/`toJson` 또는 `copyWith` 추가(현재는 `AccountVerificationState.copyWith`만 존재)
   - freezed/json_serializable 도입 여부 결정(본 통합에서는 기존 일반 클래스 유지, 수동 매핑)
   - **모델 클래스는 수정하지 않되**, 매핑 함수는 `Api*Repository` 내부에 둠

2. **Repository 인터페이스 정의/확장**
   - 기존: `DiscoveryDataSource`, `AccountVerificationRepository`
   - 신규: `AuthRepository`, `UserRepository`, `CardRepository`(또는 기존 확장), `ObservationRepository`, `QuestRepository`, `AnalysisRepository`, `LocationRepository`
   - 각 인터페이스의 메서드 시그니처를 requirements 7장 API에 맞춰 정의
   - 반환 타입은 도메인 모델(`CardDetailData`, `MyPageData` 등)

3. **Mock Adapter 구현**
   - 각 인터페이스의 `Mock*Repository` 구현체 작성
   - 기존 fixture/하드코딩을 Mock 내부로 이동(또는 fixture import)
   - 비동기 시그니처에 맞춰 `Future.delayed`로 지연 흉내(실제 네트워크 지연 시뮬레이션)
   - `AnalysisStatusScreen`의 `_simulateAnalysis` 로직을 `MockAnalysisRepository.pollResult`로 이동(화면은 폴링 호출만)

4. **화면의 Repository 주입 구조 정비**
   - 현재 "파라미터 주입 + fixture fallback" 패턴을 "Repository 주입"으로 통일
   - 예: `DiscoveryCardDetailScreen`의 `widget.data ?? sampleCardDetail` → `await _cardRepository.fetchById(id)` (Mock 주입)
   - 화면 State에 비동기 로드 패턴(14.1) 추가
   - **이 단계에서는 Mock adapter를 주입하므로 화면 동작은 동일** (목업 보존)

5. **로딩/에러/빈 상태 공통 위젯 추가**
   - 현재 부재. `LoadingIndicator`, `ErrorRetryView`, `EmptyStateView` 신규
   - 디자인 시스템(`AppColors`/`AppTextStyles`/`AppSpacing`) 준수
   - 모든 데이터 조회 화면에 적용

6. **에러 처리 표준화**
   - `try/catch` + `setState(_error)` 패턴을 공통화
   - 도메인 에러 타입(`ApiError`) 정의(네트워크/인증/서버/알 수 없음)
   - Mock adapter는 에러를 거의 발생시키지 않으므로, 실제 API 연동 시 본격 적용

7. **의존성 주입 통일**
   - 화면이 Repository를 어떻게 받을지 결정(생성자 주입 / `InheritedWidget` / Provider)
   - 본 준비 단계에서는 **생성자 주입 또는 화면 내 `const Mock*Repository()`**로 단순화
   - 추후 Provider 도입 시 `context.read`로 일원화

8. **가짜 시뮬레이션 제거**
   - `AnalysisStatusScreen._simulateAnalysis`를 `MockAnalysisRepository.pollResult`로 이동
   - 화면은 폴링 루프(`while`/`Stream`/재귀 `Future`)로 교체 — Mock은 여전히 가짜 단계를 반환하므로 **동작은 동일**
   - 이렇게 하면 백엔드 연동 시 `Mock` → `Api`만 교체하면 폴링이 자동으로 실제 동작

9. **토큰/인증 인프라 자리잡기(선택, 지연 가능)**
   - `TokenStore`(flutter_secure_storage 래퍼) 자리만 잡기
   - `AuthSession`(ChangeNotifier) 자리만 잡기
   - 실제 로그인 API 연동 전까지는 더미 토큰 사용
   - 본 준비 단계에서는 지연 가능(15.7 의존성 주입과 연계)

10. **문서 정비**
    - `docs/sample-feature-backend-spec.md`를 requirements 7장 기반으로 정식 작성(선택, 본 작업 범위 밖이나 권장)
    - API 스키마(JSON) 확정 → 프론트 매핑 함수 작성 기준

### 15.2 준비 작업의 성과
- 백엔드 구현과 무관하게 프론트 구조가 "API 계약 기반"으로 정리됨
- 화면 코드는 Repository 인터페이스에만 의존 → 백엔드 연동 시 화면 코드 수정 최소화
- Mock adapter로 목업 동작 100% 보존 → 디자인 검토/기획 변경 영향 최소
- 백엔드 완성 후 `Mock*` → `Api*` 교체만으로 통합 완료

---

## 16. 단계별 통합 순서

> 각 단계는 독립적으로 검증 가능. 백엔드 구현(Phase 5) 전까지 프론트가 "API 계약 기반 Mock"으로 동작.

### Phase 1 — 도메인 모델 검토 + 매핑 함수 자리잡기
**목표**: 모델은 수정 없이, 매핑 함수를 둘 자리를 확보.

1. 기존 도메인 모델(`CardDetailData`, `MyPageData`, `QuestDetailData`, `ProfileEditData`, `DiscoveryCard` 등)이 API 응답과 매핑 가능한지 검토
2. 필요 시 `fromJson` 팩토리/`copyWith`를 모델에 추가(현재 `AccountVerificationState.copyWith`만 존재)
3. 매핑 함수는 `Api*Repository` 내부에 둘 예정이므로, 이 단계에서는 모델에 `fromJson`만 추가(또는 별도 mapper 클래스 자리 잡기)
4. **검증**: 기존 화면 동작 변경 없음

> **주의**: 모델에 `fromJson`을 추가하는 것은 "코드 수정"이지만, 본 계획은 "코드 수정 없이 계획만"이므로 이 단계는 **계획만**. 실제 코드 수정은 본 계획서 확정 후 진행.

### Phase 2 — Repository 인터페이스 정의
**목표**: 모든 API 영역에 대해 인터페이스(계약)를 정의.

1. 기존 `DiscoveryDataSource`/`AccountVerificationRepository` 검토 및 확장
2. 신규 인터페이스 정의:
   - `AuthRepository`(`lib/data/repositories/auth_repository.dart` 또는 feature 내)
   - `UserRepository`
   - `CardRepository`(기존 `DiscoveryDataSource` 흡수 또는 별도)
   - `ObservationRepository`
   - `QuestRepository`
   - `AnalysisRepository`
   - `LocationRepository`
3. 각 인터페이스의 메서드 시그니처를 requirements 7장에 맞춤
4. 반환 타입은 도메인 모델
5. **검증**: 인터페이스 컴파일 성공, 화면 동작 변경 없음

### Phase 3 — Mock Adapter 구현
**목표**: 각 인터페이스의 Mock 구현체를 만들어 목업을 adapter로 감싸기. **화면 동작 100% 보존**.

1. `lib/data/mocks/` 디렉토리 신규
2. 각 인터페이스의 `Mock*Repository` 구현:
   - `MockCardRepository` — 기존 `DiscoveryFixtures` + `sampleCardDetail` 감싸기
   - `MockAuthRepository` — 가짜 로그인(항상 성공, 더미 토큰), 가짜 재인증(기존 `MockAccountVerificationRepository` 흡수)
   - `MockUserRepository` — `MyPageFixture`/`ProfileEditFixture` 감싸기
   - `MockQuestRepository` — `QuestDetailFixture` + `HomeScreen._quests` 하드코딩 이동
   - `MockAnalysisRepository` — `AnalysisStatusScreen._simulateAnalysis` 로직 흡수(지연 + 가짜 단계)
   - `MockObservationRepository`, `MockLocationRepository` 등
3. 기존 fixture 파일은 Mock adapter가 import하므로 유지(최종 제거는 Phase 5 이후)
4. **검증**: Mock adapter 단위 테스트, 기존 화면 동작과 동일

### Phase 4 — 화면의 Repository 주입 구조 정비
**목표**: 화면이 fixture/하드코딩을 직접 참조하지 않고 Repository(Mock) 경유. **목업 흐름 보존**.

1. `DiscoveryCardDetailScreen`: `widget.data ?? sampleCardDetail` → `await _cardRepository.fetchById(id)`(Mock 주입)
2. `MyPageScreen`: StatelessWidget → StatefulWidget 전환, `MyPageFixture.sample` → `_userRepository.fetchSummary()`
3. `ProfileEditScreen`: `ProfileEditFixture.sample` → `_userRepository.fetchMe()`
4. `QuestDetailScreen`: StatelessWidget → StatefulWidget, `QuestDetailFixture.springPlants` → `_questRepository.fetchById(id)`
5. `HomeScreen`: `_quests`/`_discoveries`/`_banners`/`_logs` → 각 Repository 호출
6. `LoginScreen._login`: 가짜 이동 → `_authRepository.login(email, password)` (Mock은 항상 성공, 더미 토큰)
7. `AnalysisStatusScreen._simulateAnalysis`: 제거, `_analysisRepository.pollResult(jobId)` 폴링 루프로 교체(Mock은 가짜 단계 반환)
8. 각 화면 State에 비동기 로드 패턴(14.1) 적용: `_isLoading`/`_error`/`_data`
9. 로딩/에러/빈 상태 공통 위젯(`LoadingIndicator`/`ErrorRetryView`/`EmptyStateView`) 신규 추가 및 적용
10. **검증**: 모든 화면이 Mock adapter 경유로 동작, 목업 시절과 동일한 사용자 경험. `flutter analyze` 통과

### Phase 5 — 백엔드 API 구현 (본 프론트 작업 범위 밖)
**목표**: 백엔드 개발자가 requirements 7장에 맞춰 API 구현.

1. API 서버 구현(엔드포인트/DB/인증)
2. JSON 응답 스키마 확정
3. 프론트와 스키마 매핑 검증(도메인 모델 ↔ JSON)
4. **프론트는 이 단계에서 대기** (또는 `docs/sample-feature-backend-spec.md` 정식 작성으로 스키마 확정)
5. **검증**: 백엔드 단위 테스트, 스키마 계약 준수

> **주의**: 이 단계는 본 프론트 통합 계획의 범위 밖. 백엔드 팀과 협력.

### Phase 6 — Mock Adapter → Real API Client 교체
**목표**: 실제 API 구현체(`Api*Repository`)를 만들고 Mock을 교체. **화면 코드 수정 최소화**.

1. 의존성 추가: `dio`, `flutter_secure_storage`
2. `lib/data/api/api_client.dart` 신규 — Dio 인스턴스, baseUrl, 인터셉터
3. `lib/data/api/auth_interceptor.dart` — 토큰 주입/갱신/401 처리
4. `lib/data/api/token_store.dart` — 토큰 저장
5. 각 `Api*Repository` 구현체 작성(`lib/data/repositories/`):
   - `ApiCardRepository` — `GET /cards` 등, JSON → `DiscoveryCard`/`CardDetailData` 매핑
   - `ApiAuthRepository` — `POST /auth/login` 등, 토큰 획득/저장
   - `ApiUserRepository`, `ApiQuestRepository`, `ApiAnalysisRepository`(실제 폴링), `ApiObservationRepository`, `ApiLocationRepository`
6. 화면에 주입되는 Repository 인스턴스를 `Mock*` → `Api*`로 교체(의존성 주입 지점만 변경)
7. `AuthSession`(ChangeNotifier) 도입 — 전역 인증 상태(옵션 B)
8. **검증**: 실제 백엔드 연동, 각 화면 동작, 토큰 갱신, 에러 처리
9. fixture 파일 제거(`discovery_fixtures.dart`, `*_fixtures.dart`) — Mock adapter가 더 이상 import 안 함. 단, Mock adapter 자체는 테스트용 보존 검토

### Phase 7 — 통합 테스트 + 외부 리소스 실구현
**목표**: end-to-end 검증 + 카메라/지도/이미지 업로드 실구현.

1. 통합 테스트: 각 화면의 API 흐름 end-to-end 검증
2. `CameraScreen` 실구현 — `camera` 패키지, 권한, 촬영 이미지를 `PhotoPreviewScreen`에 전달
3. `PhotoPreviewScreen` 실구현 — 이미지 표시 + `POST /uploads/image`
4. `MapScreen` 실구현 — 지도 SDK + `GET /locations`
5. `AnalysisStatusScreen` — `Mock` → `Api` 교체로 실제 폴링 동작
6. 이미지 업로드/카메라/지도 권한 설정(iOS/Android/macOS)
7. `flutter analyze` + `flutter test` + 실기기 검증
8. **검증**: 전체 기능 end-to-end, 성능, 에러 복구

---

## 다음 구현 단계 제안 (필수)

> 본 계획서 확정 후, 아래 7단계 순으로 실제 코드 작업을 진행할 것을 제안. **각 단계는 독립적으로 커밋/검증 가능**해야 함.

### 1. API contract type 정의
- **내용**: Phase 2에 해당. 각 도메인의 Repository 인터페이스(계약)를 `lib/data/repositories/` 또는 각 `features/*/repositories/`에 정의.
- **산출물**: `auth_repository.dart`, `user_repository.dart`, `card_repository.dart`, `quest_repository.dart`, `analysis_repository.dart`, `observation_repository.dart`, `location_repository.dart`(확장 `account_verification_repository.dart`)
- **검증**: 인터페이스 컴파일 성공, 기존 화면 동작 변경 없음.
- **비고**: 반환 타입은 기존 도메인 모델. 에러는 `Exception` 또는 `ApiError`(도메인 에러) 사용.

### 2. Mock adapter 생성
- **내용**: Phase 3에 해당. 각 인터페이스의 `Mock*Repository` 구현체를 `lib/data/mocks/`에 작성. 기존 fixture/하드코딩/가짜 시뮬레이션을 Mock 내부로 흡수.
- **산출물**: `mock_card_repository.dart`, `mock_auth_repository.dart`, `mock_user_repository.dart`, `mock_quest_repository.dart`, `mock_analysis_repository.dart` 등
- **검증**: Mock adapter 단위 테스트, 각 메서드가 기존 fixture와 동일한 데이터 반환, `Future.delayed`로 지연 흉내.
- **비고**: 기존 fixture 파일은 유지(Mock이 import). 화면 동작은 이 단계에서도 변경 없음.

### 3. API client 인터페이스 생성
- **내용**: Phase 6의 인프라 부분을 "인터페이스만" 먼저 잡기. 실제 HTTP 호출 구현은 6단계에서.
- **산출물**: `lib/data/api/api_client.dart`(Dio 인스턴스 자리, baseUrl 환경 변수), `token_store.dart`(인터페이스), `api_error.dart`(도메인 에러 타입)
- **검증**: 컴파일 성공. 실제 네트워크 호출은 아님.
- **비고**: 의존성(`dio`/`flutter_secure_storage`) 추가는 이 단계에서 또는 6단계에서. 본 제안에서는 인터페이스만 먼저 잡고 의존성은 6단계에서 추가하는 것을 권장(목업 단계에서 불필요한 의존성 최소화).

### 4. 목업 데이터를 adapter 기반으로 교체
- **내용**: Phase 4에 해당. 화면이 fixture/하드코딩을 직접 참조하지 않고 Mock Repository 경유하도록 수정. 비동기 로드 패턴 통일. 로딩/에러/빈 상태 위젯 추가.
- **산출물**: 각 화면 State 수정(`HomeScreen`/`DiscoveryCardDetailScreen`/`MyPageScreen`/`ProfileEditScreen`/`QuestDetailScreen`/`AnalysisStatusScreen`/`LoginScreen` 등), `LoadingIndicator`/`ErrorRetryView`/`EmptyStateView` 공통 위젯
- **검증**: 모든 화면이 Mock adapter 경유로 동작, 목업 시절과 동일한 사용자 경험, `flutter analyze` 통과.
- **비고**: 이 단계 완료 시 **프론트는 백엔드 무관하게 "API 계약 기반" 구조로 정리됨**. 백엔드 완성 후 구현체만 교체하면 됨.

### 5. 백엔드 API 구현
- **내용**: Phase 5에 해당. 백엔드 팀이 requirements 7장에 맞춰 API 구현.
- **산출물**: API 서버, DB 스키마, 인증 시스템, JSON 응답
- **검증**: 백엔드 단위/통합 테스트, 스키마가 프론트 도메인 모델과 매핑 가능.
- **비고**: **본 프론트 통합 계획의 범위 밖**. 백엔드 팀과 협력. 이 단계 동안 프론트는 대기 또는 다른 기능(홀로 카드 이식 등) 진행.

### 6. Mock adapter에서 real API client로 교체
- **내용**: Phase 6에 해당. `Api*Repository` 구현체 작성, 화면 주입을 `Mock*` → `Api*`로 교체.
- **산출물**: `api_card_repository.dart`, `api_auth_repository.dart`, `api_user_repository.dart`, `api_quest_repository.dart`, `api_analysis_repository.dart` 등, `AuthInterceptor`, `TokenStore` 실구현, `AuthSession`(전역 인증 상태)
- **검증**: 실제 백엔드 연동, 각 화면 동작, 토큰 갱신, 에러 처리. fixture 파일 제거(Mock이 더 이상 import 안 함).
- **비고**: 화면 코드는 거의 수정 없이 주입 지점만 교체(1~4단계에서 구조를 잡아둔 덕분).

### 7. 통합 테스트
- **내용**: Phase 7에 해당. end-to-end 검증 + 외부 리소스 실구현.
- **산출물**: 통합 테스트 코드, `CameraScreen`/`PhotoPreviewScreen`/`MapScreen` 실구현, 권한 설정, 실기기 검증
- **검증**: 전체 기능 end-to-end, 성능, 에러 복구, `flutter analyze` + `flutter test` 통과
- **비고**: 카메라/지도/이미지 업로드는 외부 SDK 의존이므로 권한/플랫폼 설정 수반.

---

## 부록: 주요 결정 사항 요약

| 결정 | 내용 | 근거 |
|------|------|------|
| 상태관리 | `setState` + `ValueNotifier` 유지, 전역 인증만 Provider(옵션 B) 최소 도입 검토 | main 의존성 최소화 철학 |
| HTTP 클라이언트 | Dio (실구현 단계에서 추가) | 인터셉터/FormData 지원 |
| 토큰 저장 | flutter_secure_storage | 안전한 저장 |
| 모델 | 기존 일반 클래스 유지, 수동 `fromJson` 매핑 | freezed 도입은 과잉 |
| Mock 보존 | `Mock*Repository`를 테스트 자산으로 보존 검토 | 무작정 제거 금지 |
| 가짜 시뮬레이션 | `AnalysisStatusScreen._simulateAnalysis`를 `MockAnalysisRepository`로 이동 후, 6단계에서 `Api*`로 교체 | 화면 코드 수정 최소화 |
| 홀로 카드 | 본 통합과 독립, `frontend-porting-plan.md`로 별도 진행 | 클라이언트 로직, API 무관 |
| 백엔드 구현 | 본 프론트 통합 계획 범위 밖 (Phase 5) | 백엔드 팀과 협력 |
| 문서 | `sample-feature-backend-spec.md` 정식 작성 권장(requirements 7장 기반) | 스키마 확정 |

---

*본 문서는 통합 계획만 작성하며, 코드 수정은 수반하지 않습니다. main-project의 목업 흐름을 보존하면서 API 계약 기반 구조로 전환하는 것을 핵심 원칙으로 합니다. 실제 백엔드 구현/연결은 "다음 구현 단계 제안"의 5~6단계에서 별도 진행합니다.*
