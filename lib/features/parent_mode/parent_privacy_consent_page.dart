import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_list_tile.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_status_badge.dart';

class ParentPrivacyConsentPage extends StatelessWidget {
  const ParentPrivacyConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 보호자 동의 상태 조회 API 연결
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: '개인정보 및 동의 관리'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionTitle('개인정보'),
              ParentSectionCard(
                child: Column(
                  children: [
                    for (final section in ParentModeFixture.privacySections)
                      for (final item in section.items)
                        ParentListTile(
                          icon: item.icon,
                          title: item.title,
                          description: item.description,
                          showDivider: item != section.items.last,
                          onTap: () {
                            final routeName = item.routeName;
                            if (routeName != null) {
                              Navigator.of(context).pushNamed(routeName);
                              return;
                            }
                            // TODO: 개인정보 상세 관리 API/화면 연결
                          },
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _SectionTitle('동의 관리'),
              ParentSectionCard(
                child: Column(
                  children: [
                    for (final consent in ParentModeFixture.consentStatuses)
                      ParentListTile(
                        icon: consent.isRequired
                            ? Icons.lock_outline
                            : Icons.tune_outlined,
                        title: consent.title,
                        description: consent.description,
                        showDivider:
                            consent != ParentModeFixture.consentStatuses.last,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ParentStatusBadge(
                              label: consent.agreementLabel,
                              backgroundColor: consent.badgeColor,
                              textColor: consent.textColor,
                            ),
                            const SizedBox(width: 6),
                            ParentStatusBadge(
                              label: consent.requirementLabel,
                              backgroundColor: LqColors.cardCream,
                              textColor: LqColors.textSubtle,
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: LqColors.textSubtle,
                            ),
                          ],
                        ),
                        onTap: () {
                          // TODO: 상세 동의 WebView 또는 동의 변경 API/화면 연결
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ParentSectionCard(
                backgroundColor: LqColors.softGreen,
                child: Row(
                  children: const [
                    Icon(Icons.lock_outline, color: LqColors.deepGreen),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '모든 동의는 보호자 확인 후 변경할 수 있어요.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          height: 1.45,
                          color: LqColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: LqColors.textDark,
        ),
      ),
    );
  }
}
