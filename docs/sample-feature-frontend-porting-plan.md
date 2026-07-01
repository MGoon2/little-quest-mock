# Sample-Project → Main-Project 프론트엔드 이식 계획

> **목적**: sample-project(`pocketmon-card-holo/flutter_application_1`)의 홀로 카드 렌더링 기능을 main-project(`little-quest/little_quest`)의 **디자인 시스템과 화면 구조에 맞게 재구성**하여 이식하기 위한 프론트엔드 계획.
>
> **원칙**:
> - sample-project의 UI를 그대로 복사하지 않는다.
> - main-project의 디자인 시스템(`AppColors`/`LqColors`/`AppTextStyles`/`AppSpacing`/`AppRadius`/`AppShadows`)과 화면 구조(feature-based, `DiscoveryCardDetailScreen`)를 우선한다.
> - 본 문서는 계획만 작성하며, 코드 수정은 수반하지 않는다.
>
> **사전 합의사항**(이전 대화 기반):
> - 이식 지점: `DiscoveryCardDetailScreen` 최상단 `DiscoveryHeroCard._buildHeroImage` 교체 (별도 스튜디오 화면 안 만듦)
> - 등급 매핑: main의 `HoloGrade`(normal/holo/seasonalHolo) 3종 사용. sample의 `Rarity` 6종은 1:1 매핑 금지, 참고용만.
> - `normal` = 홀로 효과 없음 + 글레어만 (sample `basic`과 동일)
> - `holo`/`seasonalHolo` = 임의 셰이더 효과 (이식 시 임의 지정, 디자인 검토 후 조정)
> - 레이어 선택 기능(`holoImagePath`) 제거
> - testHolo 멀티레이어 모드: 코드/에셋 보존, 표시에는 사용 안 함
> - 사진 소스: `assets/images/sample_card_image/Ginkgobilobac.webp` (사용자 사진 선택 기능 제외)
> - 라이트 톤 유지 (다크 테마 이식 금지)
> - 도메인 모델(`CardDetailData`/`HoloGrade`)은 수정 없이 위젯 렌더링만 교체

---

## 1. main-project에 추가/수정할 화면

> 별도 신규 화면은 만들지 않는다. 기존 화면 1곳을 수정하고, 홀로 렌더링 위젯을 feature 내에 추가한다.

### 1.1 수정할 화면 (1곳)

| 화면 | 파일 | 수정 내용 | 비고 |
|------|------|----------|------|
| 카드 상세 | `lib/screens/discovery_card_detail_screen.dart` | 변경 없음 (이미 `DiscoveryHeroCard`를 사용 중) | 화면 자체는 그대로, 하위 위젯만 교체 |

### 1.2 수정할 위젯 (1곳, 화면 내부)

| 위젯 | 파일 | 수정 내용 |
|------|------|----------|
| 대표 카드(히어로) | `lib/features/card_detail/widgets/discovery_hero_card.dart` | `_buildHeroImage`의 `_GinkgoLeafPainter` placeholder를 신규 `HoloCardRender` 위젯으로 교체. 카드 컨테이너(보더/배경/그림자), `HoloBadge`(좌상단), 이름/학명/카테고리칩/설명 영역은 **그대로 유지**. 이미지 영역(현재 높이 220, `leafLight` 배경 + 은행잎 CustomPaint)만 홀로 카드 렌더링으로 교체. |

### 1.3 신규 추가 파일 (위젯/유틸, 화면 아님)

| 파일 | 역할 |
|------|------|
| `lib/features/card_detail/utils/pointer_math.dart` | 포인터 → 3D 회전각 변환 수학 유틸 (sample 그대로) |
| `lib/features/card_detail/widgets/layers/holo_shine_layer.dart` | 홀로그래픽 포일 레이어 (셰이더 모드 + testHolo 모드 보존, 이미지 홀로 모드 제거) |
| `lib/features/card_detail/widgets/layers/holo_glare_layer.dart` | 글레어(반사광) 레이어 |
| `lib/features/card_detail/widgets/holo_card_render.dart` | 홀로 카드 메인 렌더 위젯 (3D 틸트 + 레이어 합성 + 흔들림 방지) |
| `shaders/holo.frag` | GLSL Fragment Shader (프로젝트 루트) |
| `assets/holo_test/*.png` (8장) | testHolo 멀티레이어 에셋 |

### 1.4 신규 추가하지 않을 화면 (명시적 제외)

| 제외 화면 | 사유 |
|-----------|------|
| 홀로 카드 스튜디오(`HomePage`류) | 별도 스튜디오 화면 안 만듦 |
| 카드 생성/편집 다이얼로그(`CardEditorDialog`류) | 사용자 사진 선택/수동 편집 기능 제외 |
| 카드 그리드 화면(`CardGrid`류) | 기존 `DiscoveryCardScreen` 그리드 유지 |
| 카드 삭제/About 다이얼로그 | main 도메인에 해당 개념 없음 |

---

## 2. 재사용할 기존 컴포넌트

> main-project에 이미 존재하는 컴포넌트/토큰을 그대로 사용. 새로 만들지 않음.

### 2.1 디자인 시스템 토큰

| 토큰 | 파일 | 사용처 |
|------|------|--------|
| `AppColors.backgroundElevated` | `theme/app_colors.dart` | 홀로 카드 베이스 배경 (다크 `0xFF1A1A1A` 대체) |
| `AppColors.leafLight` | 동일 | 카드 이미지 영역 배경 fallback |
| `AppColors.primary`/`primaryLight`/`primarySoft` | 동일 | 홀로 효과 색상 보조, 글레어 톤 |
| `AppColors.textInverse` | 동일 | 글레어 하이라이트 |
| `LqColors.cardCream`/`cream` | `theme/lq_colors.dart` | 카드 베이스 대안 |
| `AppShadows.card`/`soft` | `theme/app_shadows.dart` | 카드 그림자 (sample `Colors.black alpha 0.5` 대체) |
| `AppRadius.lg`(20)/`xl`(24) | `theme/app_radius.dart` | 카드 모서리 둥글기 |
| `AppSpacing.lg`(16)/`xl`(20)/`screenPadding`(20) | `theme/app_spacing.dart` | 카드 내부 패딩 |
| `AppTextStyles` 전체 | `theme/app_text_styles.dart` | 카드 주변 텍스트 (Pretendard/Jua/Fredoka) |
| `AppTheme.light` | `theme/app_theme.dart` | 앱 테마 (그대로 유지, 다크 테마 이식 금지) |

### 2.2 기존 위젯 (수정 없이 재사용)

| 위젯 | 파일 | 역할 |
|------|------|------|
| `HoloBadge` | `features/card_detail/widgets/holo_badge.dart` | 카드 좌상단 등급 배지 (그대로 유지) |
| `CategoryChip` | `features/card_detail/widgets/category_chip.dart` | 카테고리/서브카테고리 칩 (그대로 유지) |
| `HoloProgressCard` | `features/card_detail/widgets/holo_progress_card.dart` | 등급 진행 바 (그대로 유지, 홀로 효과와 무관) |
| `DiscoveryRecordCard` | `features/card_detail/widgets/discovery_record_card.dart` | 발견 기록 카드 (그대로 유지) |
| `ObservationHistoryCard` | `features/card_detail/widgets/observation_history_card.dart` | 관찰 기록 카드 (그대로 유지) |
| `CardDetailBottomActionBar` | `features/card_detail/widgets/card_detail_bottom_action_bar.dart` | 하단 액션 바 (그대로 유지) |
| `PrimaryButton` | `components/primary_button.dart` | (필요 시) 홀로 카드 내 버튼 |
| `AppScaffold` | `components/app_scaffold.dart` | (화면 단위, 직접 사용은 안 하나면 컨텍스트 참조) |

### 2.3 기존 도메인 모델 (수정 없이 재사용)

| 모델 | 파일 | 비고 |
|------|------|------|
| `CardDetailData` | `features/card_detail/models/card_detail_data.dart` | `currentGrade: HoloGrade` 필드를 홀로 렌더링에 전달 |
| `HoloGrade` enum | 동일 | normal/holo/seasonalHolo (수정 금지) |
| `HoloGradeX` extension | 동일 | `.label`/`.description` (수정 금지) |

---

## 3. 새로 만들 컴포넌트

> sample-project 코드를 main 컨벤션에 맞게 재포장하여 신규 작성. 그대로 복사 아님.

### 3.1 `HoloCardRender` (메인 렌더 위젯)
- **파일**: `lib/features/card_detail/widgets/holo_card_render.dart`
- **역할**: 홀로 카드 이미지 영역 렌더링 (3D 틸트 + 홀로 포일 + 글레어 + 흔들림 방지)
- **입력**: `HoloGrade grade`, `String imageAssetPath`, `double width`/`height`(선택)
- **기반**: sample `HoloCard`(`lib/widgets/holo_card.dart`)
- **수정 포인트**:
  - `CardData` 의존 제거 → `HoloGrade` + asset 경로 입력
  - 사진 로드: `File(path)` → `rootBundle.load('assets/images/sample_card_image/Ginkgobilobac.webp')` + `instantiateImageCodec`
  - 다크 베이스(`Container(color: 0xFF1A1A1A)`) → `AppColors.backgroundElevated`
  - 그림자(`Colors.black alpha 0.5, blurRadius 20`) → `AppShadows.card` 또는 `soft`
  - 카드 모서리(`h * 0.035`) → `AppRadius.lg`(20) 기준 조정
  - `FramePainter` 합성 제거 (main의 `DiscoveryHeroCard` 컨테이너가 프레임 역할)
  - `onTap`/`onLongPress`/`GestureDetector` 제거 (표시 전용)
  - **모바일 터치 대응 추가**: `MouseRegion`(데스크톱 호버) + `GestureDetector.onPanUpdate`(터치 드래그)로 `_pointerX/_pointerY` 갱신. 터치 종료 시 spring-back.
  - 사진 패딩/반경 비율은 sample 그대로 유지(`h * 0.02`, `h * 0.025`)하되 main `AppRadius`와 조화 검토
- **상태**: `_HoloCardRenderState`(StatefulWidget) — `ValueNotifier<double>` 포인터/페이드 + `AnimationController` spring-back + `ui.Image?` 사진 캐시

### 3.2 `HoloShineLayer` (홀로 포일 레이어)
- **파일**: `lib/features/card_detail/widgets/layers/holo_shine_layer.dart`
- **역할**: 홀로그래픽 포일 효과 (셰이더 모드 + testHolo 모드 보존)
- **입력**: `HoloGrade grade`, `double pointerX/Y`, `double opacity`, `double intensity`
- **기반**: sample `ShineLayer`(`lib/widgets/layers/shine_layer.dart`)
- **수정 포인트**:
  - `Rarity` → `HoloGrade` 시그니처 변경
  - `_rarityIndex` 스위치 재작성: `normal`=홀로 없음(빈 위젯), `holo`=임의 셰이더 인덱스, `seasonalHolo`=임의 셰이더 인덱스
  - 이미지 홀로 모드(`_ImageHoloPainter`, `_loadHoloImage`, `_loadedImagePath`, `holoImagePath` 파라미터) 전체 제거
  - testHolo 모드(`_TestHoloPainter`, `_loadTestLayers`, `_testAssetPaths`) 코드 보존: 분기를 상수 `false`로 닫아 표시 안 함. 주석 "향후 seasonalHolo 적용 후보, 현재 미사용"
  - `_ShaderPainter` 유지, uniform 세팅 그대로
  - `cardAspect: 2.5/3.5` 유지 (트레이딩 카드 비율)
- **하위 페인터**: `_ShaderPainter`, `_TestHoloPainter`(보존)

### 3.3 `HoloGlareLayer` (글레어 레이어)
- **파일**: `lib/features/card_detail/widgets/layers/holo_glare_layer.dart`
- **역할**: 포인터 위치 기반 반사광 (RadialGradient + BlendMode)
- **입력**: `double pointerX/Y`, `double opacity`
- **기반**: sample `GlareLayer`(`lib/widgets/layers/glare_layer.dart`)
- **수정 포인트**:
  - rename `HoloGlareLayer`
  - **라이트 톤 alpha 재조정 (핵심)**: sample은 다크 카드 기준 `Color.fromRGBO(255,255,255,0.6*opacity)`. 흰/크림 배경에서는 흰색 글레어가 묻힘 → 어두운 톤 글레어(`AppColors.primary` 기반) 또는 강도 상향 검토. `normal` 등급은 글레어만 표시되므로 이 튜닝이 중요.
  - `Opacity` 위젯 사용 금지 주석 유지 (Paint color alpha로 직접 적용)
- **하위 페인터**: `_GlarePainter`

### 3.4 `PointerMath` (수학 유틸)
- **파일**: `lib/features/card_detail/utils/pointer_math.dart`
- **역할**: 포인터(0~1) → 3D 회전각/홀로 배경 위치/중심 거리 변환
- **기반**: sample `PointerMath`(`lib/utils/pointer_math.dart`)
- **수정 포인트**: 없음 (수학 유틸, 그대로 복사). main에 `utils/` 폴더 관례가 없으면 feature 내 `utils/` 하위에 신설.

### 3.5 `HoloGradeEffect` (매핑 로직, 신규 작성)
- **파일**: `lib/features/card_detail/utils/holo_grade_effect.dart` (또는 `HoloShineLayer` 내부)
- **역할**: `HoloGrade` → 홀로 렌더링 파라미터(`{hasHolo, shaderRarityIndex, intensity, glareStrength}`) 매핑
- **규칙**:
  - `normal`: `hasHolo=false` (shine 생략), 글레어만
  - `holo`: `hasHolo=true`, `shaderRarityIndex`=임의(sample regularHolo=1 가정), `intensity` 튜닝
  - `seasonalHolo`: `hasHolo=true`, `shaderRarityIndex`=임의(sample hyperRare=4 가정), `intensity` 튜닝
  - testHolo: 매핑 대상 아님
- **비고**: 순수 매핑 로직, 의존성 없음. `holo`/`seasonalHolo`의 정확한 셰이더 인덱스는 이식 후 디자인 검토로 확정.

---

## 4. 필요한 hook/state/controller

> main-project는 **상태관리 라이브러리(Provider/Riverpod/Bloc)를 사용하지 않음**. Flutter 기본 `StatefulWidget` + `setState` + `ValueNotifier` 패턴 준수. "hook"은 Flutter에 없으므로 state/controller로 해석.

### 4.1 신규 State/Controller

| State/Controller | 위치 | 역할 | 기반 |
|------------------|------|------|------|
| `_HoloCardRenderState` | `holo_card_render.dart` | 포인터 추적 + 3D 틸트 + spring-back 애니메이션 + 사진 캐시 | sample `_HoloCardState` |
| `_HoloShineLayerState` | `holo_shine_layer.dart` | 셰이더 프로그램 로드 + testHolo 레이어 로드 + 시간 업데이트 | sample `_ShineLayerState` |

### 4.2 State 내부 관리 객체

| 객체 | 타입 | 역할 |
|------|------|------|
| `_pointerX`/`_pointerY` | `ValueNotifier<double>` (0~1) | 포인터 정규화 좌표 |
| `_fade` | `ValueNotifier<double>` (0~1) | 홀로/글레어 페이드 (진입 시 1, 이탈 시 0) |
| `_anim` | `AnimationController` (600ms) | spring-back 애니메이션 |
| `_fadeAnim` | `Animation<double>?` | 페이드 트윈 |
| `_photoImage` | `ui.Image?` | 미리 로드된 사진 (흔들림 방지용 캐시) |
| `_program` | `ui.FragmentProgram?` | 홀로 셰이더 프로그램 (`HoloShineLayer`) |
| `_testLayers` | `List<ui.Image?>` (8) | testHolo 멀티레이어 에셋 (`HoloShineLayer`) |

### 4.3 기존 State (수정 없음)

| State | 파일 | 비고 |
|-------|------|------|
| `_DiscoveryCardDetailScreenState` | `discovery_card_detail_screen.dart` | `_data`/`_onToggleFavorite` 유지. 홀로 카드는 `DiscoveryHeroCard` 하위에서 자체적으로 상태 관리 (부모와 무관하게 동작) |

### 4.4 전역 상태관리 도입 여부
- **도입 안 함**: 홀로 카드 렌더링은 자체 완결적(StatefulWidget 내부 `ValueNotifier`)이므로 전역 상태관리 불필요.
- 단, 향후 백엔드 연동(Phase 5) 시 인증 토큰/사용자 상태를 전역으로 관리할 필요가 생기면 그때 별도 도입 검토 (본 이식 범위 밖).

---

## 5. 필요한 API client 함수

> **본 이식(홀로 카드 렌더링)은 클라이언트 로직이므로 API 호출이 필요 없음.** 아래는 참고용으로, 백엔드 연동(Phase 5) 시 필요한 API client 함수를 명시.

### 5.1 본 이식에 필요한 API (없음)
홀로 카드 렌더링은 셰이더/CustomPainter로 클라이언트에서 완결. `HoloGrade`는 이미 `CardDetailData.currentGrade`에 포함되어 있어 별도 API 호출 불필요.

### 5.2 백엔드 연동 시 필요한 API client 함수 (참고, 본 이식 범위 밖)

| 함수 | 대응 API | 비고 |
|------|---------|------|
| `getCardDetail(cardId)` | `GET /cards/{id}` | 현재 `sampleCardDetail` fixture 교체 |
| `toggleCardFavorite(cardId)` | `POST /cards/{id}/favorite` | `_onToggleFavorite` 실구현 |
| `shareCard(cardId)` | `POST /cards/{id}/share` | 공유 링크 생성 |
| `uploadImage(file)` | `POST /uploads/image` | (사진 선택 기능 추가 시) |
| `requestAnalysis(uploadId)` | `POST /analysis/identify` | AI 종 식별 |
| `pollAnalysis(jobId)` | `GET /analysis/{id}` | 분석 결과 폴링 |

> API client 구현은 본 이식(Phase 0~4) 완료 후 Phase 5에서 별도 진행. 본 이식에서는 fixture 기반 그대로 유지.

---

## 6. 로딩/에러/빈 상태 처리

> 홀로 카드 렌더링 위젯 내부의 비동기 리소스 로드(셰이더/이미지/에셋)에 대한 상태 처리.

### 6.1 로딩 상태

| 리소스 | 로딩 중 처리 | 완료 처리 |
|--------|-------------|-----------|
| 사진(`Ginkgobilobac.webp`) | `_photoImage == null` 동안: 카드 베이스(`AppColors.backgroundElevated`) + 중앙 `CircularProgressIndicator`(또는 `Icon(Icons.photo, color: AppColors.textTertiary)`) | `setState` 후 `_PhotoPainter`로 렌더 |
| 홀로 셰이더(`holo.frag`) | `_shaderLoaded == false` 동안: `SizedBox.shrink` (shine 레이어 생략, 카드 베이스+사진+글레어만 표시) | `setState` 후 `_ShaderPainter`로 렌더 |
| testHolo 에셋(8장 PNG) | `_testLayersLoaded == false` 동안: `SizedBox.shrink` (단, testHolo는 표시 안 하므로 실제 로드 안 됨) | — |

### 6.2 에러 상태

| 리소스 | 에러 처리 |
|--------|-----------|
| 사진 로드 실패 | `_photoError = true` → 카드 베이스 + `Icon(Icons.broken_image, color: AppColors.textTertiary)`. `debugPrint`로 로그. 사용자에게 에러 UI 노출은 최소화 (도감 카드이므로 정적 표시). |
| 셰이더 로드 실패 | `debugPrint('Failed to load holo shader: $e')` → shine 레이어 생략, 카드는 사진+글레어만으로 동작 (graceful degradation). 홀로 효과가 없어도 카드 자체는 표시됨. |
| testHolo 에셋 로드 실패 | `debugPrint`만, 표시 안 하므로 사용자 영향 없음 |

### 6.3 빈 상태
- 홀로 카드 렌더링 자체에는 "빈 상태" 개념이 없음 (항상 사진+등급이 주어짐).
- `HoloGrade.normal`인 경우: shine 레이어 생략(빈 위젯), 글레어만 표시. 이것은 "빈 상태"가 아니라 정상적인 `normal` 등급 표현.

### 6.4 디자인 시스템 적용
- 로딩/에러 위젯의 색상은 `AppColors.textTertiary`/`AppColors.surface` 사용 (하드코딩 금지).
- `CircularProgressIndicator`의 `color`는 `AppColors.primary`.

---

## 7. 권한별 화면 처리

> main-project의 "권한"은 **인증 상태**(로그인/비로그인/재인증)를 의미. 홀로 카드 렌더링 자체는 인증과 무관하지만, 카드 상세 화면 진입 조건과 연관.

### 7.1 홀로 카드 렌더링의 권한 의존성
- **없음**: `HoloCardRender`는 `HoloGrade` + asset 경로만 받아 렌더링. 인증 토큰/사용자 ID 불필요.
- 카드 상세 화면(`DiscoveryCardDetailScreen`) 진입은 현재 별도 인증 게이트 없이 라우트로 직접 이동.

### 7.2 백엔드 연동 시 권한 처리 (참고, 본 이식 범위 밖)

| 상태 | 처리 | 비고 |
|------|------|------|
| 비로그인 → 카드 상세 진입 | 현재: 그대로 진입 (fixture 표시). 백엔드 연동 후: `GET /cards/{id}`가 401 → 로그인 화면으로 리다이렉트 | 본 이식에서는 변경 없음 |
| 로그인됨 → 카드 상세 진입 | 정상 표시 | |
| 프로필 수정 진입 | 재인증(`/account-verification`) 선행 → `/profile-edit` | 기존 흐름 유지, 홀로 카드와 무관 |
| 카드 좋아요 토글 | 현재: 로컬 `setState`. 백엔드 연동 후: 로그인 필요 | 본 이식에서는 기존 `_onToggleFavorite` 유지 |

### 7.3 카메라/갤러리 권한
- 본 이식에서 사진 선택 기능 제외 → 카메라/갤러리 권한 설정 **불필요**.
- (참고) main의 기존 `CameraScreen` 플레이스홀더는 실구현 시 별도 권한 필요하나, 본 이식과 무관.

---

## 8. 반응형 처리

> main-project는 모바일 앱(iOS/Android) 중심. 반응형 = 화면 크기/방향 대응 + 폰트 스케일링 + 다크/라이트 모드.

### 8.1 화면 크기 대응

| 요소 | 처리 방식 |
|------|-----------|
| 홀로 카드 크기 | `HoloCardRender`의 `width`/`height`를 부모 `DiscoveryHeroCard`의 `LayoutBuilder` 제약에 맞춤. 현재 hero 이미지 영역 높이 220 고정 → `MediaQuery` 또는 `LayoutBuilder`로 화면 너비에 비례 조정 검토 (큰 화면에서 카드가 너무 작아지지 않게) |
| 카드 비율 | 2.5:3.5(트레이딩 카드 표준) 유지. 화면 크기와 무관하게 종횡비 고정 |
| 텍스트 | `AppTextStyles`의 고정 `fontSize` 사용 → 시스템 폰트 스케일링 적용 여부 검토 (`MediaQuery.textScaleFactor` 고려). 단, main 기존 코드가 고정 폰트 크기이므로 일관성 유지 차원에서 그대로 고정. |

### 8.2 방향 대응
- main-project는 세로 방향(portrait) 전용으로 보임 (별도 가로 방향 레이아웃 없음).
- 홀로 카드 렌더링도 세로 방향 기준. 가로 방향 지원은 본 이식 범위 밖.

### 8.3 다크/라이트 모드
- **라이트 모드만 지원**: `AppTheme.light` 고정. 다크 모드 이식 금지 (사전 합의).
- 홀로 카드 베이스도 라이트 톤(`AppColors.backgroundElevated`).
- 시스템 다크 모드 설정 시에도 앱은 라이트 유지 (`AppTheme.light`만 제공).

### 8.4 플랫폼 대응 (터치 vs 마우스)

| 입력 | 처리 | 비고 |
|------|------|------|
| 마우스 호버 (데스크톱/macOS) | `MouseRegion` `onHover`/`onEnter`/`onExit` → 포인터/페이드 갱신 | sample 원본 동작 |
| 터치 드래그 (iOS/Android) | `GestureDetector.onPanUpdate` → 포인터 갱신, `onPanEnd` → spring-back | **신규 추가** (sample은 데스크톱 전용이라 터치 대응 없었음) |
| 터치 탭 | 포인터를 중앙(0.5, 0.5)으로 + 페이드 1 → 잠깐 홀로 효과 표시 후 spring-back | 탭만으로도 홀로 효과를 볼 수 있게 하는 보조 동작 (검토) |

> **핵심**: sample은 `MouseRegion` 호버 전용이라 모바일에서 홀로 효과가 정적으로 보임. 터치 드래그 트리거 추가가 본 이식의 필수 신규 작업.

### 8.5 SafeArea
- `HoloCardRender` 자체는 `SafeArea` 처리 안 함 (부모 `DiscoveryHeroCard`/`DiscoveryCardDetailScreen`이 이미 `SafeArea`로 감싸고 있음).

---

## 9. sample-project에서 참고할 UI 요소

> **참고만** 하고 main 디자인 시스템에 맞춰 재구성. 그대로 복사 아님.

### 9.1 렌더링 기법 (참고 → 재구성)

| 요소 | sample | main 재구성 |
|------|--------|-------------|
| 홀로 포일 셰이더 | `holo.frag` GLSL | 그대로 복사 (셰이더는 디자인 시스템과 무관) |
| 셰이더 uniform 세팅 | `_ShaderPainter` | 그대로, 단 `Rarity`→`HoloGrade` 매핑 |
| 글레어 RadialGradient | `_GlarePainter` (다크 기준 alpha) | alpha 값을 라이트 톤에 맞춰 재조정 |
| 3D 틸트 Matrix4 | `Matrix4.identity()..setEntry(3,2,0.0015)..rotateX..rotateY` | 그대로 |
| 포인터 수식 | `PointerMath` | 그대로 |
| 흔들림 방지 | `ui.Image` 캐시 + `_PhotoPainter.shouldRepaint=false` | 그대로, 사진 소스만 asset으로 변경 |
| spring-back | `AnimationController` 600ms + `Curves.easeOutCubic` | 그대로 |
| 카드 비율 2.5:3.5 | `FramePainter.aspectRatio` | 유지 (트레이딩 카드 표준) |
| 사진 패딩/반경 비율 | `h * 0.02` / `h * 0.025` | 유지하되 `AppRadius`와 조화 검토 |
| testHolo 멀티레이어 합성 | `_TestHoloPainter` (8장 PNG) | 코드 보존, 표시 안 함 |

### 9.2 인터랙션 패턴 (참고)

| 요소 | sample | main 재구성 |
|------|--------|-------------|
| 포인터 추적 | `MouseRegion` + `findRenderObject`로 카드 rect 계산 | `MouseRegion` + 터치 드래그 추가 |
| 페이드 in/out | `Tween<double>(begin: _fade, end: 1.0/0.0)` + `CurvedAnimation` | 그대로 |
| 터치 대응 | (없음) | `GestureDetector.onPanUpdate` 신규 추가 |

### 9.3 레이어 구조 (참고)

sample의 카드 Stack 구조:
```
Stack
 ├ [0] 카드 베이스 (Container color)
 ├ [1] 사진 (Padding + ClipRRect + CustomPaint _PhotoPainter)
 ├ [2] 홀로 포일 (ShineLayer)
 ├ [3] 글레어 (GlareLayer)
 └ [4] 프레임 (FramePainter)  ← main에서 제거
```

main 재구성 구조:
```
DiscoveryHeroCard (기존 컨테이너 유지)
 ├ HoloBadge (좌상단, 기존)
 └ HoloCardRender (이미지 영역 교체)
     └ Stack
         ├ [0] 카드 베이스 (AppColors.backgroundElevated)
         ├ [1] 사진 (Ginkgobilobac.webp, CustomPaint)
         ├ [2] 홀로 포일 (HoloShineLayer)  ← HoloGrade.hasHolo일 때만
         └ [3] 글레어 (HoloGlareLayer)
     (프레임 제거 — DiscoveryHeroCard 컨테이너가 역할)
```

---

## 10. sample-project에서 버릴 UI 요소

| 요소 | 파일 | 사유 |
|------|------|------|
| 다크 테마 (`Brightness.dark`, seedColor `0xFFA855F7`) | `main.dart` | main 라이트 테마 유지 |
| 카드 베이스 `0xFF1A1A1A` (거의 검정) | `holo_card.dart` | main `AppColors.backgroundElevated`(흰색)로 교체 |
| 그림자 `Colors.black alpha 0.5, blurRadius 20, offset (0,10)` | `holo_card.dart` | main `AppShadows.card`/`soft`로 교체 |
| `FramePainter` (오리지널 트레이딩 카드 프레임) | `painters/frame_painter.dart` | main의 `DiscoveryHeroCard` 컨테이너가 프레임 역할. 폰트 Roboto 하드코딩. main 팔레트에 부합하지 않음 |
| `CardGrid` (카드 갤러리 그리드) | `widgets/card_grid.dart` | 다크 테마 하드코딩. main의 `DiscoveryCardScreen` 그리드 유지 |
| `CardEditorDialog` (카드 생성/편집 다이얼로그) | `widgets/card_editor_dialog.dart` | 사용자 수동 편집 기능 제외. 하드코딩 색상(`0xFF1F1F1F`, `0xFF2A2A2A`). AI 분석 파이프라인이 카드 생성 담당 |
| `HomePage` (스튜디오 화면) | `main.dart` | 별도 스튜디오 화면 안 만듦 |
| About 다이얼로그 텍스트 | `main.dart` `_showAbout` | sample 전용 설명 (포켓몬 카드 참고) |
| `Rarity` 6종 enum + 라벨(BSC/REV/REG/ILL/HYP/TST) | `card_data.dart` | main `HoloGrade` 3종으로 대체 |
| `RarityX.frameColor` (래리티별 프레임 색상) | `card_data.dart` | main `AppColors`/`LqColors` 팔레트 사용 |
| `holoImagePath` 사용자 홀로 이미지 선택 UI | `card_editor_dialog.dart` `_HoloImagePicker` | 레이어 선택 기능 제거 |
| `_ImageHoloPainter` (사용자 홀로 이미지 렌더링) | `shine_layer.dart` | 레이어 선택 기능 제거 |
| 사진 선택 버튼(갤러리/카메라) UI | `card_editor_dialog.dart` `_PhotoPicker`/`_PhotoButton` | 사용자 사진 선택 기능 제외. 사진은 고정 asset |
| 래리티 선택 UI | `card_editor_dialog.dart` `_RarityPicker` | 사용자 수동 선택 기능 제외. 등급은 `CardDetailData.currentGrade`에서 결정 |
| FAB "카드 만들기" | `main.dart` | 별도 스튜디오 화면 없음 |
| 카드 삭제 롱프레스 | `holo_card.dart` `onLongPress` | 표시 전용 카드, 삭제 인터랙션 없음 |
| 카드 탭 편집 | `holo_card.dart` `onTap` | 표시 전용 카드, 편집 인터랙션 없음 |
| `vector_math` 패키지 | `pubspec.yaml` | sample에 선언만 있고 미사용 |
| 다크 배경의 빈 상태 UI (`Colors.white24`/`white38`/`white54`) | `card_grid.dart` `_EmptyState` | main 라이트 톤 + `AppColors.textTertiary` |

---

## 11. 단계별 구현 순서

> 각 단계는 독립적으로 검증 가능하도록 구성. 코드 수정은 본 계획서 확정 후 별도 진행.

### Phase 0 — 사전 준비 (에셋 + pubspec)
**목표**: 홀로 렌더링 인프라를 main-project에 추가만 해두고, 아직 화면에 연결하지 않음.

1. `shaders/holo.frag` 파일 복사 (프로젝트 루트)
2. `assets/holo_test/` 폴더 생성 + PNG 8장 복사
3. `pubspec.yaml` 수정:
   - `flutter:` 섹션에 `shaders: - shaders/holo.frag` 추가
   - `assets:`에 `assets/holo_test/` 추가
   - `assets/images/sample_card_image/`가 이미 존재(`Ginkgobilobac.webp`)하는지 확인 → 없으면 에셋 등록 추가
4. `flutter pub get` 실행
5. `flutter build` (또는 `flutter run`)으로 셰이더 컴파일 확인 — **이 단계에서는 화면 변화 없음**
6. **검증**: 빌드 성공, 셰이더 컴파일 에러 없음

**의존성 추가**: 없음 (이미지 선택/저장 기능 제외이므로 image_picker/croppy/path_provider/shared_preferences 추가 안 함)

### Phase 1 — 수학 유틸 + 매핑 로직 (비즈니스 로직)
**목표**: 홀로 효과의 "결정 규칙"을 먼저 구현. UI 없이 순수 로직.

1. `lib/features/card_detail/utils/pointer_math.dart` 신규 — sample `PointerMath` 그대로 복사
2. `lib/features/card_detail/utils/holo_grade_effect.dart` 신규 — `HoloGrade → {hasHolo, shaderRarityIndex, intensity, glareStrength}` 매핑:
   - `normal`: `hasHolo=false`
   - `holo`: `hasHolo=true`, `shaderRarityIndex=1`(regularHolo 가정, 임의)
   - `seasonalHolo`: `hasHolo=true`, `shaderRarityIndex=4`(hyperRare 가정, 임의)
3. 도메인 모델(`card_detail_data.dart`의 `HoloGrade`)은 **수정 없음**
4. **검증**: 매핑 로직 단위 테스트(선택) — `normal`은 `hasHolo=false`, `holo`/`seasonalHolo`는 `hasHolo=true`

### Phase 2 — 홀로 렌더링 레이어 위젯
**목표**: 홀로 포일 + 글레어 레이어 위젯을 독립적으로 구현. 아직 카드에 연결 안 함.

1. `lib/features/card_detail/widgets/layers/holo_glare_layer.dart` 신규:
   - sample `GlareLayer` 재포장 → `HoloGlareLayer`
   - `_GlarePainter` — 라이트 톤 alpha 재조정 (흰 배경에서 글레어가 보이도록)
   - `Opacity` 위젯 금지 주석 유지
2. `lib/features/card_detail/widgets/layers/holo_shine_layer.dart` 신규:
   - sample `ShineLayer` 재포장 → `HoloShineLayer`
   - `Rarity` → `HoloGrade` 시그니처 변경
   - `_rarityIndex` 스위치 재작성 (Phase 1 매핑 사용)
   - 이미지 홀로 모드 전체 제거
   - testHolo 모드 코드 보존, 분기 상수 `false`로 닫기
   - `_ShaderPainter` 유지
3. **검증**: 위젯 트리에 임시로 `HoloShineLayer`/`HoloGlareLayer`를 띄워 렌더링 확인 (임시 Scaffold, 추후 제거). 셰이더 로드 성공, 글레어가 라이트 배경에서 보이는지 확인.

### Phase 3 — 홀로 카드 렌더 위젯
**목표**: 3D 틸트 + 레이어 합성 + 흔들림 방지를 갖춘 메인 렌더 위젯 구현. 아직 히어로 카드에 연결 안 함.

1. `lib/features/card_detail/widgets/holo_card_render.dart` 신규:
   - sample `HoloCard` 재포장 → `HoloCardRender`
   - `CardData` 의존 제거 → `HoloGrade grade`, `String imageAssetPath` 입력
   - 사진 로드: `rootBundle.load('assets/images/sample_card_image/Ginkgobilobac.webp')` + `instantiateImageCodec`
   - 다크 베이스 → `AppColors.backgroundElevated`
   - 그림자 → `AppShadows.card`
   - `FramePainter` 합성 제거
   - `onTap`/`onLongPress` 제거
   - **터치 드래그 대응 추가**: `GestureDetector.onPanUpdate` → `_pointerX/_pointerY` 갱신, `onPanEnd` → spring-back
   - `MouseRegion` 유지 (데스크톱)
   - `ValueNotifier` + `AnimationController` 패턴 유지
   - `_PhotoPainter.shouldRepaint=false` 흔들림 방지 유지
2. **검증**: 임시 Scaffold에 `HoloCardRender(grade: HoloGrade.holo, imageAssetPath: '...')` 띄워 확인:
   - 사진 로드 성공
   - 터치 드래그 시 3D 틸트 + 홀로/글레어 반응
   - 드래그 종료 시 spring-back
   - 데스크톱에서 마우스 호버 동작
   - `normal` 등급은 글레어만, `holo`/`seasonalHolo`는 홀로+글레어
   - 라이트 배경에서 색상/강도 튜닝

### Phase 4 — 히어로 카드 통합
**목표**: 기존 `DiscoveryHeroCard`의 placeholder를 `HoloCardRender`로 교체. 도메인 모델 수정 없음.

1. `lib/features/card_detail/widgets/discovery_hero_card.dart` 수정:
   - `_buildHeroImage`의 `_GinkgoLeafPainter` placeholder 제거
   - `HoloCardRender(grade: data.currentGrade, imageAssetPath: 'assets/images/sample_card_image/Ginkgobilobac.webp')`로 교체
   - 카드 컨테이너(보더/배경/그림자/`AppRadius.xl`)는 그대로 유지
   - `HoloBadge`(좌상단)는 그대로 유지
   - 이름/학명/카테고리칩/설명 영역은 그대로 유지
   - 이미지 영역 높이(현재 220)를 `HoloCardRender`의 2.5:3.5 비율에 맞춰 조정 검토
2. `discovery_card_detail_screen.dart`는 **수정 없음** (이미 `DiscoveryHeroCard`를 사용 중)
3. 도메인 모델(`CardDetailData`)은 **수정 없음**
4. **검증**:
   - 카드 상세 화면(`/card-detail`) 진입 시 히어로 카드에 홀로 효과 표시
   - `HoloGrade.holo`(fixture `sampleCardDetail`)인 경우 홀로 효과 정상
   - `HoloBadge` "Holo" 라벨 정상 표시
   - 터치 드래그로 홀로/틸트 반응
   - 라이트 배경에서 전체 조화 확인
   - `flutter analyze` 통과

### Phase 5 — 디자인 튜닝 + 최종 검증
**목표**: 라이트 톤에서 홀로/글레어 색상·강도를 다듬고 최종 확인.

1. `holo`/`seasonalHolo` 셰이더 인덱스/`intensity` 튜닝 (디자인 검토)
2. 글레어 alpha/색상 튜닝 (라이트 배경에서 가시성)
3. 카드 크기/높이 레이아웃 조정 (화면 크기 대응)
4. testHolo 모드가 표시되지 않는지 확인 (분기 닫힘)
5. `flutter analyze` 통과
6. `flutter build ios`/`android`/`macos` 셰이더 컴파일 확인
7. 실제 기기에서 터치 드래그 + 홀로/글레어/틸트 동작 최종 확인

### Phase 6 — 백엔드 연동 (별도 작업, 본 이식과 도)
> 본 이식(Phase 0~5) 완료 후 별도 진행. `docs/sample-feature-requirements.md`의 API 목록 참조.

1. HTTP 클라이언트 + 인증 인프라
2. `DiscoveryRepository` Mock → 실제 API 구현체 교체
3. `sampleCardDetail` fixture → `GET /cards/{id}` 연동
4. `_onToggleFavorite` → `POST /cards/{id}/favorite` 연동
5. AI 종 식별 파이프라인(`analysis_status_screen` 실구현)
6. 카메라/지도/위치 실구현

---

## 부록: 파일 생성/수정 요약

### 신규 파일 (6개)
| 파일 | 단계 |
|------|------|
| `shaders/holo.frag` | Phase 0 |
| `assets/holo_test/*.png` (8장) | Phase 0 |
| `lib/features/card_detail/utils/pointer_math.dart` | Phase 1 |
| `lib/features/card_detail/utils/holo_grade_effect.dart` | Phase 1 |
| `lib/features/card_detail/widgets/layers/holo_glare_layer.dart` | Phase 2 |
| `lib/features/card_detail/widgets/layers/holo_shine_layer.dart` | Phase 2 |
| `lib/features/card_detail/widgets/holo_card_render.dart` | Phase 3 |

### 수정 파일 (2개)
| 파일 | 단계 | 수정 내용 |
|------|------|----------|
| `pubspec.yaml` | Phase 0 | `shaders:`, `assets:` 섹션 추가 |
| `lib/features/card_detail/widgets/discovery_hero_card.dart` | Phase 4 | `_buildHeroImage` placeholder → `HoloCardRender` 교체 |

### 수정 없는 파일 (도메인/화면 보호)
| 파일 | 비고 |
|------|------|
| `lib/features/card_detail/models/card_detail_data.dart` | `HoloGrade` enum 유지, 수정 금지 |
| `lib/screens/discovery_card_detail_screen.dart` | 이미 `DiscoveryHeroCard` 사용 중, 수정 불필요 |
| `lib/features/card_detail/widgets/holo_badge.dart` | 그대로 유지 |
| `lib/features/card_detail/widgets/holo_progress_card.dart` | 그대로 유지 (홀로 효과와 무관) |

### 제외 파일 (sample에서 가져오지 않음)
- `CardData`, `Rarity`, `CardStore`, `PhotoService`, `CardGrid`, `CardEditorDialog`, `FramePainter`, `HomePage`, 다크 테마, 레이어 선택 기능 일체

---

*본 문서는 프론트엔드 이식 계획만 작성하며, 코드 수정은 수반하지 않습니다. main-project의 디자인 시스템과 화면 구조를 우선하고, sample-project의 UI는 참고만 합니다.*
