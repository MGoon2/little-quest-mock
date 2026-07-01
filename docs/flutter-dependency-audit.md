# Flutter Dependency Audit

## Scope

- Source of truth: `pubspec.yaml`, `pubspec.lock`, `flutter pub deps --style=compact`, and current imports/usages under `lib/` and `test/`.
- Date of audit: current workspace state.
- This document records dependency role, usage evidence, overlap, and cleanup candidates. It does not remove packages.

## Direct Dependencies

| Package | Type | Declared version | Current use | Evidence | Assessment |
| --- | --- | --- | --- | --- | --- |
| `flutter` | runtime SDK | SDK | Required for all Flutter UI code | Imported throughout `lib/` | Keep |
| `cupertino_icons` | runtime package | `^1.0.8` in `pubspec.yaml`, resolved `1.0.9` | No current code usage found | No `CupertinoIcons` usage found in `lib/` or `test/` | Potential remove candidate, but do not remove yet |
| `url_launcher` | runtime package | `^6.3.2`, resolved `6.3.2` | Used by Home banner URL launch flow | `lib/screens/home_screen.dart` imports `package:url_launcher/url_launcher.dart` | Keep |

## Dev Dependencies

| Package | Type | Declared version | Current use | Assessment |
| --- | --- | --- | --- | --- |
| `flutter_test` | test SDK | SDK | Used by `test/widget_test.dart` | Keep |
| `flutter_lints` | lint rules | `^6.0.0`, resolved `6.0.0` | Included by `analysis_options.yaml` | Keep |

## Transitive Dependencies

The project has transitive dependencies from Flutter SDK, `flutter_test`, and `url_launcher`, including platform-specific `url_launcher_*` packages and test/lint support packages. These should not be edited directly in `pubspec.yaml`.

Notable transitive groups:

- `url_launcher_android`, `url_launcher_ios`, `url_launcher_linux`, `url_launcher_macos`, `url_launcher_web`, `url_launcher_windows`, `url_launcher_platform_interface`: required by `url_launcher`.
- `test_api`, `matcher`, `fake_async`, `leak_tracker_*`: required by `flutter_test`.
- `lints`: required by `flutter_lints`.

## Dependency Role Overlap

No competing packages are currently declared for these roles:

| Role | Current package | Overlap status |
| --- | --- | --- |
| Routing | Flutter `Navigator` / `MaterialPageRoute` | No router package such as `go_router` declared |
| State management | `StatefulWidget` / local state only | No Provider/Riverpod/BLoC package declared |
| HTTP/API client | None | No `http`, `dio`, Retrofit, GraphQL, or generated client declared |
| Storage | None | No shared preferences, secure storage, Hive, SQLite, or file storage package declared |
| Environment/config | None | No dotenv/config package declared |
| URL launching | `url_launcher` | No overlap |
| Testing | `flutter_test` | No overlap |

## Code Usage Evidence

- `lib/screens/home_screen.dart` imports `package:url_launcher/url_launcher.dart` and stores a banner URL.
- `test/widget_test.dart` imports `package:flutter_test/flutter_test.dart`.
- Signup flow implementation uses Flutter SDK widgets and existing assets only; no new runtime package was added.
- No current usage was found for:
  - `CupertinoIcons`
  - `provider`
  - `flutter_riverpod`
  - `bloc` / `flutter_bloc`
  - `go_router`
  - `http`
  - `dio`
  - `shared_preferences`
  - storage packages

## Cleanup Candidates

Do not remove packages as part of this audit. Record candidates only.

| Candidate | Reason | Risk | Suggested handling |
| --- | --- | --- | --- |
| `cupertino_icons` | Declared but no `CupertinoIcons` usage found | Low | Add to `docs/delete-candidates.md`; remove only in a dependency cleanup step after `flutter analyze` and `flutter test` pass |

## Refactoring Guidance

- Do not introduce router, state management, HTTP, storage, or environment packages merely to satisfy folder structure.
- If API code is later added, place the first implementation under the owning feature's `data/datasources` and `data/repositories` unless it is truly app-wide infrastructure.
- If shared network infrastructure becomes necessary, place only generic transport/client code under `core/network`; feature-specific DTOs and repositories stay in feature folders.
- Keep `url_launcher` localized to the feature/page that uses external link behavior until a second caller appears.
