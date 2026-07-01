# Refactor Remaining Issues

This document records verification gaps, deferred decisions, and issues that should not be hidden during the gradual structure refactor.

## Current Verification Notes

- `flutter analyze` passed before structural code movement.
- After app/router/theme migration, `flutter analyze` passed.
- After app/router/theme migration, sequential `flutter test` passed.
- After moving shared UI widgets into `core/widgets`, `flutter analyze` passed.
- After moving `quest_detail` into `data/*` and `presentation/*`, `flutter analyze` passed and sequential `flutter test` passed.
- After moving `my_page` into `data/*` and `presentation/*`, `flutter analyze` passed and sequential `flutter test` passed.
- After moving `profile_edit` into `data/*` and `presentation/*`, `flutter analyze` passed and sequential `flutter test` passed.
- After moving `account_verification` into `data/*` and `presentation/*`, `flutter analyze` passed and sequential `flutter test` passed.
- After adding `signup` as `data/models` and `presentation/*`, `flutter analyze` passed, `flutter test` passed, and Flutter web screenshot QA covered `/signup` and `/signup/email`.
- An earlier parallel `flutter test` attempt failed while another Flutter command held the startup lock and reported an iOS ephemeral file deletion issue. This did not reproduce when `flutter test` was run sequentially.

## Deferred Decisions

- Confirm whether `/card-detail-legacy` is still required before removing or merging it with `/card-detail`.
- Decide whether `AppColors` and `LqColors` represent intentional separate palettes or an unfinished theme split before merging them.
- Resolve the `DiscoveryCard` model/widget name collision before migrating Discovery files.
- Continue feature migration with `card_detail`; confirm `/card-detail` and `/card-detail-legacy` ownership before moving screens.
- Some older planning/sample docs still reference pre-refactor paths such as `components/primary_button.dart`, `screens/quest_detail_screen.dart`, and `features/quest_detail/widgets/*`. Treat current code as authoritative and update those docs only when they become active planning inputs.
