/// 부모 모드에서 보여주는 아이 요약 정보.
class ParentChildSummary {
  final String childName;
  final int age;
  final int explorerLevel;
  final String? avatarAssetPath;

  const ParentChildSummary({
    required this.childName,
    required this.age,
    required this.explorerLevel,
    this.avatarAssetPath,
  });
}
