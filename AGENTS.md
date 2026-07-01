# AGENTS.md

이 파일은 Little Quest Flutter 프로젝트에서 에이전트가 점진적 리팩토링을 수행할 때 따라야 할 작업 계약이다. 현재 구조 감사의 기준 문서는 `docs/flutter-structure-audit.md`이다.

## 기본 원칙

- 큰 폭의 구조 변경을 한 번에 하지 않는다.
- 한 번의 작업은 하나의 feature, 하나의 폴더 경계, 또는 하나의 명명 충돌만 다룬다.
- 동작 변경이 목적이 아닌 리팩토링에서는 UI, route, navigation, fixture 데이터의 관찰 가능한 결과를 유지한다.
- 파일 이동 전에는 import 의존성, route 진입점, 테스트 보호 범위를 먼저 확인한다.
- 실패한 테스트를 삭제하거나 약화하지 않는다.
- 사용자 변경사항을 되돌리지 않는다.
- 새 dependency는 명시 요청이 없으면 추가하지 않는다.
- 리팩토링 중 코드 스타일 변경, 포맷팅, 기능 변경을 섞지 않는다.

## 현재 구조 판단 기준

현재 프로젝트는 feature-first 구조로 이동 중인 과도기 상태다.

- 이미 feature 경계가 비교적 명확한 영역:
  - `lib/features/quest_detail`
  - `lib/features/my_page`
  - `lib/features/profile_edit`
  - `lib/features/account_verification`
  - `lib/features/signup`
  - `lib/features/card_detail`
- 아직 전역 구조에 남아 있는 영역:
  - `lib/screens`
  - `lib/components`
  - `lib/models`
  - `lib/data`

리팩토링할 때는 `docs/flutter-structure-audit.md`의 우선순위와 위험 파일 목록을 먼저 확인한다.

## 목표 구조 방향

장기 목표는 다음 경계를 향해 점진적으로 이동하는 것이다.

```text
lib/
  main.dart
  app/
    app.dart
    router/
    theme/
    env/
  core/
    constants/
    error/
    network/
    storage/
    utils/
    widgets/
  shared/
    models/
    services/
    extensions/
  features/
    <feature_name>/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
        widgets/
        providers/
```

이 구조는 목표 방향일 뿐이다. 기존 코드를 억지로 맞추기 위해 한 번에 이동하지 않는다.

## feature 경계 규칙

feature 내부에 두는 코드:

- 특정 화면이나 특정 사용자 흐름에서만 쓰이는 widget
- 해당 feature 화면을 조립하는 screen
- 해당 feature 전용 fixture
- 해당 feature 전용 view data, DTO, UI model
- 해당 feature 전용 repository 또는 data source

`shared` 후보:

- 여러 feature에서 실제로 재사용되는 UI
- 도메인 모델에 직접 묶이지 않은 버튼, scaffold, section header 같은 범용 widget
- 재사용 근거가 2개 이상의 feature에서 확인된 코드

`core` 후보:

- 앱 라우팅
- 앱 theme
- design token
- 전역 설정
- feature와 무관한 기반 코드

단, 최종 구조에서는 라우팅과 theme는 `app/router`, `app/theme`에 둔다. `core`는 network, storage, error, constants, utils, 전역 widget 같은 기반 코드만 맡는다.

주의:

- 이름만 일반적으로 보인다고 `shared`로 옮기지 않는다.
- 특정 도메인 모델을 import하는 widget은 먼저 feature 전용으로 본다.
- `features/*/widgets/*AppBar.dart`, `features/*/widgets/*SectionCard.dart`는 기본적으로 feature 전용이다.

## 점진적 리팩토링 순서

### 0단계: 기준선 확보

리팩토링 전에 먼저 확인한다.

- `flutter analyze`
- `flutter test`
- 현재 route smoke test 보호 범위
- 이동 대상 파일의 import 사용자
- 이동 대상 화면의 navigation 진입점

테스트가 기존에 실패한다면 실패 내용을 기록하고, 리팩토링과 무관한 실패인지 확인한다.

### 1단계: 안전한 feature wrapper 정리

우선순위:

1. `quest_detail` - 1차 이동 완료
2. `my_page` - 1차 이동 완료
3. `profile_edit` - 1차 이동 완료
4. `account_verification` - 1차 이동 완료
5. `signup` - 1차 추가 완료

이 영역들은 feature 경계가 뚜렷해서 먼저 `data/*`와 `presentation/*` 기준으로 1차 정리했다. 같은 방식의 다음 후보는 `card_detail`이지만 legacy route 의도 확인이 먼저 필요하다.

규칙:

- 한 PR 또는 한 작업에서는 feature 하나만 이동한다.
- screen 파일 이동 후 기존 route 이름을 유지한다.
- `main.dart` route table 변경은 해당 feature 이동에 필요한 최소 범위로 제한한다.
- 이동 후 `flutter analyze`와 관련 widget test 또는 smoke test를 실행한다.

### 2단계: Discovery 도메인 정리

대상 후보:

- `lib/screens/discovery_card_screen.dart`
- `lib/data/discovery_repository.dart`
- `lib/data/discovery_fixtures.dart`
- `lib/models/discovery_card.dart`
- `lib/models/discovery_category.dart`
- `lib/components/discovery_mini_card.dart`

필수 선행 작업:

- `DiscoveryCard` 모델과 `DiscoveryCard` 위젯 이름 충돌을 해결하거나 alias 규칙을 정한다.
- `/card-detail`과 `/card-detail-legacy`의 의도를 확인한다.
- Discovery 목록과 Card Detail의 소유권을 분리한다.

금지:

- Discovery 목록 정리와 Card Detail legacy 제거를 한 작업에 섞지 않는다.
- 모델 이름 변경과 파일 이동을 한 번에 대량으로 수행하지 않는다.

### 3단계: Home 분리

대상 후보:

- `lib/screens/home_screen.dart`
- `lib/core/widgets/app_scaffold.dart`
- `lib/core/widgets/bottom_navigation.dart`
- `lib/core/widgets/side_menu.dart`
- `lib/components/discovery_card.dart`
- `lib/components/quest_card.dart`
- `lib/core/widgets/section_header.dart`
- `lib/models/discovery_card_item.dart`
- `lib/models/quest.dart`

규칙:

- `home_screen.dart`의 fixture성 리스트, banner data, log data를 먼저 분리한다.
- navigation 동작과 route 이름을 유지한다.
- 홈 전용 card widget은 `features/home/widgets` 후보로 먼저 본다.
- `app_scaffold`, `bottom_navigation`, `side_menu`, `section_header`, `primary_button`은 실제 재사용 근거를 확인한 뒤 `shared/widgets`로 이동한다.

### 4단계: Camera/Auth/Plan/Map 후보 정리

후보:

- `camera_flow`: `camera_screen`, `photo_preview_screen`, `analysis_status_screen`, `discovery_intro_screen`
- `auth` 또는 `onboarding`: `welcome_screen`, `login_screen`
- `plan`: `plan_screen`, `plan_tier`, `plan_card`
- `map`: `map_screen`

규칙:

- 사용자 흐름 단위로 묶는다.
- route 이름을 바꾸지 않는다.
- 화면 파일 이동과 UI 수정은 분리한다.

### 5단계: theme 정리

대상:

- `lib/app/theme/app_colors.dart`
- `lib/app/theme/lq_colors.dart`
- `lib/app/theme/app_theme.dart`
- `lib/app/theme/app_text_styles.dart`
- `lib/app/theme/app_spacing.dart`
- `lib/app/theme/app_radius.dart`
- `lib/app/theme/app_shadows.dart`

규칙:

- `AppColors`와 `LqColors`를 한 번에 합치지 않는다.
- 먼저 각 token의 사용처와 의미를 문서화한다.
- 색상 변경이 있으면 visual regression 위험으로 본다.
- theme 이동은 기능 파일 이동과 별도 작업으로 수행한다.

## 고위험 파일 처리 규칙

아래 파일은 단독 작업으로 다룬다. 다른 리팩토링과 섞지 않는다.

- `lib/screens/home_screen.dart`
- `lib/screens/discovery_card_screen.dart`
- `lib/main.dart`
- `lib/models/discovery_card.dart`
- `lib/components/discovery_card.dart`
- `lib/app/theme/app_colors.dart`
- `lib/app/theme/lq_colors.dart`
- `lib/screens/camera_screen.dart`
- `lib/screens/login_screen.dart`
- `lib/core/widgets/side_menu.dart`
- `lib/screens/photo_preview_screen.dart`
- `lib/screens/plan_screen.dart`
- `lib/screens/discovery_card_detail_screen.dart`
- `lib/features/account_verification/presentation/pages/account_verification_screen_password.dart`

고위험 파일을 건드릴 때는 작업 전에 다음을 확인한다.

- 이 파일을 import하는 파일
- 이 파일이 import하는 feature/core/shared 경계
- route 이름과 Navigator 호출
- 테스트 또는 수동 smoke 확인 방법

## import 규칙

- 파일 이동 전후 import 변경만 따로 검토한다.
- 깊은 상대 import가 늘어나는 이동은 피한다.
- 대규모 이동 전에는 `package:little_quest/...` import 전환 여부를 별도 작업으로 판단한다.
- 같은 이름의 class가 있는 경우 import alias 또는 class rename을 먼저 설계한다.
- 특히 `DiscoveryCard` 모델과 위젯 충돌을 조심한다.

## 라우팅 규칙

- 기존 route name을 유지한다.
- `main.dart` 변경은 최소화한다.
- route table 분리는 별도 작업으로 수행한다.
- `/card-detail`과 `/card-detail-legacy`는 의도 확인 전 삭제하거나 합치지 않는다.
- navigation 동작 변경은 구조 리팩토링과 분리한다.

## 테스트와 검증

리팩토링 작업마다 최소 검증:

```sh
flutter analyze
flutter test
```

화면이나 navigation을 건드린 경우:

- 앱 시작 화면이 렌더링되는지 확인한다.
- 변경한 route로 진입 가능한지 확인한다.
- 뒤로가기 또는 pushReplacement 흐름이 깨지지 않는지 확인한다.

테스트 추가 우선순위:

1. `LittleQuestApp` route smoke test
2. feature screen render test
3. navigation tap smoke test
4. fixture data 기반 widget render test

## 작업 단위와 완료 조건

한 작업의 완료 조건:

- 변경 목적이 하나로 설명된다.
- 관련 없는 포맷팅 변경이 없다.
- `flutter analyze` 결과를 확인했다.
- `flutter test` 결과를 확인했다.
- 변경한 route 또는 화면의 smoke 동작을 확인했다.
- 변경 파일과 검증 결과를 최종 보고에 남겼다.

한 작업에 포함하지 말아야 할 조합:

- 파일 이동 + UI 수정
- 파일 이동 + 모델명 변경 + route 변경
- theme token 정리 + feature 이동
- legacy route 제거 + Discovery 구조 이동
- 테스트 삭제 + 리팩토링

## 문서 업데이트 규칙

구조 판단이 바뀌면 관련 문서를 갱신한다.

- 구조 감사 근거가 바뀌면 `docs/flutter-structure-audit.md`를 업데이트한다.
- dependency 판단이 바뀌면 `docs/flutter-dependency-audit.md`를 업데이트한다.
- architecture 규칙이 바뀌면 `docs/flutter-architecture.md`를 업데이트한다.
- 삭제가 필요해 보이는 파일이나 dependency는 삭제하지 말고 `docs/delete-candidates.md`에 기록한다.
- 검증 실패나 보류 항목은 `docs/refactor-remaining-issues.md`에 기록한다.
- 실제 리팩토링 단계나 순서가 바뀌면 이 `AGENTS.md`를 업데이트한다.
- 새 feature 경계가 확정되면 해당 feature의 책임과 public entrypoint를 문서화한다.

## 에이전트 응답 규칙

리팩토링 작업을 수행한 에이전트는 최종 보고에 다음을 포함한다.

- 변경한 파일
- 이동한 파일
- 의도적으로 이동하지 않은 파일
- 실행한 검증 명령과 결과
- 남은 위험
- 다음에 이어서 할 수 있는 가장 작은 작업
