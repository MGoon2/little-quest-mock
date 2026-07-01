import 'package:flutter/material.dart';

import 'package:little_quest/features/account_verification/data/models/account_verification_method_data.dart';
import 'package:little_quest/features/account_verification/presentation/widgets/verification_method_button.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 계정 확인 방법 선택 카드.
class VerificationMethodCard extends StatelessWidget {
  final List<VerificationMethod> methods;
  final ValueChanged<VerificationMethod>? onMethodTap;

  const VerificationMethodCard({
    super.key,
    required this.methods,
    this.onMethodTap,
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
              const Icon(Icons.spa, size: 18, color: LqColors.primaryGreen),
              const SizedBox(width: 8),
              const Text(
                '다양한 방법으로 확인할 수 있어요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: LqColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...methods.asMap().entries.map((entry) {
            final method = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: VerificationMethodButton(
                method: method,
                onTap: () => onMethodTap?.call(method),
              ),
            );
          }),
        ],
      ),
    );
  }
}
