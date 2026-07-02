import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_list_tile.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_mode_hero_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

class ParentModeEntryPage extends StatelessWidget {
  const ParentModeEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: '부모 모드로 이동'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '아이의 정보와 탐험 기록, 결제 설정을\n관리할 수 있어요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 15,
                  height: 1.55,
                  color: LqColors.textDark,
                ),
              ),
              const SizedBox(height: 18),
              const ParentModeHeroCard(),
              const SizedBox(height: 18),
              ParentSectionCard(
                backgroundColor: LqColors.softGreen.withValues(alpha: 0.72),
                child: Column(
                  children: [
                    ParentListTile(
                      icon: Icons.verified_user_outlined,
                      title: '개인정보 및 동의 관리',
                      showDivider: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed('/parent/privacy-consent'),
                    ),
                    ParentListTile(
                      icon: Icons.location_on_outlined,
                      title: '탐험 기록 및 위치 관리',
                      showDivider: true,
                      onTap: () =>
                          Navigator.of(context).pushNamed('/parent/records'),
                    ),
                    ParentListTile(
                      icon: Icons.credit_card_outlined,
                      title: '구독 및 결제 관리',
                      showDivider: true,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed('/parent/subscription'),
                    ),
                    ParentListTile(
                      icon: Icons.delete_outline,
                      title: '데이터 삭제 및 계정 관리',
                      showDivider: false,
                      onTap: () =>
                          Navigator.of(context).pushNamed('/parent/data'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/parent/verify'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LqColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text(
                    '보호자 확인하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
