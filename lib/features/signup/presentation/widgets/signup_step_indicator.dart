import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

class SignupStepIndicator extends StatelessWidget {
  final int currentStep;

  const SignupStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const steps = [
      _SignupStepData(number: 1, label: '정보 입력'),
      _SignupStepData(number: 2, label: '이메일 인증'),
      _SignupStepData(number: 3, label: '가입 완료'),
    ];

    return Column(
      children: [
        Row(
          children: [
            for (var index = 0; index < steps.length; index++) ...[
              _StepCircle(
                number: steps[index].number,
                isActive: steps[index].number == currentStep,
              ),
              if (index != steps.length - 1)
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(color: LqColors.border, thickness: 1),
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final step in steps)
              SizedBox(
                width: 86,
                child: Text(
                  step.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: step.number == currentStep
                        ? LqColors.deepGreen
                        : LqColors.textSubtle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SignupStepData {
  final int number;
  final String label;

  const _SignupStepData({required this.number, required this.label});
}

class _StepCircle extends StatelessWidget {
  final int number;
  final bool isActive;

  const _StepCircle({required this.number, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? LqColors.primaryGreen : LqColors.disabled,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: LqColors.primaryGreen.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
