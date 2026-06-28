import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/social_account_verification_data.dart';
import 'social_verification_button.dart';

/// SNS 재인증 카드.
class SocialVerificationCard extends StatelessWidget {
  final List<AuthProvider> providers;
  final ValueChanged<AuthProvider>? onProviderTap;

  const SocialVerificationCard({
    super.key,
    required this.providers,
    this.onProviderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LqColors.border),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.spa,
                size: 18,
                color: LqColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              const Text(
                'SNS로 가입한 계정이에요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: LqColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...providers.asMap().entries.map((entry) {
            final provider = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SocialVerificationButton(
                provider: provider,
                onTap: () => onProviderTap?.call(provider),
              ),
            );
          }),
        ],
      ),
    );
  }
}
