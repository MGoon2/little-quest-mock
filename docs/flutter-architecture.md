# Flutter Architecture

## Purpose

This document defines the target architecture for gradually normalizing the Little Quest Flutter project. It complements `docs/flutter-structure-audit.md` and `AGENTS.md`.

The goal is maintainability without changing current UI, business behavior, routing behavior, or state-management style.

## Target Structure

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
  features/
    {feature_name}/
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
  shared/
    models/
    services/
    extensions/
```

## Layer Responsibilities

### `main.dart`

- Process entrypoint only.
- Calls `runApp`.
- Should not own route table, theme construction, feature wiring, or environment parsing once app layer migration is complete.

### `app/`

Application composition layer.

- `app/app.dart`: top-level `LittleQuestApp` widget.
- `app/router/`: route names, route table, `onGenerateRoute`, and app-level navigation wiring.
- `app/theme/`: theme and design token files used across the app.
- `app/env/`: environment/config entrypoints if and when they exist.

### `core/`

Reusable app infrastructure with no feature ownership.

- `constants/`: app-wide constants.
- `error/`: app-wide error types, failures, exception mapping.
- `network/`: generic HTTP/client infrastructure only.
- `storage/`: generic persistence adapters only.
- `utils/`: narrow utility functions with concrete names and app-wide reuse.
- `widgets/`: truly global widgets that have no feature/domain dependency.

### `features/{feature_name}/`

Feature-owned implementation.

- `data/`: external data access, fixtures, DTOs, repository implementations.
- `domain/`: stable business entities, repository contracts, usecases when the feature has real domain logic.
- `presentation/`: pages, widgets, and providers/state objects used by the UI.

Do not create empty domain/usecase layers for simple UI-only features. Add them when behavior justifies the layer.

### `shared/`

Cross-feature application concepts that are not infrastructure.

- `models/`: models reused by multiple features.
- `services/`: app services that are not low-level infrastructure.
- `extensions/`: shared Dart extensions.

## Dependency Direction

Allowed:

- `main.dart` -> `app`
- `app` -> `features`, `core`, `shared`
- `features/*/presentation` -> same feature `domain`, same feature `data` for temporary fixture wiring, `core`, `shared`
- `features/*/data` -> same feature `domain`, `core`, `shared`
- `features/*/domain` -> `shared` only when the concept is genuinely cross-feature
- `core` -> Flutter/Dart/platform packages only
- `shared` -> Flutter/Dart/platform packages and stable shared concepts

Avoid:

- One feature importing another feature's internal widgets/models directly.
- `core` importing any feature.
- `shared` importing any feature.
- Feature presentation importing another feature's data layer.

## Routing

- Existing route names must remain stable unless a dedicated routing change is requested.
- Route definitions belong in `app/router`.
- Page classes belong in each feature's `presentation/pages` when that feature has been migrated.
- Legacy route behavior must be documented before removal.
- `/card-detail` and `/card-detail-legacy` must not be merged or removed until the intended behavior is confirmed.

## Theme

- Theme files move under `app/theme`.
- Do not merge `AppColors` and `LqColors` in the same step as file movement.
- Treat color-token changes as visual changes requiring visual or manual QA.
- Theme migration should first be path-only and behavior-preserving.

## Feature Migration Policy

Migrate one feature at a time.

Recommended early order:

1. `quest_detail` - 1차 이동 완료
2. `my_page` - 1차 이동 완료
3. `profile_edit` - 1차 이동 완료
4. `account_verification` - 1차 이동 완료
5. `signup` - 1차 추가 완료
6. `card_detail` - `/card-detail`과 `/card-detail-legacy` 의도 확인 후 진행
7. `discovery`
8. `home`
9. `camera_flow`
10. `auth` / `onboarding`
11. `plan`
12. `map`

For each feature:

1. Move page/screen into `features/{feature}/presentation/pages`.
2. Move feature widgets into `features/{feature}/presentation/widgets`.
3. Move feature data/fixtures into `features/{feature}/data`.
4. Move stable business models into `domain/entities` only when they are not UI DTOs.
5. Update route imports.
6. Run `flutter analyze`.
7. Run targeted tests or `flutter test` when available.

## Deletion Policy

- Do not delete files as part of structure exploration.
- If a file appears obsolete, record it in `docs/delete-candidates.md`.
- Remove only in a dedicated cleanup step with verification.

## Verification Policy

Minimum verification after each structural step:

```sh
flutter analyze
```

When tests are available:

```sh
flutter test
```

Before final completion:

```sh
flutter pub get
flutter analyze
flutter test
```

If a command fails because of local environment state rather than code, record it in `docs/refactor-remaining-issues.md` with the exact failure.
