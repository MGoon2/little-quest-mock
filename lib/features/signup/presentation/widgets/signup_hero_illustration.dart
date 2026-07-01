import 'package:flutter/material.dart';

class SignupHeroIllustration extends StatelessWidget {
  const SignupHeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Image.asset(
        'assets/images/signup/signup_landing_bg.png',
        fit: BoxFit.contain,
        semanticLabel: '지도와 함께 자연을 탐험하는 아이 일러스트',
      ),
    );
  }
}
