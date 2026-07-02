class ParentChildProfile {
  final String id;
  final String name;
  final String nickname;
  final DateTime birthDate;
  final int age;
  final String genderLabel;
  final int explorerLevel;
  final String gradeLabel;
  final List<String> interests;
  final String preferredActivityTime;
  final String memo;
  final bool isSelected;
  final String? avatarAssetPath;

  const ParentChildProfile({
    required this.id,
    required this.name,
    required this.nickname,
    required this.birthDate,
    required this.age,
    required this.genderLabel,
    required this.explorerLevel,
    required this.gradeLabel,
    required this.interests,
    required this.preferredActivityTime,
    required this.memo,
    required this.isSelected,
    this.avatarAssetPath,
  });
}
