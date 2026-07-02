import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_bottom_navigation.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_list_tile.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

class ParentSettingsPage extends StatefulWidget {
  const ParentSettingsPage({super.key});

  @override
  State<ParentSettingsPage> createState() => _ParentSettingsPageState();
}

class _ParentSettingsPageState extends State<ParentSettingsPage> {
  bool _pushEnabled = true;
  bool _eventEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: '설정'),
      bottomNavigationBar: const ParentBottomNavigation(currentIndex: 2),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionTitle('일반'),
              ParentSectionCard(
                child: Column(
                  children: [
                    for (final row in ParentModeFixture.generalSettings)
                      ParentListTile(
                        icon: row.icon,
                        title: row.title,
                        showDivider:
                            row != ParentModeFixture.generalSettings.last,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (row.value != null)
                              Text(
                                row.value!,
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 13,
                                  color: LqColors.textSubtle,
                                ),
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
                          // TODO: 부모 모드 일반 설정 상세 연결
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _SectionTitle('알림 설정'),
              ParentSectionCard(
                child: Column(
                  children: [
                    ParentListTile(
                      icon: Icons.notifications_none,
                      title: '푸시 알림',
                      trailing: Switch(
                        value: _pushEnabled,
                        activeThumbColor: LqColors.primaryGreen,
                        activeTrackColor: LqColors.softGreen,
                        onChanged: (value) {
                          setState(() => _pushEnabled = value);
                          // TODO: 부모 알림 설정 API 연결
                        },
                      ),
                    ),
                    ParentListTile(
                      icon: Icons.campaign_outlined,
                      title: '이벤트 및 소식',
                      showDivider: false,
                      trailing: Switch(
                        value: _eventEnabled,
                        activeThumbColor: LqColors.primaryGreen,
                        activeTrackColor: LqColors.softGreen,
                        onChanged: (value) {
                          setState(() => _eventEnabled = value);
                          // TODO: 이벤트 알림 설정 API 연결
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _SectionTitle('고객 지원'),
              ParentSectionCard(
                child: Column(
                  children: [
                    for (final row in ParentModeFixture.supportSettings)
                      ParentListTile(
                        icon: row.icon,
                        title: row.title,
                        showDivider:
                            row != ParentModeFixture.supportSettings.last,
                        onTap: () {
                          // TODO: 고객 지원 화면 연결
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: 로그아웃 API 연결
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: LqColors.textDark,
                    side: const BorderSide(color: LqColors.border),
                    backgroundColor: LqColors.cardCream,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: const Text('로그아웃'),
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
