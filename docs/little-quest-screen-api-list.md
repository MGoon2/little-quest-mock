# Little Quest Screen API List

> 작성 목적: 현재 목업 화면과 View 컴포넌트가 로드하거나 전송해야 할 백엔드 API를 화면 파일명 기준으로 정리한다.
>
> 참고 문서: `docs/little-quest-new-architecture-analize.md`, `docs/little-quest-backend-required-library.md`
>
> 전제: endpoint는 계약 초안이다. 실제 구현 전 백엔드 prefix, 인증 방식, DTO 이름, error code를 확정해야 한다.

## 1. 공통 규칙

| 항목 | 내용 |
| --- | --- |
| API prefix | `/api/v1` 후보 |
| 인증 | 로그인 후 화면은 `Authorization: Bearer {accessToken}` 필요 |
| 전송 데이터 표기 | `path`, `query`, `body`, `multipart`, `header` 단위로 기재 |
| 수신 데이터 표기 | 화면과 View 컴포넌트가 표시하거나 상태 변경에 필요한 필드 중심 |
| 공통 응답 상태 | loading, empty, error, unauthorized, reauthRequired, retry 지원 필요 |
| 날짜 | 서버는 ISO-8601 UTC, View는 locale 표시 문자열로 변환 |
| UI 전용 타입 | `IconData`, `Color`는 서버 DTO에 직접 넣지 말고 `iconKey`, `colorToken`으로 수신 |

## 2. 화면 파일별 API 목록

### `lib/screens/welcome_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 앱 시작 진입 판단 | `GET` | `/api/v1/auth/session` | `header: accessToken optional` | `authenticated`, `userId`, `defaultMode`, `selectedChildId`, `requiresOnboarding` | 현재 화면은 정적이지만 실제 앱에서는 로그인 유지 여부에 따라 `/home`, `/mode-selection`, `/login` 분기 가능 |
| 약관/정책 표시 필요 시 | `GET` | `/api/v1/legal/app-notices` | `query: locale`, `appVersion` | `notices[]`, `forceUpdate`, `maintenance` | 현재 목업에는 없지만 첫 진입 공지/점검/강제 업데이트가 필요할 수 있음 |

### `lib/screens/mode_selection_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 모드 선택 전 사용자 상태 | `GET` | `/api/v1/users/me/modes` | `header: accessToken` | `availableModes[]`, `hasGuardianProfile`, `hasChildProfile`, `selectedChildId` | 아이 모드와 부모 모드 노출 조건을 서버 상태와 맞춰야 함 |
| 아이 모드 시작 | `PATCH` | `/api/v1/users/me/current-mode` | `body: mode=child`, `selectedChildId optional` | `mode`, `nextRoute`, `selectedChild` | 현재는 바로 `/home`으로 이동. 실제로는 선택 가능한 아이가 없는 경우 생성/초대 flow 필요 |
| 부모 모드 시작 | `PATCH` | `/api/v1/users/me/current-mode` | `body: mode=parent` | `mode`, `requiresParentReauth`, `nextRoute` | 보호자 모드는 재인증 요구 여부를 서버가 판단해야 함 |

### `lib/screens/login_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 이메일/아이디 로그인 카드 | `POST` | `/api/v1/auth/login` | `body: identifier`, `password`, `rememberMe`, `deviceInfo` | `accessToken`, `refreshToken`, `user`, `defaultMode`, `selectedChildId` | 현재 `_login()`은 검증 없이 Home으로 이동하므로 P0로 교체 |
| 소셜 로그인 버튼 Naver/Apple/Google | `POST` | `/api/v1/auth/oauth/{provider}` | `body: provider`, `oauthCode` 또는 `idToken`, `redirectUri`, `deviceInfo` | `accessToken`, `refreshToken`, `user`, `isNewUser`, `requiresAgreement` | provider SDK를 앱에 붙일지 backend hosted OAuth를 쓸지 결정 필요 |
| 비밀번호 찾기 | `POST` | `/api/v1/auth/password/reset/request` | `body: emailOrId` | `requestId`, `maskedDestination`, `expiresAt` | 현재 `onTap` 비어 있음. abuse 방지를 위한 rate limit 필요 |
| 로그인 상태 유지 | `POST` | `/api/v1/auth/refresh` | `body/header: refreshToken` | `accessToken`, `refreshToken?`, `expiresAt` | token rotation과 secure storage 필요 |

### `lib/features/signup/presentation/pages/signup_method_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 가입 provider 목록 | `GET` | `/api/v1/auth/signup/providers` | `query: locale`, `platform` | `providers[]`, `displayName`, `enabled`, `maintenanceReason` | 현재 provider 버튼은 하드코딩. 국가/플랫폼별 노출 제어 필요 |
| Google/Apple/Naver/Kakao 가입 | `POST` | `/api/v1/auth/signup/oauth/{provider}` | `body: oauthCode` 또는 `idToken`, `agreements[]`, `deviceInfo` | `accessToken?`, `signupSessionId?`, `requiresEmail`, `requiresGuardianConsent` | 아동 서비스라 보호자 동의 분기 가능성을 응답에 포함 |
| 로그인 화면 이동 전 상태 | `GET` | `/api/v1/auth/session` | `header: accessToken optional` | `authenticated`, `nextRoute` | 이미 로그인된 사용자가 가입 화면에 접근할 때 redirect 정책 필요 |

### `lib/features/signup/presentation/pages/email_signup_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 이메일 회원가입 form | `POST` | `/api/v1/auth/signup/pre-register` | `body: email`, `password`, `name`, `nickname`, `birthDate`, `agreements[]` | `signupSessionId`, `emailVerificationRequired`, `expiresAt` | 클라이언트 validation과 서버 validation 메시지 code를 맞춰야 함 |
| 이메일 중복/형식 확인 | `GET` | `/api/v1/auth/signup/email/check` | `query: email` | `available`, `reasonCode?` | 입력 중 debounce API로 둘지 제출 시 검증으로 둘지 결정 필요 |
| 닉네임 중복 확인 | `GET` | `/api/v1/users/nicknames/check` | `query: nickname` | `available`, `suggestions[]?` | 목업에는 없음. 저장 전 서버 제약 검증 필요 |
| 이용약관 상세 | `GET` | `/api/v1/legal/terms/current` | `query: locale`, `version optional` | `id`, `version`, `title`, `contentUrl` 또는 `contentHtml`, `required` | WebView 또는 앱 내 bottom sheet로 표시 |
| 개인정보 수집 상세 | `GET` | `/api/v1/legal/privacy/current` | `query: locale`, `version optional` | `id`, `version`, `title`, `contentUrl` 또는 `contentHtml`, `required` | 동의한 약관 version을 pre-register에 함께 보내야 함 |

### `lib/screens/home_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| Home aggregate | `GET` | `/api/v1/home` | `header: accessToken`, `query: childId optional` | `greeting`, `todayQuests[]`, `recentDiscoveries[]`, `banners[]`, `activityLogs[]`, `notificationUnreadCount` | 현재 `_quests`, `_discoveries`, `_banners`, `_logs`를 한 번에 대체 가능 |
| 오늘의 퀘스트 카드 | `GET` | `/api/v1/quests/today` | `query: childId optional`, `date` | `quests[]`: `id`, `title`, `description`, `current`, `total`, `isCompleted` | Home aggregate를 쓰면 별도 호출은 불필요. 독립 refresh를 고려하면 분리 |
| 최근 발견 카드 View | `GET` | `/api/v1/cards/recent` | `query: childId optional`, `limit`, `cursor` | `cards[]`: `id`, `name`, `categoryLabel`, `imageUrl`, `isNew`, `iconKey`, `colorToken` | 현재 `DiscoveryCardItem`은 `IconData`, `Color` 포함이라 mapper 필요 |
| 배너 carousel | `GET` | `/api/v1/home/banners` | `query: locale`, `childId optional`, `appVersion` | `banners[]`: `id`, `title`, `subtitle`, `imageUrl`, `routeName?`, `externalUrl?`, `gradientTokens?` | 외부 URL은 allowlist 필요. 현재 `windsurf.com` 하드코딩 |
| 배너 클릭 | `POST` | `/api/v1/home/banners/{bannerId}/click` | `path: bannerId`, `body: destinationType`, `destination` | `accepted`, `redirectUrl?`, `routeName?` | 외부 URL과 내부 route 처리 분리 |
| 활동 로그 섹션 | `GET` | `/api/v1/activity/logs` | `query: childId optional`, `limit`, `cursor` | `logs[]`: `id`, `title`, `recordedAt`, `count`, `locationId?` | 현재 위치명/날짜/count 문자열 하드코딩 |
| 알림 아이콘 | `GET` | `/api/v1/notifications/summary` | `query: userId implicit` | `unreadCount`, `latestNotification?` | 현재 알림 버튼은 빈 콜백 |

### `lib/screens/discovery_card_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 카테고리별 그룹 목록 | `GET` | `/api/v1/cards/grouped` | `query: childId optional`, `includeEmpty=false` | `groups[]`: `category`, `summary`, `cards[]` | 현재 `DiscoveryRepository.fetchAllGrouped()` fixture 반환 |
| 카테고리 filter | `GET` | `/api/v1/cards` | `query: category`, `childId optional`, `cursor`, `limit` | `cards[]`, `nextCursor`, `totalCount`, `categorySummary` | `DiscoveryCategory.all`은 category 생략 또는 `all` 처리 |
| 검색 버튼 | `GET` | `/api/v1/cards/search` | `query: q`, `category optional`, `cursor`, `limit` | `cards[]`, `highlight?`, `nextCursor` | 현재 TODO. empty state와 검색어 validation 필요 |
| 카드 item tap | `GET` | `/api/v1/cards/{cardId}` | `path: cardId` | `CardDetailData` 후보 필드 | 현재 `/card-detail`에 card id를 전달하지 않음. route argument 계약 필요 |
| 카메라 CTA | `GET` | `/api/v1/analysis/categories` | `query: locale` | `categories[]`: `id`, `label`, `iconKey`, `enabled` | 현재 카메라 이동 TODO. 촬영 가능 카테고리 서버 제어 가능 |

### `lib/screens/discovery_card_detail_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 화면 초기 로드 | `GET` | `/api/v1/cards/{cardId}` | `path: cardId`, `query: childId optional` | `id`, `nameKo`, `nameEn`, `categoryLabel`, `subCategoryLabel`, `currentGrade`, `oneLineDescription`, `discoveryRecord`, `nextGradeConditions`, `observations`, `isFavorite` | 현재 `sampleCardDetail` fixture 사용. card id 전달 방식 먼저 해결 |
| `DiscoveryHeroCard` | `GET` | `/api/v1/cards/{cardId}/media` | `path: cardId` | `heroImageUrl`, `thumbnailUrl`, `holoEffect`, `altText` | 현재 custom paint placeholder. 이미지 URL과 접근성 text 필요 |
| `DiscoveryRecordCard` | `GET` | `/api/v1/cards/{cardId}/discovery-record` | `path: cardId` | `discoveredAt`, `locationName`, `memo`, `thumbnailUrl`, `locationId` | 상세 API에 포함하면 별도 호출 불필요 |
| `HoloProgressCard` | `GET` | `/api/v1/cards/{cardId}/grade-conditions` | `path: cardId` | `currentGrade`, `conditions[]`: `label`, `current`, `required`, `completed` | 등급 계산 기준은 서버 source of truth 필요 |
| `ObservationHistoryCard` | `GET` | `/api/v1/cards/{cardId}/observations` | `path: cardId`, `query: cursor`, `limit` | `observations[]`, `nextCursor` | 상세 API에 일부만 포함하고 전체 보기에서 pagination 가능 |
| 공유 버튼 | `POST` | `/api/v1/cards/{cardId}/share` | `path: cardId`, `body: channel optional` | `shareUrl`, `message`, `expiresAt?` | 아동 데이터 노출 범위와 공개/비공개 정책 필요 |
| 지도 보기 | `GET` | `/api/v1/cards/{cardId}/locations` | `path: cardId` | `locations[]`: `locationId`, `displayName`, `lat?`, `lng?`, `precision` | child safety상 정밀 좌표 노출 제한 필요 |
| 더 관찰하기 | `POST` | `/api/v1/observations/drafts` | `body: cardId`, `subjectName`, `category` | `draftObservationId`, `cameraContext` | 카메라 화면에 canonical subject context 전달 |
| 좋아요 토글 | `PUT` 또는 `DELETE` | `/api/v1/cards/{cardId}/favorite` | `path: cardId`, `body: desiredState optional` | `isFavorite`, `favoriteCount?`, `updatedAt` | optimistic update 실패 시 rollback 필요 |

### `lib/screens/card_detail_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| Legacy 카드 상세 | `GET` | `/api/v1/cards/{cardId}/legacy-summary` | `path: cardId` 또는 route argument `DiscoveryCardItem.id` | `id`, `name`, `categoryLabel`, `imageUrl`, `isNew`, `subtitle` | `/card-detail-legacy`의 유지/삭제 의도 확인 전 canonical 상세와 합치지 말 것 |
| Legacy에서 canonical 상세 이동 | `GET` | `/api/v1/cards/{cardId}` | `path: cardId` | `CardDetailData` | legacy 화면을 thin wrapper로 바꿀 경우 필요 |

### `lib/screens/camera_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 카메라 카테고리 panel | `GET` | `/api/v1/analysis/categories` | `query: locale`, `childId optional` | `categories[]`: `id`, `label`, `iconKey`, `enabled`, `safetyHint` | 현재 `자동`, `식물`, `동물`, `곤충`, `건축물` 하드코딩 |
| 촬영 권한/정책 | `GET` | `/api/v1/children/{childId}/capture-policy` | `path: childId optional` | `canCapture`, `requiresGuardianConsent`, `dailyLimit`, `remainingCount` | 아동 계정 제한과 보호자 동의 상태 반영 |
| 촬영 이미지 업로드 | `POST` | `/api/v1/uploads/images` | `multipart: image`, `body: childId`, `categoryHint`, `capturedAt`, `deviceMetadata?` | `uploadId`, `imageUrl`, `thumbnailUrl`, `expiresAt` | 실제 `camera` 또는 `image_picker` 도입 필요 |

### `lib/screens/photo_preview_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 촬영 사진 미리보기 | `GET` | `/api/v1/uploads/{uploadId}` | `path: uploadId` | `imageUrl`, `thumbnailUrl`, `createdAt`, `expiresAt` | 현재 gradient placeholder. 로컬 파일과 서버 업로드 상태 동기화 필요 |
| 다시 찍기 | `DELETE` | `/api/v1/uploads/{uploadId}` | `path: uploadId`, `body: reason=retake` | `deleted`, `retentionUntil?` | 업로드 후 취소 시 임시 이미지 정리 |
| 카드 만들기 | `POST` | `/api/v1/analysis/jobs` | `body: uploadId`, `categoryHint`, `childId optional`, `locationContext?` | `jobId`, `status`, `estimatedSeconds` | 현재 바로 `AnalysisStatusScreen`으로 이동. job id 전달 필요 |

### `lib/screens/analysis_status_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 분석 진행 polling | `GET` | `/api/v1/analysis/jobs/{jobId}` | `path: jobId` | `status`, `progressPercent`, `currentStepLabel`, `detectedSubject?`, `candidateCard?`, `error?` | 현재 `_simulateAnalysis()`는 `Future.delayed` mock. polling interval/backoff 필요 |
| 분석 취소 | `DELETE` | `/api/v1/analysis/jobs/{jobId}` | `path: jobId`, `body: reason` | `cancelled`, `temporaryUploadDeleted` | 사용자가 뒤로가거나 다시 촬영할 때 처리 |
| 카드 저장 확정 | `POST` | `/api/v1/analysis/jobs/{jobId}/confirm-card` | `path: jobId`, `body: childId optional`, `memo?`, `location?` | `cardId`, `cardSummary`, `createdAt` | 현재 완료 후 Discovery 목록으로 이동만 함. 생성된 card id 필요 |
| 카드 확인하기 | `GET` | `/api/v1/cards/{cardId}` | `path: cardId` | `CardDetailData` | 생성 직후 상세로 갈지 목록으로 갈지 UX 결정 필요 |

### `lib/screens/map_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 지도 초기 데이터 | `GET` | `/api/v1/locations/nearby` | `query: lat`, `lng`, `radius`, `childId optional` | `locations[]`: `id`, `displayName`, `discoveryCount`, `lastDiscoveredAt`, `questAvailable`, `precision` | 현재 지도 placeholder. 위치 권한과 지도 SDK 필요 |
| 플로팅 위치 카드 | `GET` | `/api/v1/locations/{locationId}` | `path: locationId` | `displayName`, `discoveryCount`, `lastDiscoveredAt`, `availableQuests[]` | 현재 `서울숲 가족마당` 하드코딩 |
| 이 위치에서 퀘스트 시작 | `POST` | `/api/v1/locations/{locationId}/start-quest` | `path: locationId`, `body: childId optional` | `questId`, `routeName`, `startedAt` | 위치 기반 quest 생성/참여 정책 필요 |

### `lib/screens/discovery_intro_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 발견 인트로 콘텐츠 | `GET` | `/api/v1/onboarding/discovery-intro` | `query: locale`, `childAge optional` | `title`, `description`, `features[]`, `ctaLabel` | 현재 정적. 운영에서 문구/교육 콘텐츠를 바꾸려면 CMS성 API 필요 |
| 인트로 완료 | `POST` | `/api/v1/users/me/onboarding/discovery-intro/complete` | `body: completedAt` | `completed`, `nextRoute` | 한 번 본 뒤 다시 보지 않도록 서버 상태 저장 가능 |

### `lib/screens/plan_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 플랜 목록 | `GET` | `/api/v1/plans` | `query: billingCycle`, `locale`, `platform` | `plans[]`: `tier`, `title`, `price`, `period`, `features[]`, `isPopular`, `productId?` | 현재 Free/Plus/Family 가격 하드코딩 |
| 월간/연간 toggle | `GET` | `/api/v1/plans` | `query: billingCycle=monthly/yearly` | 같은 plan schema, `discountLabel?` | 가격은 서버 또는 store product 기준이어야 함 |
| 플랜 선택 | `POST` | `/api/v1/subscription/checkout` | `body: planTier`, `billingCycle`, `platform`, `childId optional` | `checkoutUrl?`, `purchaseToken?`, `expiresAt` | 앱스토어 결제와 웹 결제 중 결정 필요 |

### `lib/features/quest_detail/presentation/pages/quest_detail_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 퀘스트 상세 로드 | `GET` | `/api/v1/quests/{questId}` | `path: questId`, `query: childId optional` | `id`, `type`, `badgeLabel`, `title`, `description`, `startDate`, `endDate`, `participantCount`, `requiredCount`, `completedCount`, `rewardLabel`, `targetItems[]`, `missions[]` | 현재 `QuestDetailFixture.springPlants` fallback |
| `RequiredQuestItemsSection` | `GET` | `/api/v1/quests/{questId}/targets` | `path: questId`, `query: cursor`, `limit` | `targetItems[]`, `nextCursor` | 상세 API에 일부 포함 후 전체 보기에서 pagination 가능 |
| target mini card tap | `GET` | `/api/v1/cards/catalog/{targetId}` | `path: targetId` | `targetId`, `name`, `category`, `sampleImageUrl`, `discoveryStatus` | 아직 TODO. 발견 전/후 상태를 구분해야 함 |
| `QuestMissionCard` mission action | `POST` | `/api/v1/quests/{questId}/missions/{missionId}/complete` | `path: questId`, `missionId`, `body: evidenceId?`, `observationId?` | `mission`, `questProgress`, `rewardGranted?` | 서버가 완료 조건을 검증해야 함 |
| 퀘스트 공유 | `POST` | `/api/v1/quests/{questId}/share` | `path: questId`, `body: channel optional` | `shareUrl`, `message` | 공개 범위 정책 필요 |

### `lib/features/my_page/presentation/pages/my_page_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| My page 전체 로드 | `GET` | `/api/v1/users/me/summary` | `header: accessToken`, `query: childId optional` | `greetingName`, `levelName`, `currentExp`, `nextLevelRequiredExp`, `cardCount`, `observationCount`, `questCount`, `likeCount`, `weeklyDiscoveryCount`, `weeklyExp`, `recentObservations[]`, `badges[]` | 현재 `MyPageFixture.sample` fallback |
| `ActivityShortcutStats` | `GET` | `/api/v1/users/me/activity-stats` | `query: childId optional` | `cardCount`, `observationCount`, `questCount`, `likeCount` | summary와 중복 가능. 독립 refresh가 필요할 때만 분리 |
| 최근 관찰 섹션 | `GET` | `/api/v1/users/me/observations` | `query: childId optional`, `limit`, `cursor` | `observations[]`: `id`, `name`, `observedAt`, `imageUrl`, `cardId` | 현재 최근 관찰 3개 fixture |
| 배지 섹션 | `GET` | `/api/v1/users/me/badges` | `query: childId optional` | `badges[]`: `id`, `label`, `unlocked`, `iconKey`, `unlockedAt?` | `IconData` 대신 iconKey 필요 |
| 알림 버튼 | `GET` | `/api/v1/notifications` | `query: cursor`, `limit` | `notifications[]`, `nextCursor`, `unreadCount` | 현재 TODO |
| 개인정보 수정 진입 | `GET` | `/api/v1/auth/reauth/status` | `header: accessToken` | `required`, `validUntil`, `methods[]` | 민감 화면 진입 전 재인증 필요 |
| 보호자 모드 카드 | `GET` | `/api/v1/parent/access-status` | `header: accessToken` | `enabled`, `requiresVerification`, `guardianProfileExists` | parent mode entry 노출 조건 |

### `lib/features/profile_edit/presentation/pages/profile_edit_screen.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| Profile edit 초기 로드 | `GET` | `/api/v1/users/me` | `header: accessToken`, `query: childId optional` | `nickname`, `description`, `birthDate`, `gender`, `language`, `email`, `profileImageUrl`, `socialAccounts[]` | 현재 `ProfileEditFixture.sample` fallback |
| 저장 버튼 | `PATCH` | `/api/v1/users/me` | `body: nickname`, `description`, `birthDate`, `gender`, `language` | `profile`, `updatedAt`, `validationErrors?` | 재인증 만료 시 `reauthRequired` error 필요 |
| 프로필 이미지 변경 | `POST` | `/api/v1/users/me/profile-image` | `multipart: image`, `body: crop?` | `profileImageUrl`, `thumbnailUrl`, `updatedAt` | 이미지 picker와 upload progress 필요 |
| 기본 정보 row 편집 | `PATCH` | `/api/v1/users/me/profile-fields` | `body: field`, `value` | `field`, `value`, `updatedAt` | 일괄 저장과 row별 저장 중 UX 결정 |
| 이메일 변경 | `POST` | `/api/v1/users/me/email/change-request` | `body: newEmail` | `requestId`, `maskedDestination`, `expiresAt` | 이메일 인증 완료 API 별도 필요 |
| 비밀번호 변경 | `PATCH` | `/api/v1/users/me/password` | `body: currentPassword`, `newPassword` | `changedAt`, `logoutOtherDevices?` | 최근 재인증 또는 current password 요구 |
| 소셜 계정 연결/해제 | `POST` 또는 `DELETE` | `/api/v1/users/me/social-accounts/{provider}` | `path: provider`, `body: oauthCode optional` | `provider`, `connected`, `updatedAt` | provider별 unlink 제한 정책 필요 |
| 알림 설정 | `PATCH` | `/api/v1/users/me/notification-settings` | `body: pushEnabled`, `eventEnabled`, `emailEnabled` | `settings`, `updatedAt` | OS push permission 상태와 서버 설정 분리 |

### `lib/features/account_verification/presentation/pages/account_verification_screen_method.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 재인증 방법 조회 | `GET` | `/api/v1/auth/reauth/methods` | `header: accessToken`, `query: purpose=profileEdit` | `methods[]`, `reauthenticationValidMinutes`, `recommendedMethod` | 현재 `AccountVerificationMethodData` 하드코딩 |
| 비밀번호 방식 선택 | `POST` | `/api/v1/auth/reauth/challenges` | `body: method=password`, `purpose` | `challengeId`, `expiresAt`, `nextRoute` | password 화면에 challengeId 전달 가능 |
| 소셜 방식 선택 | `POST` | `/api/v1/auth/reauth/challenges` | `body: method=provider`, `provider`, `purpose` | `challengeId`, `oauthRedirect?`, `expiresAt` | 소셜 provider flow와 연동 |

### `lib/features/account_verification/presentation/pages/account_verification_screen_password.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 비밀번호 재인증 카드 | `POST` | `/api/v1/auth/reverify/password` | `body: challengeId optional`, `password`, `purpose=profileEdit` | `success`, `reauthToken`, `validUntil`, `nextRoute` | 현재 `MockAccountVerificationRepository`는 password non-empty면 성공 |
| 비밀번호 재설정 진입 | `POST` | `/api/v1/auth/password/reset/request` | `body: email optional`, `purpose=reauth` | `requestId`, `maskedDestination`, `expiresAt` | 실패 메시지는 보안상 과도한 정보 노출 금지 |

### `lib/features/account_verification/presentation/pages/account_verification_screen_social.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 소셜 재인증 provider 목록 | `GET` | `/api/v1/auth/reauth/methods` | `query: type=social`, `purpose=profileEdit` | `providers[]`, `connected`, `enabled` | 현재 `SocialAccountVerificationData` 하드코딩 |
| 소셜 재인증 제출 | `POST` | `/api/v1/auth/reverify/oauth/{provider}` | `path: provider`, `body: challengeId`, `oauthCode` 또는 `idToken` | `success`, `reauthToken`, `validUntil`, `nextRoute` | provider token replay 방지와 nonce 검증 필요 |

### `lib/features/parent_mode/parent_mode_entry_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 부모 모드 진입 카드/메뉴 | `GET` | `/api/v1/parent/entry` | `header: accessToken` | `guardianProfileExists`, `requiresVerification`, `menuItems[]`, `summary?` | 현재 정적 entry menu. 권한 없는 사용자는 가입/초대 flow 필요 |
| 개인정보/기록/구독/데이터 메뉴 상태 | `GET` | `/api/v1/parent/dashboard/summary` | `header: accessToken` | `privacyStatus`, `recordSummary`, `subscriptionSummary`, `dataManagementWarnings` | entry에서 각 메뉴 badge/상태 표시 시 필요 |

### `lib/features/parent_mode/parent_verification_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 보호자 비밀번호 재확인 | `POST` | `/api/v1/parent/reverify/password` | `body: password`, `passwordConfirm?`, `purpose=parentMode` | `success`, `parentReauthToken`, `validUntil`, `nextRoute` | 현재 `Future.delayed` 후 `/parent/home` 이동 |
| Google/Apple 보호자 재확인 | `POST` | `/api/v1/parent/reverify/oauth/{provider}` | `path: provider`, `body: oauthCode` 또는 `idToken`, `purpose` | `success`, `parentReauthToken`, `validUntil` | provider 연결 여부 확인 필요 |
| 비밀번호 재설정 | `POST` | `/api/v1/auth/password/reset/request` | `body: accountEmail`, `purpose=parentReauth` | `requestId`, `maskedDestination` | `ParentVerificationForm` TODO |

### `lib/features/parent_mode/parent_home_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| Parent home aggregate | `GET` | `/api/v1/parent/dashboard` | `header: accessToken`, `parentReauthToken optional` | `childSummary`, `recordSummary`, `subscriptionSummary`, `menuItems[]`, `alerts[]` | 현재 `ParentModeFixture.childSummary`, `menuItems` 사용 |
| `ParentChildProfileCard` | `GET` | `/api/v1/parent/children/selected/summary` | `header: accessToken` | `childName`, `age`, `explorerLevel`, `avatarUrl` | dashboard에 포함 가능 |
| `ParentMenuGrid` | `GET` | `/api/v1/parent/menu` | `query: locale`, `permissions` | `menuItems[]`: `type`, `title`, `description`, `iconKey`, `enabled`, `badge?` | `IconData` 대신 iconKey 필요 |
| bottom navigation | `GET` | `/api/v1/parent/navigation-state` | `header: accessToken` | `availableRoutes[]`, `selectedIndex` | 권한/구독 상태에 따른 메뉴 노출 제어 |

### `lib/features/parent_mode/parent_child_list_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 아이 목록 | `GET` | `/api/v1/parent/children` | `header: accessToken` | `children[]`: `id`, `name`, `nickname`, `age`, `gender`, `explorerLevel`, `gradeLabel`, `isSelected`, `avatarUrl` | 현재 `parentChildProfiles` fixture |
| 아이 선택 | `PATCH` | `/api/v1/parent/children/{childId}/selected` | `path: childId` | `selectedChildId`, `children[]` | 선택 아이 변경 시 Home/MyPage 데이터 refresh 필요 |
| 아이 추가 | `POST` | `/api/v1/parent/children` | `body: name`, `birthDate`, `gender?`, `nickname?` | `child`, `nextRoute` | 현재 TODO. 보호자 동의/최대 자녀 수 정책 필요 |

### `lib/features/parent_mode/parent_child_info_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 아이 상세 | `GET` | `/api/v1/parent/children/{childId}` | `path: childId` | `id`, `name`, `nickname`, `birthDate`, `age`, `gender`, `explorerLevel`, `gradeLabel`, `interests[]`, `preferredActivityTime`, `memo`, `avatarUrl` | 현재 `findParentChildProfile(childId)` fixture |
| 정보 수정 | `PATCH` | `/api/v1/parent/children/{childId}` | `path: childId`, `body: editable fields` | `child`, `updatedAt` | root page TODO. 변경 전 parent reauth 요구 가능 |
| 관심사 수정 | `PATCH` | `/api/v1/parent/children/{childId}/preferences` | `body: interests[]`, `preferredActivityTime`, `memo` | `preferences`, `updatedAt` | UI는 bottom sheet 후보 |

### `lib/features/parent_mode/parent_privacy_consent_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 개인정보 섹션 | `GET` | `/api/v1/parent/privacy/sections` | `header: accessToken` | `sections[]`: `title`, `items[]`, `routeName`, `iconKey` | 현재 `ParentModeFixture.privacySections` |
| 동의 상태 | `GET` | `/api/v1/parent/consents` | `query: childId optional` | `consents[]`: `type`, `title`, `description`, `required`, `agreed`, `version`, `updatedAt` | 현재 `ParentModeFixture.consentStatuses` |
| 동의 변경 | `PATCH` | `/api/v1/parent/consents/{consentType}` | `path: consentType`, `body: agreed`, `version` | `consent`, `effectiveAt` | 필수 동의 철회 시 서비스 제한/데이터 삭제 안내 필요 |
| 상세 동의 문서 | `GET` | `/api/v1/parent/consents/{consentType}/document` | `path: consentType`, `query: locale` | `title`, `version`, `contentUrl` 또는 `contentHtml` | WebView 또는 sheet 필요 |

### `lib/features/parent_mode/parent_guardian_info_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 보호자 정보 | `GET` | `/api/v1/parent/guardian` | `header: accessToken` | `name`, `email`, `phoneNumber`, `relationLabel`, `eventNotificationEnabled`, `emailNotificationEnabled`, `smsNotificationEnabled` | 현재 `parentGuardianProfile` fixture |
| 보호자 정보 수정 | `PATCH` | `/api/v1/parent/guardian` | `body: name`, `phoneNumber`, `relation`, `notification flags` | `guardian`, `updatedAt` | 연락처 변경은 인증 절차 필요 가능 |
| 알림 수신 설정 저장 | `PATCH` | `/api/v1/parent/guardian/notification-settings` | `body: eventNotificationEnabled`, `emailNotificationEnabled`, `smsNotificationEnabled` | `settings`, `updatedAt` | OS push permission과 서버 설정 분리 |

### `lib/features/parent_mode/parent_account_security_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 로그인 방법 | `GET` | `/api/v1/parent/security/login-methods` | `header: accessToken` | `methods[]`: `provider`, `label`, `connected`, `iconUrl?` | 현재 `parentLoginMethods` fixture |
| 로그인 이력 | `GET` | `/api/v1/parent/security/login-history` | `query: cursor`, `limit` | `items[]`: `loggedInAt`, `deviceName`, `ipRegion?`, `currentDevice?`, `nextCursor` | 현재 `parentLoginHistoryItems` fixture |
| 보안 설정 flow | `GET` | `/api/v1/parent/security/settings` | `header: accessToken` | `passwordEnabled`, `twoFactorEnabled`, `socialAccounts[]` | TODO. 어떤 보안 항목을 제공할지 확정 필요 |
| 모든 기기 로그아웃 | `POST` | `/api/v1/parent/security/logout-all-devices` | `body: keepCurrentDevice=true`, `parentReauthToken` | `loggedOutDeviceCount`, `completedAt` | 민감 액션. reauth token 필요 |

### `lib/features/parent_mode/parent_discovery_record_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 기록 요약 | `GET` | `/api/v1/parent/records/summary` | `query: childId optional` | `photoCount`, `cardCount`, `placeCount` | 현재 `ParentModeFixture.recordSummary` |
| 최근 사진 grid | `GET` | `/api/v1/parent/records/photos` | `query: childId optional`, `cursor`, `limit` | `photos[]`: `id`, `label`, `thumbnailUrl`, `capturedAt`, `cardId?`, `safetyStatus` | 현재 `ParentModeFixture.recentPhotos` |
| 카드 기록 관리 | `GET` | `/api/v1/parent/records/cards` | `query: childId optional`, `cursor`, `limit` | `cards[]`, `nextCursor`, `filters[]` | TODO. 삭제/숨김/상세 관리 액션 필요 |

### `lib/features/parent_mode/parent_location_record_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 위치 기록 pins | `GET` | `/api/v1/parent/location-records` | `query: childId optional`, `from`, `to`, `precision=coarse` | `pins[]`: `id`, `displayName`, `dx?`, `dy?`, `lat?`, `lng?`, `recordCount`, `lastRecordedAt`, `precision` | 현재 `ParentModeFixture.locationPins` |
| 위치 기록 조회 | `GET` | `/api/v1/parent/location-records/summary` | `query: period`, `childId optional` | `places[]`, `totalCount`, `periodLabel` | TODO. 장소/동 단위 표시 정책 필요 |
| 위치 기록 설정 | `PATCH` | `/api/v1/parent/location-settings` | `body: enabled`, `precision`, `retentionDays` | `settings`, `updatedAt` | 아동 위치정보 동의와 연결 |

### `lib/features/parent_mode/parent_subscription_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 구독 상태 | `GET` | `/api/v1/parent/subscription` | `header: accessToken` | `planName`, `active`, `billingCycleLabel`, `nextBillingDate`, `benefits[]`, `cancelAvailable` | 현재 `ParentModeFixture.subscriptionSummary`, `subscriptionBenefits` |
| 구독 플랜 목록 | `GET` | `/api/v1/plans` | `query: platform`, `locale` | `plans[]`, `currentPlanTier` | `plan_screen.dart`와 계약 공유 |
| 결제 수단 관리 | `POST` | `/api/v1/parent/payment-methods/manage-session` | `body: returnUrl` | `manageUrl` 또는 `clientSecret`, `expiresAt` | 앱스토어 결제면 external management URL이 다를 수 있음 |
| 구독 해지 | `POST` | `/api/v1/parent/subscription/cancel` | `body: reason?`, `effectiveAtPolicy`, `parentReauthToken optional` | `cancelled`, `activeUntil`, `status` | 해지 즉시/기간 종료 후 반영 정책 필요 |

### `lib/features/parent_mode/parent_data_management_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 삭제 옵션 목록 | `GET` | `/api/v1/parent/data-deletion/options` | `header: accessToken` | `options[]`: `type`, `title`, `description`, `destructive`, `requiresReauth` | 현재 `ParentModeFixture.deletionOptions` |
| 사진 및 카드 삭제 | `POST` | `/api/v1/parent/data-deletion/photo-cards` | `body: childId optional`, `scope`, `parentReauthToken?` | `requestId`, `status`, `estimatedCompletionAt` | 복구 불가 안내와 비동기 처리 상태 필요 |
| 위치 기록 삭제 | `POST` | `/api/v1/parent/data-deletion/location-records` | `body: childId optional`, `from?`, `to?`, `parentReauthToken?` | `requestId`, `status` | 위치정보 법적 보관 기간 확인 |
| AI 분석 데이터 삭제 | `POST` | `/api/v1/parent/data-deletion/analysis-data` | `body: childId optional`, `scope`, `parentReauthToken?` | `requestId`, `status` | 모델 개선용 데이터 사용 여부와 동의 철회 연계 |
| 모든 데이터 삭제 | `POST` | `/api/v1/parent/data-deletion/all` | `body: childId optional`, `confirmText`, `parentReauthToken` | `requestId`, `status`, `retentionUntil?` | 가장 위험한 액션. 서버 재인증 필수 |
| 계정 삭제 | `POST` | `/api/v1/parent/account-deletion/request` | `body: confirmText`, `parentReauthToken` | `requestId`, `status`, `scheduledDeletionAt` | 현재 dialog만 있음. 철회 가능 기간 정책 필요 |

### `lib/features/parent_mode/parent_settings_page.dart`

| View/컴포넌트 | 메소드 | API | 전송 데이터 | 수신 데이터 | 주의/필요 사항 |
| --- | --- | --- | --- | --- | --- |
| 설정 목록 | `GET` | `/api/v1/parent/settings` | `header: accessToken`, `query: locale` | `generalSettings[]`, `supportSettings[]`, `notificationSettings` | 현재 `generalSettings`, `supportSettings` fixture |
| 언어 설정 | `PATCH` | `/api/v1/users/me/preferences` | `body: language` | `preferences`, `updatedAt` | 앱 locale 적용 시 재시작/즉시 적용 결정 |
| 부모 알림 설정 | `PATCH` | `/api/v1/parent/notification-settings` | `body: pushEnabled`, `familyAlertEnabled`, `eventEnabled` | `settings`, `updatedAt` | OS permission 상태와 서버 설정 동기화 |
| 고객 지원/FAQ | `GET` | `/api/v1/support/links` | `query: locale`, `appVersion` | `faqUrl`, `contactUrl`, `termsUrl`, `privacyUrl` | 외부 URL allowlist 필요 |
| 로그아웃 | `POST` | `/api/v1/auth/logout` | `body: refreshToken?`, `deviceId?` | `success` | secure storage token 삭제와 서버 session invalidation을 함께 처리 |

## 3. Coverage Notes

| 구분 | 포함한 파일 |
| --- | --- |
| Legacy screens | `welcome_screen.dart`, `mode_selection_screen.dart`, `login_screen.dart`, `home_screen.dart`, `discovery_card_screen.dart`, `discovery_card_detail_screen.dart`, `card_detail_screen.dart`, `camera_screen.dart`, `photo_preview_screen.dart`, `analysis_status_screen.dart`, `map_screen.dart`, `discovery_intro_screen.dart`, `plan_screen.dart` |
| Feature pages | `signup_method_page.dart`, `email_signup_page.dart`, `quest_detail_screen.dart`, `my_page_screen.dart`, `profile_edit_screen.dart`, `account_verification_screen_method.dart`, `account_verification_screen_password.dart`, `account_verification_screen_social.dart` |
| Parent mode pages | `parent_mode_entry_page.dart`, `parent_verification_page.dart`, `parent_home_page.dart`, `parent_child_list_page.dart`, `parent_child_info_page.dart`, `parent_privacy_consent_page.dart`, `parent_guardian_info_page.dart`, `parent_account_security_page.dart`, `parent_discovery_record_page.dart`, `parent_location_record_page.dart`, `parent_subscription_page.dart`, `parent_data_management_page.dart`, `parent_settings_page.dart` |

## 4. 구현 전 주의 사항

| 주제 | 주의 사항 |
| --- | --- |
| Route argument | `/card-detail`은 현재 card id를 받지 않는다. `cardId` 전달 방식을 먼저 확정해야 한다. |
| Aggregate vs split API | Home, MyPage, ParentHome은 aggregate API가 효율적이지만 개별 컴포넌트 refresh가 필요하면 split API도 유지해야 한다. |
| 민감 정보 | parent mode의 아이 정보, 위치, 사진, 삭제, 구독은 parent reauth scope와 감사 로그가 필요하다. |
| UI model 변환 | `IconData`, `Color`, asset path는 서버 응답으로 직접 쓰지 말고 key/token과 mapper를 사용한다. |
| Fake async 제거 | `analysis_status_screen.dart`와 `parent_verification_page.dart`의 `Future.delayed`는 실제 job/reauth 상태로 교체해야 한다. |
| 삭제 처리 | 데이터/계정 삭제는 즉시 성공 응답보다 `requestId`, `status`, `scheduledDeletionAt` 기반 비동기 처리가 안전하다. |
| 테스트 | API 연결 전 route smoke, loading/error/empty, reauth required, upload polling 실패 케이스를 먼저 보강해야 한다. |
