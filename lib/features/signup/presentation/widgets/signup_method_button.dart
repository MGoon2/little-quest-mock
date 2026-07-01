import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/signup/data/models/signup_provider.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_dimensions.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_provider_mark.dart';

class SignupMethodButton extends StatelessWidget {
  final SignupProvider provider;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const SignupMethodButton._({
    super.key,
    required this.provider,
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  const SignupMethodButton.email({
    Key? key,
    required String label,
    required VoidCallback onPressed,
  }) : this._(
         key: key,
         provider: SignupProvider.email,
         label: label,
         onPressed: onPressed,
         isPrimary: true,
       );

  const SignupMethodButton.social({
    Key? key,
    required SignupProvider provider,
    required String label,
    required VoidCallback onPressed,
  }) : this._(
         key: key,
         provider: provider,
         label: label,
         onPressed: onPressed,
         isPrimary: false,
       );

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary ? Colors.white : LqColors.textDark;
    final background = isPrimary ? LqColors.primaryGreen : Colors.white;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(SignupDimensions.fieldRadius),
        elevation: 0,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(SignupDimensions.fieldRadius),
          child: Container(
            height: SignupDimensions.buttonHeight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SignupDimensions.fieldRadius),
              border: isPrimary ? null : Border.all(color: LqColors.border),
              boxShadow: [
                BoxShadow(
                  color: LqColors.textDark.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SignupProviderMark(
                    provider: provider,
                    isPrimary: isPrimary,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
