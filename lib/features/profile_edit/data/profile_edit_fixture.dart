import '../models/profile_edit_data.dart';

/// UI 확인용 개인정보 수정 fixture 데이터.
///
/// 이 파일은 개발/테스트 목적으로만 사용하며, 실제 API 연동 시 제거한다.
abstract final class ProfileEditFixture {
  static const ProfileEditData sample = ProfileEditData(
    nickname: '탐험가',
    description: '자연을 사랑하는 작은 탐험가예요!',
    birthDate: '2015.05.20',
    genderLabel: '남자',
    languageLabel: '한국어',
    email: 'littlequest@example.com',
    googleConnected: true,
    appleConnected: true,
  );
}
