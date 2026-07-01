import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

class EmailSignupAppBar extends StatelessWidget {
  const EmailSignupAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: '뒤로가기',
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: LqColors.textDark,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Text(
            '이메일로 회원가입',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Jua',
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: LqColors.deepGreen,
            ),
          ),
        ],
      ),
    );
  }
}
