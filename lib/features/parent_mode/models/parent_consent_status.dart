/// 부모 모드의 동의 상태 표시 데이터.
class ParentConsentStatus {
  final String title;
  final String description;
  final bool isRequired;
  final bool agreed;

  const ParentConsentStatus({
    required this.title,
    required this.description,
    required this.isRequired,
    required this.agreed,
  });
}
