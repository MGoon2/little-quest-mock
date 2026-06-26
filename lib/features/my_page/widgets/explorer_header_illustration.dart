import 'package:flutter/material.dart';

/// 상단 탐험가 일러스트 헤더.
class ExplorerHeaderIllustration extends StatelessWidget {
  const ExplorerHeaderIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        'assets/images/my_page_bg.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 280,
      ),
    );
  }
}
