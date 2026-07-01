import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_dimensions.dart';

class SignupNextButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;

  const SignupNextButton({super.key, required this.enabled, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SignupDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: LqColors.primaryGreen,
          disabledBackgroundColor: LqColors.disabled,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SignupDimensions.fieldRadius),
          ),
        ),
        child: const Text(
          '다음',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
