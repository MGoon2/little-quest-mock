/// 구독 플랜 티어.
enum PlanTier { free, plus, family }

class Plan {
  final PlanTier tier;
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;

  const Plan({
    required this.tier,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
  });
}
