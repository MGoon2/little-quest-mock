/// 개인 정보 수정 데이터.
class ProfileEditData {
  final String nickname;
  final String description;
  final String birthDate;
  final String genderLabel;
  final String languageLabel;
  final String email;
  final bool googleConnected;
  final bool appleConnected;
  final String? profileImageAssetPath;

  const ProfileEditData({
    required this.nickname,
    required this.description,
    required this.birthDate,
    required this.genderLabel,
    required this.languageLabel,
    required this.email,
    required this.googleConnected,
    required this.appleConnected,
    this.profileImageAssetPath,
  });
}
