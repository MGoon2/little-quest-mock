# Little Quest Backend Required Library

> 작성 목적: 현재 목업 Flutter 프로젝트를 실제 백엔드에 연결하기 위해 필요한 클라이언트 준비사항, 라이브러리 후보, API 목록, 우선순위를 정리한다.
>
> 범위: 현재 코드 기준 조사 문서 `docs/little-quest-new-architecture-analize.md`와 `lib/`의 mock/fixture/TODO 접점.
>
> 원칙: 이 문서는 요구사항 목록이며, 이번 작업에서 dependency 추가나 코드 변경은 하지 않는다.

화면 파일별 상세 API 표는 `docs/little-quest-screen-api-list.md`에 분리한다. 이 문서는 도메인/인프라 관점의 상위 목록이고, 화면별 문서는 각 View 컴포넌트의 전송 데이터, 수신 데이터, method, 주의사항을 다룬다.

## 1. 현재 결론

현재 `pubspec.yaml`의 runtime dependency는 Flutter SDK, `cupertino_icons`, `url_launcher`뿐이다. API 연결에 필요한 HTTP client, token storage, JSON serialization, image picker/camera, location/map, secure storage, logging/observability, state management 패키지는 없다.

백엔드 연결을 시작하려면 먼저 다음 기반이 필요하다.

1. `core/network`: base URL, headers, auth interceptor, timeout, error mapping, retry policy.
2. `core/storage`: access/refresh token, reauth token, user/child selection 등 민감 상태 저장.
3. feature별 `data/datasources`와 `data/repositories`: fixture fallback을 실제 API adapter로 교체.
4. DTO/mapper: 서버 응답과 현재 UI model 사이 변환.
5. 공통 UI state: loading, empty, error, retry, unauthorized, reauth required, upload progress.
6. backend API contract: 아래 목록의 endpoint, request/response, auth scope, error code 합의.

## 2. 라이브러리/인프라 후보

아래는 “필요 역할” 목록이다. 실제 package 도입은 별도 작업에서 하나씩 검증한다.

| 역할 | 현재 상태 | 후보/방향 | 필요한 이유 |
| --- | --- | --- | --- |
| HTTP client | 없음 | `dio` 또는 `http` | REST API 호출, interceptor, timeout, multipart upload |
| JSON serialization | 없음 | `json_serializable` + `build_runner` 또는 수동 mapper | API DTO 변환 안정화 |
| Secure token storage | 없음 | `flutter_secure_storage` 계열 | access/refresh token, reauth token 저장 |
| Environment config | `String.fromEnvironment('LQ_INITIAL_ROUTE')`만 있음 | dart define 기반 `app/env` 또는 dotenv 후보 | API base URL, flavor별 설정 |
| Auth/session manager | 없음 | custom service under `core/auth`/`core/storage` | login, refresh, logout, auth guard |
| State management | local `setState` | 기존 패턴 유지 후 필요 시 Provider/Riverpod 검토 | API loading/error 공유 범위가 커질 때 |
| Camera/image picker | placeholder | `camera` 또는 `image_picker` | 실제 촬영/앨범 선택 |
| Image upload | 없음 | HTTP multipart + upload progress | 분석/카드 생성용 사진 업로드 |
| Location | placeholder | `geolocator` 등 | 발견 위치 기록, 지도 pin |
| Map | placeholder | `google_maps_flutter` 또는 `flutter_map` | 탐험 지도 표시 |
| Social auth | button만 있음 | Google/Apple/Naver/Kakao SDK 또는 backend OAuth bridge | 로그인/가입/재인증 |
| In-app purchase/payment | plan mock | platform billing 또는 web billing redirect | 구독/결제 관리 |
| WebView/terms | TODO | `webview_flutter` 또는 external URL | 약관/개인정보/동의 상세 |
| Logging/analytics | 없음 | backend logging API 또는 crash/analytics SDK | API 장애 추적 |

필수 선행 결정:

- API는 REST 기준으로 설계할지, GraphQL/BFF를 둘지.
- 인증은 access/refresh token 방식인지, session cookie 방식인지.
- OAuth는 앱에서 provider SDK를 직접 붙일지, backend hosted OAuth bridge를 열지.
- 사진 분석은 동기 응답인지, upload 후 job polling인지.
- 위치 정보 정밀도는 child safety 관점에서 어느 수준까지 저장할지.

## 3. API 설계 공통 규칙 후보

| 항목 | 제안 |
| --- | --- |
| API prefix | `/api/v1` |
| 인증 헤더 | `Authorization: Bearer {accessToken}` |
| 날짜 형식 | ISO-8601 UTC 저장, 클라이언트 locale 표시 |
| pagination | `cursor`, `limit`, `nextCursor` |
| 에러 형식 | `{ code, message, details?, traceId? }` |
| 이미지 업로드 | multipart upload 또는 pre-signed URL 중 택일 |
| 권한 | child user, guardian user, reauthenticated guardian scope 분리 |
| 삭제 API | soft delete/retention policy와 hard delete 요청 상태 분리 |
| 민감 작업 | reauth token 또는 recent reauthenticated session 요구 |

## 4. API 목록

### 4.1 Auth / Session

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `POST /api/v1/auth/login` | 이메일/아이디 + 비밀번호 로그인 | `login_screen.dart` `_login()` |
| P0 | `POST /api/v1/auth/refresh` | access token 재발급 | 현재 없음, 모든 API 전제 |
| P0 | `POST /api/v1/auth/logout` | 현재 기기 로그아웃 | parent settings/logout TODO |
| P1 | `POST /api/v1/auth/logout-all` | 다른 모든 기기 로그아웃 | `parent_account_security_page.dart` |
| P0 | `GET /api/v1/auth/session` | 앱 시작 시 세션/사용자/모드 상태 확인 | route guard 필요 |
| P1 | `POST /api/v1/auth/password/reset/request` | 비밀번호 찾기/재설정 요청 | login/account verification TODO |
| P1 | `POST /api/v1/auth/password/reset/confirm` | reset token으로 비밀번호 변경 | password flow TODO |
| P0 | `POST /api/v1/auth/reverify/password` | 민감 작업 전 비밀번호 재인증 | `MockAccountVerificationRepository` |
| P1 | `POST /api/v1/auth/reverify/oauth/{provider}` | 소셜 재인증 | account verification social TODO, parent verify TODO |

### 4.2 Signup / Terms

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `POST /api/v1/auth/signup/pre-register` | 이메일, 비밀번호, 이름, 생년월일, 약관 동의 사전 등록 | `email_signup_page.dart` |
| P0 | `POST /api/v1/auth/signup/email/verify/request` | 이메일 인증 코드 발송 | email signup TODO |
| P0 | `POST /api/v1/auth/signup/email/verify/confirm` | 이메일 인증 완료 | email signup TODO |
| P1 | `POST /api/v1/auth/signup/oauth/{provider}` | Google/Apple/Naver/Kakao 가입 | `signup_method_page.dart` |
| P0 | `GET /api/v1/legal/terms/current` | 현재 이용약관 조회 | signup agreement TODO |
| P0 | `GET /api/v1/legal/privacy/current` | 현재 개인정보 처리방침 조회 | signup agreement TODO |
| P1 | `POST /api/v1/users/me/agreements` | 선택 동의 변경/저장 | parent/profile consent 확장 |

### 4.3 User / Profile / My Page

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/users/me` | 내 프로필 조회 | `profile_edit_screen.dart` |
| P0 | `PATCH /api/v1/users/me` | 닉네임, 소개, 생년월일, 성별, 언어 수정 | profile edit TODO |
| P1 | `POST /api/v1/users/me/profile-image` | 프로필 이미지 변경 | `profile_edit_header_card.dart` |
| P0 | `GET /api/v1/users/me/summary` | 마이페이지 요약, 레벨, 통계, 최근 관찰, 배지 | `my_page_screen.dart` |
| P1 | `GET /api/v1/users/me/badges` | 배지 목록 | my page badge TODO |
| P1 | `GET /api/v1/users/me/observations` | 내 관찰 기록 목록 | my page observation TODO |
| P1 | `GET /api/v1/users/me/favorites` | 즐겨찾기 카드 목록 | my page favorite TODO |
| P1 | `PATCH /api/v1/users/me/notification-settings` | 알림 설정 변경 | profile/parent settings TODO |
| P1 | `POST /api/v1/users/me/social-accounts/{provider}/connect` | 소셜 계정 연결 | profile connected accounts TODO |
| P1 | `DELETE /api/v1/users/me/social-accounts/{provider}` | 소셜 계정 연결 해제 | profile connected accounts TODO |

### 4.4 Discovery Cards

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/cards` | 카드 목록, category/search/cursor filter | `DiscoveryRepository.fetchByCategory` |
| P0 | `GET /api/v1/cards/grouped` | 카테고리별 카드 그룹 | `DiscoveryRepository.fetchAllGrouped` |
| P0 | `GET /api/v1/cards/{cardId}` | 카드 상세 | `discovery_card_detail_screen.dart` |
| P1 | `POST /api/v1/cards` | 분석 완료 후 카드 생성 확정 | analysis completion flow |
| P1 | `PATCH /api/v1/cards/{cardId}` | 카드 메모/대표 이미지 등 수정 | 상세 편집 확장 |
| P1 | `DELETE /api/v1/cards/{cardId}` | 개별 카드 삭제 | parent data management 확장 |
| P0 | `PUT /api/v1/cards/{cardId}/favorite` | favorite 켜기 | detail favorite TODO |
| P0 | `DELETE /api/v1/cards/{cardId}/favorite` | favorite 끄기 | detail favorite TODO |
| P1 | `POST /api/v1/cards/{cardId}/share` | 공유 링크/공유 이벤트 생성 | detail share TODO |
| P1 | `GET /api/v1/cards/{cardId}/grade-conditions` | Holo 등급 조건 | card detail fixture |
| P1 | `GET /api/v1/cards/recent` | Home 최근 발견 | `home_screen.dart` `_discoveries` |

### 4.5 Observation / Photo / AI Analysis

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `POST /api/v1/uploads/images` | 사진 업로드 | camera/photo preview flow |
| P0 | `POST /api/v1/analysis/jobs` | 업로드 이미지 분석 job 생성 | `analysis_status_screen.dart` |
| P0 | `GET /api/v1/analysis/jobs/{jobId}` | 분석 진행 상태 polling | `_simulateAnalysis()` 대체 |
| P0 | `POST /api/v1/analysis/jobs/{jobId}/confirm-card` | 분석 결과를 카드로 저장 | analysis 완료 후 카드 확인 |
| P1 | `DELETE /api/v1/analysis/jobs/{jobId}` | 분석 취소/폐기 | camera flow 확장 |
| P0 | `GET /api/v1/cards/{cardId}/observations` | 재관찰 기록 목록 | card detail observation history |
| P0 | `POST /api/v1/cards/{cardId}/observations` | 재관찰 기록 추가 | detail/camera TODO |
| P1 | `GET /api/v1/observations/{observationId}` | 관찰 기록 상세 | detail record TODO |
| P1 | `DELETE /api/v1/observations/{observationId}` | 관찰 기록 삭제 | parent data management 확장 |

분석 job response에 필요한 필드:

- `jobId`
- `status`: `queued`, `uploading`, `analyzing`, `review_required`, `succeeded`, `failed`, `cancelled`
- `progressPercent`
- `currentStepLabel`
- `detectedSubject`: name, category, confidence, safety warnings
- `candidateCard`
- `error`

### 4.6 Quest

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/quests/today` | Home 오늘의 퀘스트 | `home_screen.dart` `_quests` |
| P0 | `GET /api/v1/quests/{questId}` | 퀘스트 상세 | `QuestDetailFixture.springPlants` |
| P1 | `GET /api/v1/quests/{questId}/targets` | 퀘스트 대상 목록 | quest target TODO |
| P1 | `POST /api/v1/quests/{questId}/missions/{missionId}/complete` | 미션 완료 처리 | quest mission TODO |
| P1 | `GET /api/v1/quests/history` | 완료/진행 퀘스트 목록 | my page quest TODO |
| P1 | `POST /api/v1/quests/{questId}/share` | 퀘스트 공유 | quest app bar TODO |

### 4.7 Home / Banner / Activity

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/home` | Home 화면 aggregate: greeting, quests, discoveries, banners, logs | `home_screen.dart` |
| P1 | `GET /api/v1/home/banners` | 배너 목록 | `_banners` |
| P1 | `POST /api/v1/home/banners/{bannerId}/click` | 배너 클릭 추적 | banner URL/route action |
| P1 | `GET /api/v1/activity/logs` | 위치/탐험 활동 로그 | `_logs` |
| P1 | `GET /api/v1/notifications` | 알림 목록 | Home/MyPage/Parent app bar TODO |

## 5. Parent Mode API 목록

Parent mode는 아이 개인정보, 보호자 정보, 위치, 사진, 결제, 삭제를 다루므로 auth scope와 reauth 정책이 별도로 필요하다.

### 5.1 Parent Session / Verification

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `POST /api/v1/parent/reverify/password` | 보호자 비밀번호 재확인 | `parent_verification_page.dart` |
| P1 | `POST /api/v1/parent/reverify/oauth/{provider}` | Google/Apple 보호자 재확인 | parent social verify TODO |
| P0 | `GET /api/v1/parent/dashboard` | 보호자 홈 aggregate | `ParentModeFixture.childSummary`, record/subscription/menu |

### 5.2 Children

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/parent/children` | 아이 목록 | `parentChildProfiles` |
| P0 | `GET /api/v1/parent/children/{childId}` | 아이 상세 | dynamic route `/parent/children/{childId}` |
| P1 | `POST /api/v1/parent/children` | 아이 추가 | child list TODO |
| P1 | `PATCH /api/v1/parent/children/{childId}` | 아이 정보 수정 | child info TODO |
| P1 | `PATCH /api/v1/parent/children/{childId}/selected` | 현재 선택 아이 변경 | child list selected state |

### 5.3 Guardian Info / Security

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/parent/guardian` | 보호자 정보 조회 | `parentGuardianProfile` |
| P1 | `PATCH /api/v1/parent/guardian` | 보호자 연락처/관계/알림 설정 저장 | guardian info TODO |
| P0 | `GET /api/v1/parent/security/login-methods` | 연결된 로그인 방법 | `parentLoginMethods` |
| P0 | `GET /api/v1/parent/security/login-history` | 최근 로그인 이력 | `parentLoginHistoryItems` |
| P1 | `POST /api/v1/parent/security/logout-all-devices` | 모든 기기 로그아웃 | account security TODO |
| P1 | `PATCH /api/v1/parent/security/password` | 비밀번호 변경 | account security flow TODO |

### 5.4 Consent / Privacy

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/parent/consents` | 동의 상태 조회 | `ParentModeFixture.consentStatuses` |
| P0 | `PATCH /api/v1/parent/consents/{consentType}` | 선택 동의 변경 | privacy consent TODO |
| P0 | `GET /api/v1/parent/privacy/sections` | 개인정보 관리 섹션 | `ParentModeFixture.privacySections` |
| P1 | `GET /api/v1/parent/consents/{consentType}/document` | 상세 동의 문서 | 상세 동의 WebView TODO |

### 5.5 Records / Location

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/parent/records/summary` | 사진/카드/장소 수 요약 | `ParentModeFixture.recordSummary` |
| P0 | `GET /api/v1/parent/records/photos` | 최근 사진/카드 기록 | `ParentModeFixture.recentPhotos` |
| P1 | `GET /api/v1/parent/records/cards` | 아이 카드 기록 관리 | records page TODO |
| P0 | `GET /api/v1/parent/location-records` | 위치 기록 목록/pins | `ParentModeFixture.locationPins` |
| P1 | `PATCH /api/v1/parent/location-settings` | 위치 기록 설정 | location page TODO |

### 5.6 Subscription / Payment

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/parent/subscription` | 현재 구독 상태 | `ParentModeFixture.subscriptionSummary` |
| P1 | `GET /api/v1/plans` | 플랜/가격/혜택 목록 | `plan_screen.dart`, parent subscription |
| P1 | `POST /api/v1/parent/subscription/checkout` | 구독 결제 시작 | subscription page TODO |
| P1 | `POST /api/v1/parent/subscription/cancel` | 구독 해지 | subscription page TODO |
| P1 | `GET /api/v1/parent/payment-methods` | 결제 수단 목록 | payment management TODO |
| P1 | `POST /api/v1/parent/payment-methods/manage-session` | 결제 수단 관리 세션 | payment management TODO |

### 5.7 Data Management / Account Deletion

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `POST /api/v1/parent/data-deletion/photo-cards` | 사진 및 카드 삭제 요청 | `parent_data_management_page.dart` |
| P0 | `POST /api/v1/parent/data-deletion/location-records` | 위치 기록 삭제 요청 | data management TODO |
| P0 | `POST /api/v1/parent/data-deletion/analysis-data` | AI 분석 데이터 삭제 요청 | data management TODO |
| P0 | `POST /api/v1/parent/data-deletion/all` | 전체 데이터 삭제 요청 | data management TODO |
| P0 | `POST /api/v1/parent/account-deletion/request` | 보호자 재인증 후 계정 삭제 요청 | account delete TODO |
| P1 | `GET /api/v1/parent/data-export` | 데이터 내보내기 | child safety/privacy 확장 |
| P1 | `GET /api/v1/parent/deletion-requests/{requestId}` | 삭제 요청 처리 상태 | 삭제가 비동기일 경우 |

## 6. Map / Location API

| 우선순위 | API | 용도 | 현재 접점 |
| --- | --- | --- | --- |
| P0 | `GET /api/v1/locations/nearby` | 현재 위치 주변 탐험 장소/퀘스트 | `map_screen.dart` |
| P1 | `GET /api/v1/locations/{locationId}` | 위치 상세 | map floating card 확장 |
| P1 | `POST /api/v1/locations/{locationId}/start-quest` | 특정 위치에서 퀘스트 시작 | map primary button |
| P1 | `POST /api/v1/location-records` | 발견 위치 기록 저장 | observation/card creation |
| P1 | `DELETE /api/v1/location-records/{recordId}` | 위치 기록 삭제 | parent location/data management |

위치 저장 정책은 child safety 문서와 함께 확정해야 한다. 현재 parent mode copy는 장소/동 단위 표시를 암시하므로 정밀 좌표를 서버에 저장할지, coarse-grained location만 저장할지 결정이 필요하다.

## 7. API 연동 우선순위 제안

### Phase 0: 계약/기반

- API prefix, auth/session, error response 형식 확정
- HTTP client, token storage, environment config 설계
- DTO/mapper 규칙 확정
- route guard와 reauth required UX 정의

### Phase 1: 실제 동작처럼 보이는 fake flow 제거

- `POST /auth/login`, `GET /auth/session`, `POST /auth/refresh`
- `POST /uploads/images`, `POST /analysis/jobs`, `GET /analysis/jobs/{jobId}`
- `POST /auth/reverify/password`, parent reverify

### Phase 2: fixture 목록/상세 교체

- Discovery list/detail/favorite
- My page summary
- Quest detail/today quests
- Profile get/patch

### Phase 3: Parent mode 민감 기능

- children, guardian, consent, records, location, subscription, deletion
- audit log, reauth scope, delete request status

### Phase 4: 부가 기능

- banners/click tracking
- notifications
- share links
- payment method management
- data export

## 8. 프론트 코드 변경 전 체크리스트

- [ ] 백엔드 endpoint 이름과 request/response schema 확정
- [ ] access token, refresh token, reauth token 저장 위치 확정
- [ ] 네트워크 에러 code와 사용자 메시지 매핑 확정
- [ ] fixture fallback 유지 기간 결정
- [ ] 서버 DTO와 UI model mapper 위치 결정
- [ ] `DiscoveryCard` 모델/위젯 이름 충돌 처리 방침 결정
- [ ] `/card-detail` 진입 시 `cardId` 전달 방식 확정
- [ ] parent mode 권한과 child safety policy 확정
- [ ] API 연동 전 route smoke/widget test 보강

## 9. 이번 문서 작업에서 변경하지 않은 것

- `pubspec.yaml` dependency 추가 없음
- Dart 코드 변경 없음
- route 변경 없음
- fixture 삭제 없음
- 기존 문서 수정 없음
- API client 구현 없음
