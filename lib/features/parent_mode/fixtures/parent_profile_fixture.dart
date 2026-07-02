import 'package:little_quest/features/parent_mode/models/parent_child_profile.dart';
import 'package:little_quest/features/parent_mode/models/parent_guardian_profile.dart';
import 'package:little_quest/features/parent_mode/models/parent_login_history_item.dart';
import 'package:little_quest/features/parent_mode/models/parent_login_method.dart';

final parentChildProfiles = [
  ParentChildProfile(
    id: 'child-1',
    name: '이든이',
    nickname: '탐험가 이든',
    birthDate: DateTime(2017, 5, 20),
    age: 7,
    genderLabel: '남자',
    explorerLevel: 12,
    gradeLabel: '초등학교 1학년',
    interests: const ['식물', '곤충', '새'],
    preferredActivityTime: '오후 시간',
    memo: '특이사항이 없어요.',
    isSelected: true,
  ),
  ParentChildProfile(
    id: 'child-2',
    name: '서윤이',
    nickname: '탐험가 서윤',
    birthDate: DateTime(2019, 9, 12),
    age: 5,
    genderLabel: '여자',
    explorerLevel: 8,
    gradeLabel: '유치원',
    interests: const ['꽃', '나비'],
    preferredActivityTime: '오전 시간',
    memo: '곤충을 좋아해요.',
    isSelected: false,
  ),
  ParentChildProfile(
    id: 'child-3',
    name: '민준이',
    nickname: '탐험가 민준',
    birthDate: DateTime(2014, 3, 3),
    age: 10,
    genderLabel: '남자',
    explorerLevel: 18,
    gradeLabel: '초등학교 3학년',
    interests: const ['새', '나무', '건물'],
    preferredActivityTime: '주말 오후',
    memo: '사진 찍기를 좋아해요.',
    isSelected: false,
  ),
  ParentChildProfile(
    id: 'child-4',
    name: '지우',
    nickname: '탐험가 지우',
    birthDate: DateTime(2016, 11, 28),
    age: 8,
    genderLabel: '여자',
    explorerLevel: 14,
    gradeLabel: '초등학교 2학년',
    interests: const ['식물', '도감'],
    preferredActivityTime: '오후 시간',
    memo: '메모 작성을 좋아해요.',
    isSelected: false,
  ),
];

const parentGuardianProfile = ParentGuardianProfile(
  name: '김보호',
  email: 'parent@example.com',
  phoneNumber: '010-1234-5678',
  relationLabel: '엄마',
  eventNotificationEnabled: true,
  emailNotificationEnabled: true,
  smsNotificationEnabled: false,
);

const parentLoginMethods = [
  ParentLoginMethod(provider: 'google', label: 'Google 계정', connected: true),
  ParentLoginMethod(provider: 'apple', label: 'Apple 계정', connected: false),
];

final parentLoginHistoryItems = [
  ParentLoginHistoryItem(
    loggedInAt: DateTime(2024, 5, 20, 15, 24),
    deviceName: 'iPhone',
  ),
  ParentLoginHistoryItem(
    loggedInAt: DateTime(2024, 5, 19, 10, 15),
    deviceName: 'iPad',
  ),
];

ParentChildProfile findParentChildProfile(String childId) {
  return parentChildProfiles.firstWhere(
    (profile) => profile.id == childId,
    orElse: () => parentChildProfiles.first,
  );
}
