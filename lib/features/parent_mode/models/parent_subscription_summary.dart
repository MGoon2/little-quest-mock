/// 부모 모드 구독 상태 요약.
class ParentSubscriptionSummary {
  final String planName;
  final bool active;
  final String billingCycleLabel;
  final DateTime? nextBillingDate;

  const ParentSubscriptionSummary({
    required this.planName,
    required this.active,
    required this.billingCycleLabel,
    this.nextBillingDate,
  });
}
