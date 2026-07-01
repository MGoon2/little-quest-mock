import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_dimensions.dart';

class SignupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? helperText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const SignupTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.helperText,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: LqColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: SignupDimensions.inputHeight,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: onChanged,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: LqColors.textDark,
            ),
            decoration: InputDecoration(
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: LqColors.textSubtle,
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.76),
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  SignupDimensions.fieldRadius,
                ),
                borderSide: const BorderSide(color: LqColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  SignupDimensions.fieldRadius,
                ),
                borderSide: const BorderSide(
                  color: LqColors.primaryGreen,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText!,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              height: 1.4,
              color: LqColors.textSubtle,
            ),
          ),
        ],
      ],
    );
  }
}
