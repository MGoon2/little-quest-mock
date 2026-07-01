import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

class SignupAgreementSection extends StatelessWidget {
  final bool agreedTerms;
  final bool agreedPrivacy;
  final ValueChanged<bool> onTermsChanged;
  final ValueChanged<bool> onPrivacyChanged;
  final VoidCallback onTermsView;
  final VoidCallback onPrivacyView;

  const SignupAgreementSection({
    super.key,
    required this.agreedTerms,
    required this.agreedPrivacy,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
    required this.onTermsView,
    required this.onPrivacyView,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AgreementRow(
          isChecked: agreedTerms,
          label: '이용약관에 동의합니다. (필수)',
          onChanged: onTermsChanged,
          onView: onTermsView,
        ),
        const SizedBox(height: 12),
        _AgreementRow(
          isChecked: agreedPrivacy,
          label: '개인정보 수집 및 이용에 동의합니다. (필수)',
          onChanged: onPrivacyChanged,
          onView: onPrivacyView,
        ),
      ],
    );
  }
}

class _AgreementRow extends StatelessWidget {
  final bool isChecked;
  final String label;
  final ValueChanged<bool> onChanged;
  final VoidCallback onView;

  const _AgreementRow({
    required this.isChecked,
    required this.label,
    required this.onChanged,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Semantics(
          button: true,
          checked: isChecked,
          label: label,
          child: InkWell(
            onTap: () => onChanged(!isChecked),
            borderRadius: BorderRadius.circular(8),
            child: Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: isChecked ? LqColors.primaryGreen : LqColors.textSubtle,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w600,
              color: LqColors.textDark,
            ),
          ),
        ),
        TextButton(
          onPressed: onView,
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 40),
            foregroundColor: LqColors.textSubtle,
            textStyle: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              decoration: TextDecoration.underline,
            ),
          ),
          child: const Text('보기'),
        ),
      ],
    );
  }
}
