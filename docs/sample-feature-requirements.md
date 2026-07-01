# Sample-Project → Main-Project 기능 요구사항 역추출

> **목적**: sample-project(`pocketmon-card-holo/flutter_application_1`)의 화면·사용자 흐름·mock 데이터·가짜 API 호출을 분석해, main-project(`little-quest/little_quest`)에 필요한 **실제 기능 요구사항**과 **백엔드 API 요구사항**을 역추출한다.
>
> **주의**:
> - sample-project의 mock 데이터는 실제 데이터 모델 **후보로만 참고**한다. main-project에 그대로 추가하지 않는다.
> - sample-project의 UI를 그대로 복사하지 않는다. main-project의 디자인 시스템·라우팅·상태관리·API 패턴을 우선한다.
> - 본 문서는 분석/설계 산출물이며, 코드 수정은 수반하지 않는다.

---

## 1. sample-project의 주요 화면 목록

sample-project는 단일 페이지 앱 + 다이얼로그 구조이다. 라우트가 아닌 하나의 `HomePage` 위주로 동작한다.

| # | 화면/진입점 | 파일 | 비고 |
|---|------------|------|------|
| 1 | `HomePage` (카드 갤러리 스튜디오) | `lib/main.dart` | 앱의 유일한 메인 화면. 카드 그리드 + FAB |
| 2 | `CardEditorDialog` (카드 생성/편집) | `lib/widgets/card_editor_dialog.dart` | `showDialog`로 띄우는 모달. 별도 라우트 아님 |
| 3 | 카드 삭제 확인 다이얼로그 | `lib/main.dart` `_deleteCard` | `AlertDialog` |
| 4 | 정보(About) 다이얼로그 | `lib/main.dart` `_showAbout` | `AlertDialog` |

> sample-project는 화면 수가 적고, 핵심은 "홀로 카드 렌더링 + 사진 선택/저장"이라는 기능 단위의 흐름이다.

---

## 2. 각 화면에서 사용자가 할 수 있는 행동

### 2.1 `HomePage` (카드 갤러리)
- 카드 목록 조회(그리드)
- 카드 탭 → 편집 다이얼로그 오픈
- 카드 롱프레스 → 삭제 확인 다이얼로그
- FAB "카드 만들기" 탭 → 생성 다이얼로그 오픈
- 정보 아이콘 탭 → About 다이얼로그
- 카드에 마우스 호버 → 3D 틸트 + 홀로/글레어 효과 반응 (데스크톱 전용)

### 2.2 `CardEditorDialog` (생성/편집)
- 사진 선택: 갤러리(`pickAndCropFromGallery`) / 카메라(`takeAndCropFromCamera`) → 5:7 크롭
- 타이틀 / 서브타이틀 / 메모 텍스트 입력
- 래리티 선택(`Rarity`: basic / reverseHolo / regularHolo / illustrationRare / hyperRare / testHolo)
- (선택) 홀로 텍스처 이미지 별도 선택(`pickHoloFromGallery`) — 레이어 선택 기능
- 저장 → 카드 메타데이터 영구 저장
- 취소

### 2.3 삭제 확인 / 정보 다이얼로그
- 삭제 확인/취소, About 닫기

---

## 3. 각 행동으로 인해 변경되는 상태

| 행동 | 변경되는 상태 | 저장 위치 |
|------|--------------|-----------|
| 카드 저장(생성) | `_cards` 목록 추가 | `SharedPreferences` (`cards_v1` 키, JSON 배열) + 앱 디렉토리 `card_photos/` 사진 파일 |
| 카드 저장(편집) | `_cards` 목록 해당 항목 교체 | 동일 |
| 카드 삭제 | `_cards` 목록 제거 | `SharedPreferences` 갱신 (사진 파일은 별도 삭제 로직 없음) |
| 앱 재시작 | `_cards`를 저장소에서 로드 | `CardStore.loadAll()` |
| 마우스 호버 | `_pointerX/_pointerY/_fade` (ValueNotifier) | 메모리 only (재시작 시 초기화) |
| 래리티/홀로 이미지 선택 | 다이얼로그 내 `_rarity`, `_holoImagePath` | 저장 시 `CardData`에 포함되어 영구화 |
| 사진 선택/크롭 | 새 PNG 파일이 앱 디렉토리에 생성 | 파일 시스템 `card_photos/`, `holo_sheets/` |

**핵심 영구 상태**: 카드 메타데이터(JSON) + 사진 파일 경로. 사용자 식별/계정 개념 없음(단일 사용자 로컬 앱).

---

## 4. 사용 중인 mock 데이터 구조

sample-project는 **fixture 데이터가 거의 없다**. 대부분 사용자가 직접 생성한 데이터가 저장소를 채운다. mock/하드코딩된 부분:

| 항목 | 위치 | 내용 |
|------|------|------|
| 래리티 종류/색상/라벨 | `lib/models/card_data.dart` `Rarity` + `RarityX` | 6종 래리티의 라벨(BSC/REV/REG/ILL/HYP/TST)과 프레임 색상(0xFF8A8A8A 등) 하드코딩 |
| 카드 비율 | `lib/painters/frame_painter.dart` `aspectRatio = 2.5/3.5` | 포켓몬 카드 표준 비율 |
| 크롭 비율 | `lib/services/photo_service.dart` `CropAspectRatio(5, 7)` | 5:7 고정 |
| 홀로 테스트 에셋 경로 | `lib/widgets/layers/shine_layer.dart` `_testAssetPaths` | `assets/holo_test/` 8장 PNG 경로 하드코딩 |
| 셰이더 uniform 기본값 | `lib/widgets/layers/shine_layer.dart` `cardAspect: 2.5/3.5`, `intensity: 0.8` | 렌더링 파라미터 |
| About 텍스트 | `lib/main.dart` `_showAbout` | 앱 설명 하드코딩 |

> **참고용 데이터 모델 후보**(main-project에 그대로 추가 금지):
> - `CardData { id, title, subtitle, rarity, imagePath, holoImagePath?, memo }` — 사용자 생성 카드
> - `Rarity { basic, reverseHolo, regularHolo, illustrationRare, hyperRare, testHolo }` — 홀로 효과 종류

---

## 5. 가짜 API 함수 또는 하드코딩된 데이터

sample-project에는 **가짜 API(네트워크 모킹)가 없다**. 대신 로컬 저장소를 "API처럼" 사용한다.

| "가짜 API" 역할 | 실제 구현 | 비고 |
|----------------|----------|------|
| 카드 목록 조회 | `CardStore.loadAll()` → `SharedPreferences.getString('cards_v1')` | JSON 디코딩 |
| 카드 저장 | `CardStore.saveAll/add/update` → `SharedPreferences.setString` | JSON 인코딩 |
| 카드 삭제 | `CardStore.remove` | |
| 사진 업로드(?) | `PhotoService._cropAndPersist` → 앱 디렉토리에 PNG 파일 기록 | "업로드"가 아니라 로컬 파일 복사 |
| 홀로 이미지 업로드(?) | `PhotoService._persistHoloImage` | 동일 |
| AI 분석(?) | **없음** | sample-project에는 종 식별/AI 분석 개념 자체가 없음 |

**main-project와의 차이**: main-project는 fixture + Repository 인터페이스 + Mock 구현체 패턴을 쓰지만, sample-project는 Repository 패턴 없이 `CardStore` 단일 클래스가 저장소를 직접 다룬다.

---

## 6. 실제 백엔드가 필요해지는 지점

sample-project 자체는 로컬 단일 사용자 앱이라 백엔드가 없지만, 이를 main-project(자연 탐험 도감 앱, 멀티 사용자 예상)에 이식한다고 가정할 때 백엔드가 필요한 지점:

### 6.1 sample-project에서 역추출되는 백엔드 필요 지점
| 지점 | 이유 |
|------|------|
| 카드 메타데이터 저장(`CardStore`) | 단일 기기 → 서버 사용자별 동기화 필요 |
| 사진 파일 보관(`card_photos/`) | 로컬 파일 → 객체 스토리지(S3/GCS) 업로드 + URL 발급 필요 |
| 사용자 식별 | sample은 계정 없음 → main은 로그인 사용자 기준으로 카드/사진 소유권 필요 |

### 6.2 main-project 자체의 백엔드 필요 지점 (TODO 주석 기반)
main-project는 이미 fixture 기반으로 화면을 채우고 있으며, 다음 지점에 백엔드가 필요함이 코드에 명시되어 있다:

| 화면/파일 | 라인 | 필요 백엔드 |
|-----------|------|------------|
| `discovery_repository.dart` | 7, 13, 21, 32 | 발견 카드 목록 API (fixture 제거) |
| `discovery_card_detail_screen.dart` | 34 | 카드 상세 API (현재 `sampleCardDetail` fixture) |
| `discovery_card_detail_screen.dart` | 91, 119 | 좋아요 토글 API + 서버 저장 |
| `discovery_card_detail_screen.dart` | 57 | 카드 공유 기능 (공유 링크/이미지 생성 API) |
| `discovery_card_detail_screen.dart` | 72, 87 | 발견 기록 상세 / 지도 연동 |
| `discovery_card_screen.dart` | 73 | 카드 검색 API |
| `analysis_status_screen.dart` | `_simulateAnalysis` | **AI 종 식별 API** (현재 `Future.delayed` 가짜 시뮬레이션) |
| `camera_screen.dart` | 주석 | 카메라 연동 + 촬영 이미지 업로드 |
| `photo_preview_screen.dart` | 플레이스홀더 | 촬영 이미지 → AI 분석 요청 |
| `map_screen.dart` | 플레이스홀더 | 지도 SDK + 발견 위치 저장/조회 |
| `my_page_screen.dart` | 43~74 | 마이페이지 통계/관찰 기록/배지/퀘스트 목록 API |
| `quest_detail_screen.dart` | 42 | 퀘스트 대상 목록 API |
| `quest_mission_card.dart` | 50 | 미션 완료 처리 API |
| `profile_edit_screen.dart` | 49, 55 | 프로필 수정 API + 회원 탈퇴 API |
| `account_verification_*.dart` | 다수 | 비밀번호 재인증 / 소셜 재인증 / 비밀번호 재설정 API |
| `profile_edit widgets` | 다수 | 닉네임/생일/성별/언어/이메일/비밀번호/알림설정/소셜연결 API |

---

## 7. 필요한 API 목록

> main-project의 기존 도메인(발견 카드/퀘스트/마이페이지/인증) + sample-project에서 역추출된 홀로 카드 렌더링 데이터를 합친 전체 API 요구사항.

### 7.1 인증/계정 (Auth)
| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 이메일 로그인 | POST | `/auth/login` | email, password | accessToken, refreshToken, user |
| 소셜 로그인 | POST | `/auth/oauth/{provider}` | providerToken | tokens |
| 회원가입 | POST | `/auth/signup` | email, password, nickname | tokens |
| 비밀번호 재설정 | POST | `/auth/password/reset` | email | — |
| 비밀번호 재인증 | POST | `/auth/reverify/password` | password | reauthToken(10분 유효) |
| 소셜 재인증 | POST | `/auth/reverify/oauth/{provider}` | providerToken | reauthToken |
| 회원 탈퇴 | DELETE | `/auth/account` | reauthToken | — |
| 토큰 갱신 | POST | `/auth/refresh` | refreshToken | tokens |

### 7.2 사용자/프로필 (User)
| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 내 프로필 조회 | GET | `/users/me` | — | ProfileEditData |
| 프로필 수정 | PATCH | `/users/me` | nickname?, description?, birthDate?, gender?, language? | ProfileEditData |
| 프로필 이미지 변경 | POST | `/users/me/profile-image` | multipart image | imageUrl |
| 비밀번호 변경 | PATCH | `/users/me/password` | currentPassword, newPassword | — |
| 이메일 변경 | PATCH | `/users/me/email` | newEmail, reauthToken | — |
| 소셜 계정 연결/해제 | POST/DELETE | `/users/me/oauth/{provider}` | providerToken / — | — |
| 알림 설정 변경 | PATCH | `/users/me/notification-settings` | settings | — |
| 마이페이지 요약 | GET | `/users/me/summary` | — | MyPageData (통계/배지/최근관찰) |

### 7.3 발견 카드 (Discovery Card)
| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 카드 목록(카테고리별) | GET | `/cards?category={c}` | — | List<DiscoveryCard> |
| 카드 목록(그룹화) | GET | `/cards/grouped` | — | List<DiscoveryCardGroup> |
| 카드 검색 | GET | `/cards?q={query}` | — | List<DiscoveryCard> |
| 카드 상세 | GET | `/cards/{id}` | — | CardDetailData |
| 카드 좋아요 토글 | POST | `/cards/{id}/favorite` | — | { isFavorite } |
| 카드 공유 링크 생성 | POST | `/cards/{id}/share` | — | { shareUrl } |

### 7.4 카드 생성 (AI 분석 파이프라인)
| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 이미지 업로드 | POST | `/uploads/image` | multipart image | { uploadId, imageUrl } |
| AI 종 식별 요청 | POST | `/analysis/identify` | uploadId | { analysisId } |
| AI 분석 결과 폴링 | GET | `/analysis/{analysisId}` | — | { status, species?, cardDraft?, safetyInfo? } |
| 카드 생성 확정 | POST | `/cards` | cardDraft | CardDetailData |

> `analysis_status_screen.dart`의 `_simulateAnalysis`를 실제 폴링 흐름으로 교체하는 지점.

### 7.5 관찰 기록 (Observation)
| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 관찰 기록 추가 | POST | `/cards/{cardId}/observations` | observedAt, locationName, memo, uploadId | ObservationRecord |
| 관찰 기록 목록 | GET | `/cards/{cardId}/observations` | — | List<ObservationRecord> |
| 발견 기록 상세 | GET | `/cards/{cardId}/discovery-record` | — | DiscoveryRecord |
| Holo 등급 조건 조회 | GET | `/cards/{cardId}/grade-conditions` | — | List<HoloCondition> |

### 7.6 퀘스트 (Quest)
| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 오늘의 퀘스트 | GET | `/quests/today` | — | List<Quest> |
| 퀘스트 목록 | GET | `/quests?type={t}` | — | List<QuestDetailData> |
| 퀘스트 상세 | GET | `/quests/{id}` | — | QuestDetailData |
| 퀘스트 대상 목록 | GET | `/quests/{id}/targets` | — | List<QuestTargetItem> |
| 미션 완료 처리 | POST | `/quests/{id}/missions/{missionId}/complete` | payload | { completed, rewardPoint } |

### 7.7 배지 (Badge)
| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 배지 목록 | GET | `/users/me/badges` | — | List<BadgeItem> |

### 7.8 지도/위치 (Location)
| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 발견 위치 목록 | GET | `/locations?cardId={id}` | — | List<LocationPoint> |
| 위치 기반 퀘스트 시작 | POST | `/quests/place/start` | lat, lng, placeName | QuestDetailData |

### 7.9 홀로 카드 렌더링 데이터 (sample 역추출, 신규)
> sample-project의 `CardData`/`Rarity` 개념을 main의 `HoloGrade`에 매핑한 관점.

| API | 메서드 | 경로(제안) | 요청 | 응답 |
|-----|-------|-----------|------|------|
| 카드 홀로 등급 조회 | (위 카드 상세에 포함) | — | — | `currentGrade: HoloGrade` |
| 홀로 렌더링 메타데이터 | GET | `/cards/{id}/holo-meta` | — | { grade, intensity, holoSheetUrl? } |

> **참고**: 홀로 렌더링 자체(셰이더/레이어)는 클라이언트 로직이므로 API가 아님. 백엔드가 제공해야 하는 것은 "이 카드가 어떤 홀로 등급인지"뿐. 레이어 선택 기능(`holoImagePath`)은 제거 대상이므로 API에서도 제외.

---

## 8. 필요한 DB 모델 / 도메인 모델

> main-project의 기존 모델(후보) + sample-project에서 역추출된 모델(후보만, 그대로 추가 금지).

### 8.1 DB 엔티티 제안 (서버 측)

#### User
- id, email, passwordHash, nickname, description, birthDate, gender, language
- profileImageUrl, currentExp, levelName
- googleConnected, appleConnected, naverConnected, kakaoConnected
- reauthenticatedAt (재인증 시각, 10분 유효)
- createdAt, updatedAt

#### DiscoveryCard (도감 카드 = 발견 대상의 카드)
- id, userId, nameKo, nameEn, categoryLabel, subCategoryLabel
- currentGrade (HoloGrade: normal/holo/seasonalHolo)
- oneLineDescription
- isFavorite
- createdAt

#### HoloGrade (enum, 도메인)
- normal, holo, seasonalHolo (main-project 기존 정의 유지)
- **sample의 `Rarity` 6종은 DB 모델에 추가하지 않음** (클라이언트 렌더링 파라미터로만 참고)

#### DiscoveryRecord (최초 발견)
- id, cardId, userId, discoveredAt, locationName, memo, thumbnailUrl

#### ObservationRecord (재관찰)
- id, cardId, userId, observedAt, locationName, memo, thumbnailUrl, isPrimary

#### HoloCondition (다음 등급 조건)
- id, cardId, label, current, required
- 조건: 다른 계절 관찰 / 다른 장소 관찰 / 메모 추가 등

#### Quest
- id, type(daily/weekly/seasonal/place/collectionSet/revisit), badgeLabel, title, description
- startDate, endDate, participantCount, requiredCount, completedCount, rewardLabel

#### QuestTargetItem
- id, questId, name, completed, completedAt, currentCount, requiredCount, imageAssetPath

#### QuestMissionItem
- id, questId, title, description, rewardPoint, completed, type(createCard/writeMemo/recordLocation)

#### Badge
- id, userId, label, unlocked, unlockedAt

#### LocationPoint (발견 위치)
- id, userId, cardId, lat, lng, placeName, observedAt

#### Upload (이미지 업로드)
- id, userId, imageUrl, mimeType, createdAt

#### AnalysisJob (AI 종 식별)
- id, userId, uploadId, status(pending/processing/completed/failed)
- speciesNameKo, speciesNameEn, cardDraftId, safetyInfo
- createdAt, completedAt

### 8.2 클라이언트 도메인 모델 (main-project 기존 + 보강 후보)

main-project에 이미 존재하는 모델(유지):
- `DiscoveryCard`, `DiscoveryCardGroup`, `DiscoveryCategory`, `DiscoveryCardItem`
- `CardDetailData`, `HoloGrade`, `DiscoveryRecord`, `HoloCondition`, `ObservationRecord`
- `QuestDetailData`, `QuestTargetItem`, `QuestMissionItem`, `QuestType`, `QuestMissionType`
- `MyPageData`, `RecentObservationItem`, `BadgeItem`
- `ProfileEditData`
- `AccountVerificationState`, `AccountVerificationMethodData`, `SocialAccountVerificationData`
- `Quest`, `Plan`, `PlanTier`

sample-project에서 **참고만** 하고 main에 **추가하지 않을** 모델:
- `CardData` (사용자 생성 카드) — main의 `CardDetailData`와 역할이 다르고, 사용자 생성 카드 기능이 제외되므로 불필요
- `Rarity` (6종) — main의 `HoloGrade` 3종으로 대체

---

## 9. main-project에 이미 존재하는 기능과 겹치는 부분

| 기능 영역 | main-project | sample-project | 겹침 정도 |
|-----------|--------------|----------------|-----------|
| 카드 상세 화면 | `DiscoveryCardDetailScreen` + `DiscoveryHeroCard` | `HoloCard` (홀로 카드 위젯) | **개념 겹침**: 둘 다 "카드"를 표시. 단 main은 도감 카드, sample은 트레이딩 카드. 렌더링 방식만 sample 참고 가능 |
| 홀로 등급 | `HoloGrade`(normal/holo/seasonalHolo) | `Rarity`(6종) | **이름만 겹침, 의미 다름**: main은 "탐험 등급", sample은 "홀로 효과 종류". 1:1 매핑 금지 |
| 홀로 배지/진행 | `holo_badge.dart`, `holo_progress_card.dart` | — | main에만 존재. sample에는 "등급 진행" 개념 없음 |
| 사진 선택 | (플레이스홀더 `camera_screen`/`photo_preview_screen`) | `PhotoService`(image_picker+croppy) | **기능 겹침**: main은 미구현, sample은 구현됨. main의 플레이스홀더를 실제 구현으로 교체할 때 sample 참고 가능 |
| 카드 저장 | (미구현, fixture 사용) | `CardStore`(SharedPreferences) | **저장 방식 다름**: main은 서버 API 필요, sample은 로컬 저장. 패턴 참고 불가(Repository 패턴으로 재작성 필요) |
| 카드 생성/편집 UI | (미구현) | `CardEditorDialog` | main에 없음. 단, 도감 카드 생성은 AI 분석 파이프라인으로 가야 하므로 sample의 수동 편집 UI는 그대로 쓰지 않음 |
| 카드 그리드 | `discovery_card_screen.dart` 그리드 | `CardGrid` | **레이아웃만 유사**: main은 도감 그리드, sample은 트레이딩 카드 그리드. 디자인 시스템이 다르므로 복사 금지 |
| 홀로 효과 렌더링 | **없음** (배지/진행바만) | `HoloCard`+`ShineLayer`+`GlareLayer`+`holo.frag` | **main에 없는 기능**. 이식 대상 핵심 |
| 3D 틸트/포인터 인터랙션 | **없음** | `HoloCard`+`PointerMath` | **main에 없는 기능**. 이식 대상 |

---

## 10. main-project에 새로 추가해야 하는 기능

### 10.1 sample-project에서 이식하여 추가 (핵심)
1. **홀로그래픽 포일 렌더링 시스템** (GLSL Fragment Shader 기반)
   - `holo.frag` 셰이더 + `ShineLayer`(셰이더 모드만, 이미지 홀로 모드 제거)
   - `HoloGrade` 3종에 맞춘 효과 매핑 (normal=홀로 없음+글레어만, holo/seasonalHolo=임의 셰이더 효과)
   - testHolo 멀티레이어 모드: 코드/에셋 보존하되 표시에는 사용 안 함
2. **글레어(반사광) 레이어** (`GlareLayer`)
3. **3D 틸트 + 포인터 인터랙션** (`HoloCard` + `PointerMath`) — 단, 모바일 터치 대응 추가 필요(`MouseRegion` 호버는 데스크톱 전용이므로 터치 드래그 트리거로 변환)
4. **흔들림 방지 렌더링 기법** (`ui.Image` 캐싱 + `CustomPaint` + `shouldRepaint=false`)
5. **HoloGrade → 홀로 효과 매핑 비즈니스 로직** (신규 작성)

### 10.2 백엔드 연동으로 새로 추가해야 하는 기능 (main 전체 역추출)
6. **인증 시스템 실구현**: 이메일/소셜 로그인, 토큰 관리, 재인증
7. **사진 업로드 + AI 종 식별 파이프라인**: `camera_screen` → `photo_preview` → `analysis_status`(실제 폴링) → 카드 생성
8. **발견 카드 CRUD API 연동**: fixture → 실제 Repository 구현체
9. **카드 좋아요/공유 API**
10. **퀘스트 API 연동**: 목록/상세/미션 완료
11. **마이페이지 API 연동**: 통계/배지/최근관찰
12. **프로필 수정 API 연동**: 닉네임/이메일/비밀번호/소셜연결/알림설정
13. **지도/위치 기능**: 지도 SDK + 발견 위치 저장/조회

### 10.3 인프라/의존성 추가
14. HTTP 클라이언트 (Dio 또는 http)
15. 인증 토큰 저장 (flutter_secure_storage 권장)
16. (사진 선택 기능 추가 시) image_picker, croppy, path_provider
17. (지도 기능 시) google_maps_flutter 또는 flutter_map, geolocator
18. (카메라 실구현 시) camera 패키지

---

## 11. sample-project에서 가져와도 되는 코드

> main-project 컨벤션(feature-based 구조, Repository 패턴, 디자인 시스템 토큰, setState)에 맞게 **재포장하여** 가져오는 것을 전제.

| 코드 | 파일 | 가져오는 방식 | 비고 |
|------|------|--------------|------|
| 홀로 셰이더 | `shaders/holo.frag` | 그대로 복사 + pubspec `shaders:` 등록 | GLSL 코드는 main 컨벤션과 무관 |
| 홀로 테스트 에셋 | `assets/holo_test/*.png` 8장 | 그대로 복사 + pubspec assets 등록 | testHolo 모드 보존용 |
| 홀로 포일 레이어(셰이더 모드) | `lib/widgets/layers/shine_layer.dart` 중 `_ShaderPainter` + 셰이더 로드 로직 | rename(`HoloShineLayer`), `Rarity`→`HoloGrade` 시그니처 변경, 이미지 홀로 모드 제거 | 핵심 렌더링 |
| 홀로 포일 레이어(테스트 모드) | 동일 파일 중 `_TestHoloPainter` + `_loadTestLayers` | 코드 보존, 표시 안 함(분기 닫기) | 향후 seasonalHolo 후보 |
| 글레어 레이어 | `lib/widgets/layers/glare_layer.dart` | rename(`HoloGlareLayer`), 라이트 톤에 맞춰 alpha 재조정 | Opacity 위젯 금지 주석 유지 |
| 3D 틸트 + 흔들림 방지 | `lib/widgets/holo_card.dart` 중 `_HoloCardState` 로직 + `_PhotoPainter` | rename(`HoloCardRender`), `CardData` 의존 제거, 사진 소스를 asset으로 변경, 다크 베이스→라이트 톤, `FramePainter` 제거 | 핵심 인터랙션 |
| 포인터 수학 | `lib/utils/pointer_math.dart` | 그대로 복사 | 수학 유틸, 의존성 없음 |

> **사진 선택/저장(`PhotoService`)/카드 저장(`CardStore`)/그리드(`CardGrid`)/에디터(`CardEditorDialog`)/프레임 페인터(`FramePainter`)/`Rarity` enum** 은 사용자 생성 카드 기능이 제외되므로 가져오지 않음. 단, 향후 main의 카메라 플레이스홀더를 실구현할 때 `PhotoService`의 image_picker+croppy 사용 패턴은 **참고만** 할 수 있음(그대로 복사 금지, main의 업로드 API 파이프라인에 맞춰 재작성).

---

## 12. sample-project에서 절대 가져오면 안 되는 코드

| 코드 | 파일 | 사유 |
|------|------|------|
| 다크 테마 설정 | `lib/main.dart` `ThemeData(Brightness.dark, seedColor 0xFFA855F7)` | main은 라이트 테마 유지 |
| `CardData` 모델 | `lib/models/card_data.dart` | 사용자 생성 카드 도메인이 제외됨. main의 `CardDetailData`와 충돌 |
| `Rarity` enum + `RarityX` | 동일 파일 | main의 `HoloGrade` 3종으로 대체. 1:1 매핑 금지 |
| `CardStore` (SharedPreferences 저장소) | `lib/services/card_store.dart` | main은 서버 API + Repository 패턴 사용. 로컬 저장 패턴 그대로 가져오면 안 됨 |
| `PhotoService`의 저장 로직 | `lib/services/photo_service.dart` 중 `_persistHoloImage`, `_cropAndPersist`의 파일 기록 부분 | main은 객체 스토리지 업로드 API로 가야 함. 크롭 UI 패턴만 참고 |
| `CardGrid` 위젯 | `lib/widgets/card_grid.dart` | 다크 테마 하드코딩 색상. main 디자인 시스템(AppColors/AppTextStyles)에 맞춰 재작성 필요 |
| `CardEditorDialog` | `lib/widgets/card_editor_dialog.dart` | 수동 카드 편집 UI. main은 AI 분석 파이프라인으로 카드 생성. 하드코딩 색상(0xFF1F1F1F 등) |
| `FramePainter` (오리지널 트레이딩 카드 프레임) | `lib/painters/frame_painter.dart` | main의 `DiscoveryHeroCard` 컨테이너 디자인 유지. 폰트 Roboto 하드코딩. main 팔레트에 맞지 않음 |
| `HomePage` (스튜디오 화면) | `lib/main.dart` | 별도 스튜디오 화면 안 만듦. 기존 `DiscoveryCardDetailScreen`에 통합 |
| `Rarity.testHolo`의 "실제 표시 사용" | — | testHolo는 코드/에셋 보존만, 표시에는 사용 안 함 |
| `holoImagePath` 사용자 홀로 이미지 선택 모드 | `shine_layer.dart` 중 `_ImageHoloPainter`, `_loadHoloImage`, `_loadedImagePath` | 레이어 선택 기능 제거 |
| `vector_math` 패키지 의존성 | `pubspec.yaml` | sample에 선언만 있고 미사용. 추가 불필요 |
| About 다이얼로그 텍스트 | `lib/main.dart` `_showAbout` | sample 전용 설명 (포켓몬 카드 참고 등) |
| 네이티브 카메라/갤러리 권한 설정 (sample 기준) | — | sample은 카메라/갤러리 기능이 있어 권한 필요했으나, main 이식에서는 사진 선택 기능 제외 → 권한 설정 불필요 (단, main 자체의 카메라 실구현 시 별도 권한 설정 필요) |

---

## 13. 본 프로젝트에 맞춘 단계별 이식 계획

> 원칙: main-project의 **feature-based 구조 + Repository 패턴 + 디자인 시스템 토큰 + setState 상태관리 + 라이트 테마**를 준수. sample 코드를 그대로 복사하지 않고 재포장.

### Phase 0 — 사전 준비 (의존성 + 에셋)
1. `pubspec.yaml`에 `shaders: - shaders/holo.frag` 섹션 신규 추가
2. `pubspec.yaml` `assets:`에 `assets/holo_test/` 추가
3. `shaders/holo.frag` 파일 복사
4. `assets/holo_test/` PNG 8장 복사
5. `flutter pub get` + 셰이더 컴파일 확인
6. (이 단계에서는 image_picker/croppy/path_provider/shared_preferences **추가 안 함** — 사진 선택/저장 기능 제외)

### Phase 1 — 홀로 렌더링 매핑 로직 (비즈니스 로직)
1. `lib/features/card_detail/utils/pointer_math.dart` 신규 — sample의 `PointerMath` 그대로
2. `HoloGrade → 홀로 효과 파라미터` 매핑 신규 작성:
   - `normal`: 홀로 효과 없음 + 글레어만 (sample `basic`과 동일)
   - `holo`: 임의 셰이더 인덱스 지정 (이식 시 임의, 디자인 검토 후 조정)
   - `seasonalHolo`: 임의 셰이더 인덱스 지정 (동일)
   - testHolo: 매핑하지 않음(표시 안 함)
3. 기존 `lib/features/card_detail/models/card_detail_data.dart`(`HoloGrade`)는 **수정 없음**

### Phase 2 — 홀로 렌더링 레이어 위젯
1. `lib/features/card_detail/widgets/layers/holo_shine_layer.dart` 신규 — sample `ShineLayer` 재포장:
   - `Rarity` → `HoloGrade` 시그니처 변경
   - 이미지 홀로 모드(`_ImageHoloPainter` 등) 제거
   - testHolo 모드(`_TestHoloPainter`) 코드 보존, 분기 닫기(상수 플래그 false)
   - `_ShaderPainter` 유지
2. `lib/features/card_detail/widgets/layers/holo_glare_layer.dart` 신규 — sample `GlareLayer` 재포장:
   - 라이트 톤에 맞춰 alpha 재조정(흰 배경에서 글레어가 안 보이는 문제 해결)
   - Opacity 위젯 금지 주석 유지

### Phase 3 — 홀로 카드 렌더 위젯 + 히어로 카드 통합
1. `lib/features/card_detail/widgets/holo_card_render.dart` 신규 — sample `HoloCard` 재포장:
   - rename `HoloCardRender`
   - `CardData` 의존 제거 → `HoloGrade` + 이미지 소스(asset 경로) 입력
   - 사진 소스: `assets/images/sample_card_image/Ginkgobilobac.webp` (rootBundle 로드)
   - 다크 베이스(`0xFF1A1A1A`) → `AppColors.backgroundElevated`/`LqColors.cardCream`
   - 그림자 → `AppShadows.card`
   - `FramePainter` 제거 (main의 `DiscoveryHeroCard` 컨테이너 디자인 유지)
   - `onTap`/`onLongPress` 제거
   - **모바일 터치 대응 추가**: `MouseRegion` 호버(데스크톱) + `GestureDetector.onPanUpdate`(터치 드래그)로 포인터 갱신
2. `lib/features/card_detail/widgets/discovery_hero_card.dart` 수정:
   - `_buildHeroImage`의 `_GinkgoLeafPainter` placeholder를 `HoloCardRender`로 교체
   - 카드 이미지 소스: `Ginkgobilobac.webp`
   - `HoloBadge`/이름/학명/카테고리칩/설명 영역은 그대로 유지
3. 도메인 모델(`CardDetailData`)은 수정 없음

### Phase 4 — 검증
1. `flutter analyze` 통과
2. `flutter build` (iOS/Android/macOS) 셰이더 컴파일 확인
3. 실제 기기에서 홀로/글레어/틸트 동작 확인 (터치 드래그 + 데스크톱 호버)
4. 라이트 배경에서 홀로 색상/글레어 강도 튜닝
5. testHolo 모드가 표시되지 않는지 확인 (분기 닫힘 확인)

### Phase 5 — 백엔드 연동 (별도 작업, 본 이식과 독립)
> 본 이식(홀로 카드 렌더링) 완료 후, main-project 전체의 백엔드 연동은 별도 단계로 진행.
1. HTTP 클라이언트 + 인증 인프라 구축
2. 각 Repository Mock 구현체 → 실제 API 구현체 교체 (7장 API 목록 참조)
3. fixture 파일 제거
4. AI 종 식별 파이프라인(`analysis_status_screen` 실구현)
5. 카메라/지도/위치 실구현

---

## 부록: main-project 화면별 데이터 소스 매핑 (현재 상태)

| 화면 | 현재 데이터 소스 | 백엔드 연동 후 예상 |
|------|-----------------|---------------------|
| WelcomeScreen | 하드코딩(배경 asset) | 변경 없음 |
| LoginScreen | 하드코딩(배경 asset) | `/auth/login` |
| HomeScreen | 화면 내 하드코딩(quests/discoveries/banners/logs) | `/quests/today`, `/cards/recent`, 배너 API |
| DiscoveryCardScreen | `DiscoveryRepository`(Mock→fixture) | `/cards`, `/cards/grouped` |
| DiscoveryCardDetailScreen | `sampleCardDetail` fixture 직접 참조 | `/cards/{id}` |
| MyPageScreen | `MyPageFixture.sample` 직접 참조 | `/users/me/summary` |
| ProfileEditScreen | `ProfileEditFixture.sample` 직접 참조 | `/users/me` |
| QuestDetailScreen | `QuestDetailFixture.springPlants` 직접 참조 | `/quests/{id}` |
| AccountVerificationScreen(Method) | 하드코딩(`AccountVerificationMethodData`) | `/auth/reverify/methods` |
| AccountVerificationScreen(Password) | `MockAccountVerificationRepository` | `/auth/reverify/password` |
| AccountVerificationScreen(Social) | 하드코딩(`SocialAccountVerificationData`) | `/auth/reverify/oauth/{provider}` |
| CameraScreen | 하드코딩(플레이스홀더) | camera 패키지 + `/uploads/image` |
| PhotoPreviewScreen | 하드코딩(그라데이션 플레이스홀더) | 업로드된 이미지 표시 + `/analysis/identify` |
| AnalysisStatusScreen | `Future.delayed` 가짜 시뮬레이션 | `/analysis/{id}` 폴링 |
| MapScreen | 하드코딩(지도 플레이스홀더) | 지도 SDK + `/locations` |
| PlanScreen | 하드코딩 | 구독/결제 API |
| DiscoveryIntroScreen | 하드코딩 | 변경 없음(정적) |

---

## 부록: 백엔드 API 연동 필요 지점(TODO) 전체 목록

| 파일 | 라인 | 내용 |
|------|------|------|
| `data/discovery_repository.dart` | 7, 13, 21, 32 | 발견 카드 목록 API |
| `features/card_detail/data/card_detail_fixtures.dart` | 5 | 카드 상세 API |
| `screens/discovery_card_detail_screen.dart` | 34, 57, 72, 87, 89, 91, 98, 119 | 카드 상세/공유/지도/카메라/좋아요 API |
| `screens/discovery_card_screen.dart` | 73, 424 | 검색 API, 카메라 이동 |
| `screens/my_page_screen.dart` | 43, 46, 49, 52, 61, 68, 74 | 마이페이지 관련 API |
| `screens/profile_edit_screen.dart` | 49, 55 | 프로필 수정/탈퇴 API |
| `screens/quest_detail_screen.dart` | 42 | 퀘스트 대상 목록 API |
| `screens/account_verification_screen_method.dart` | 67 | 소셜 재인증 |
| `screens/account_verification_screen_password.dart` | 97 | 비밀번호 재설정 |
| `screens/account_verification_screen_social.dart` | 46 | 소셜 재인증 |
| `features/profile_edit/widgets/profile_edit_header_card.dart` | 58 | 프로필 이미지 변경 |
| `features/profile_edit/widgets/password_section_card.dart` | 40 | 비밀번호 변경 |
| `features/profile_edit/widgets/notification_settings_section_card.dart` | 28 | 알림 설정 |
| `features/profile_edit/widgets/email_section_card.dart` | 45 | 이메일 변경 |
| `features/profile_edit/widgets/connected_accounts_section_card.dart` | 32, 40 | 소셜 연결 관리 |
| `features/profile_edit/widgets/basic_info_section_card.dart` | 37, 49, 61, 74 | 닉네임/생일/성별/언어 |
| `features/my_page/widgets/my_page_app_bar.dart` | 28 | 알림 페이지 |
| `features/quest_detail/widgets/required_quest_items_section.dart` | 70 | 대상 상세 |
| `features/quest_detail/widgets/quest_mission_card.dart` | 50 | 미션 완료 |
| `features/quest_detail/widgets/quest_detail_app_bar.dart` | 32 | 퀘스트 공유 |
| `features/account_verification/repositories/account_verification_repository.dart` | 10 | Mock → 실제 API |
| `screens/analysis_status_screen.dart` | `_simulateAnalysis` | AI 종 식별 API (가짜 시뮬레이션 교체) |

---

*본 문서는 sample-project 분석을 통한 역추출 결과이며, 코드 수정은 수반하지 않습니다. main-project의 기존 도메인/디자인 시스템을 우선하고, sample의 mock 데이터는 모델 후보로만 참고합니다.*
