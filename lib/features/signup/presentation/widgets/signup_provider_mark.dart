import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/signup/data/models/signup_provider.dart';

class SignupProviderMark extends StatelessWidget {
  final SignupProvider provider;
  final bool isPrimary;

  const SignupProviderMark({
    super.key,
    required this.provider,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (provider == SignupProvider.email) {
      return Icon(
        Icons.mail_outline,
        size: 24,
        color: isPrimary ? Colors.white : LqColors.primaryGreen,
      );
    }

    return ExcludeSemantics(
      child: SizedBox(
        width: 34,
        height: 34,
        child: Center(child: _buildProviderSymbol()),
      ),
    );
  }

  Widget _buildProviderSymbol() {
    switch (provider) {
      case SignupProvider.email:
        return const Icon(Icons.mail_outline);
      case SignupProvider.google:
        return const Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontSize: 28,
            fontWeight: FontWeight.w800,
            fontFamily: 'Pretendard',
          ),
        );
      case SignupProvider.apple:
        return const Icon(Icons.apple, color: Colors.black, size: 32);
      case SignupProvider.naver:
        return Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFF03C75A),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        );
      case SignupProvider.kakao:
        return Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: LqColors.kakaoYellow,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'K',
              style: TextStyle(
                color: Color(0xFF3B1E1E),
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        );
    }
  }
}
