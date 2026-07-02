class ParentGuardianProfile {
  final String name;
  final String email;
  final String phoneNumber;
  final String relationLabel;
  final bool eventNotificationEnabled;
  final bool emailNotificationEnabled;
  final bool smsNotificationEnabled;

  const ParentGuardianProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.relationLabel,
    required this.eventNotificationEnabled,
    required this.emailNotificationEnabled,
    required this.smsNotificationEnabled,
  });
}
