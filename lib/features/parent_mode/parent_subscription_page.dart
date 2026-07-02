import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_danger_button.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_list_tile.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_subscription_card.dart';

class ParentSubscriptionPage extends StatelessWidget {
  const ParentSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: '구독 및 결제 관리'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionTitle('현재 구독'),
              ParentSubscriptionCard(
                summary: ParentModeFixture.subscriptionSummary,
              ),
              const SizedBox(height: 22),
              const _SectionTitle('구독 혜택'),
              ParentSectionCard(
                child: Column(
                  children: [
                    for (final benefit
                        in ParentModeFixture.subscriptionBenefits)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              benefit ==
                                  ParentModeFixture.subscriptionBenefits.last
                              ? 0
                              : 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              benefit.icon,
                              size: 20,
                              color: LqColors.primaryGreen,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                benefit.label,
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 14,
                                  height: 1.4,
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
              const SizedBox(height: 22),
              ParentSectionCard(
                child: Column(
                  children: [
                    ParentListTile(
                      icon: Icons.receipt_long_outlined,
                      title: '결제 내역',
                      description: '최근 결제와 영수증을 확인해요',
                      onTap: () {
                        // TODO: 구독 상태 조회 API 연결
                      },
                    ),
                    ParentListTile(
                      icon: Icons.credit_card_outlined,
                      title: '결제 수단 관리',
                      description: '카드와 스토어 결제 정보를 관리해요',
                      showDivider: false,
                      onTap: () {
                        // TODO: 결제 수단 관리 API 연결
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ParentDangerButton(
                label: '구독 해지하기',
                onPressed: () {
                  // TODO: 구독 해지 API 연결
                },
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
