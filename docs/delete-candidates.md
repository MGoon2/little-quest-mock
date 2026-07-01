# Delete Candidates

This document records files or dependencies that may be removable later. Do not delete items merely because they appear here; verify in a dedicated cleanup step first.

## Dependency Candidates

| Candidate | Reason | Required verification before removal |
| --- | --- | --- |
| `cupertino_icons` | Declared in `pubspec.yaml`, but no `CupertinoIcons` usage was found in current `lib/` or `test/` code. | Remove in a dedicated dependency cleanup step, then run `flutter pub get`, `flutter analyze`, and `flutter test`. |

## File Candidates

No file deletion candidates identified yet.
