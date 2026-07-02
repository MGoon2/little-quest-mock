import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_profile_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_info_row.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_notification_switch_row.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_page_header.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_primary_button.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_safe_notice_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

class ParentGuardianInfoPage extends StatefulWidget {
  const ParentGuardianInfoPage({super.key});

  @override
  State<ParentGuardianInfoPage> createState() => _ParentGuardianInfoPageState();
}

class _ParentGuardianInfoPageState extends State<ParentGuardianInfoPage> {
  late bool _eventNotificationEnabled;
  late bool _emailNotificationEnabled;
  late bool _smsNotificationEnabled;

  @override
  void initState() {
    super.initState();
    _eventNotificationEnabled = parentGuardianProfile.eventNotificationEnabled;
    _emailNotificationEnabled = parentGuardianProfile.emailNotificationEnabled;
    _smsNotificationEnabled = parentGuardianProfile.smsNotificationEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: ''),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ParentPageHeader(
                title: '보호자 정보',
                description: '보호자 연락처와 계정 정보를 관리할 수 있어요.',
              ),
              const SizedBox(height: 26),
              _GuardianBasicInfoCard(onRowTap: _showPendingEditMessage),
              const SizedBox(height: 20),
              ParentSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CardTitle('알림 수신 설정'),
                    const SizedBox(height: 10),
                    ParentNotificationSwitchRow(
                      icon: Icons.notifications_none,
                      label: '이벤트 및 소식 알림',
                      value: _eventNotificationEnabled,
                      onChanged: (value) => _updateNotification(
                        kind: '이벤트 및 소식 알림',
                        value: value,
                      ),
                    ),
                    ParentNotificationSwitchRow(
                      icon: Icons.mail_outline,
                      label: '이메일 알림',
                      value: _emailNotificationEnabled,
                      onChanged: (value) =>
                          _updateNotification(kind: '이메일 알림', value: value),
                    ),
                    ParentNotificationSwitchRow(
                      icon: Icons.sms_outlined,
                      label: 'SMS 알림',
                      value: _smsNotificationEnabled,
                      showDivider: false,
                      onChanged: (value) =>
                          _updateNotification(kind: 'SMS 알림', value: value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const ParentSafeNoticeCard(
                title: '보호자 연락처는 계정 보안과 중요한 안내를 위해 사용돼요.',
                description: '연락처 변경은 보호자 확인 후 안전하게 반영됩니다.',
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 28),
              ParentPrimaryButton(
                label: '정보 수정하기',
                onPressed: () => _showPendingEditMessage('보호자 정보'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateNotification({required String kind, required bool value}) {
    setState(() {
      switch (kind) {
        case '이벤트 및 소식 알림':
          _eventNotificationEnabled = value;
          break;
        case '이메일 알림':
          _emailNotificationEnabled = value;
          break;
        case 'SMS 알림':
          _smsNotificationEnabled = value;
          break;
        default:
          break;
      }
    });
    // TODO: 보호자 알림 수신 설정 저장 API 연결
  }

  void _showPendingEditMessage(String label) {
    // TODO: guardian info edit flow 연결
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label 수정 화면은 준비 중이에요.')));
  }
}

class _GuardianBasicInfoCard extends StatelessWidget {
  final ValueChanged<String> onRowTap;

  const _GuardianBasicInfoCard({required this.onRowTap});

  @override
  Widget build(BuildContext context) {
    return ParentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('기본 정보'),
          const SizedBox(height: 10),
          ParentInfoRow(
            label: '이름',
            value: parentGuardianProfile.name,
            onTap: () => onRowTap('이름'),
          ),
          ParentInfoRow(
            label: '이메일',
            value: parentGuardianProfile.email,
            onTap: () => onRowTap('이메일'),
          ),
          ParentInfoRow(
            label: '휴대폰 번호',
            value: parentGuardianProfile.phoneNumber,
            onTap: () => onRowTap('휴대폰 번호'),
          ),
          ParentInfoRow(
            label: '관계',
            value: parentGuardianProfile.relationLabel,
            showDivider: false,
            onTap: () => onRowTap('관계'),
          ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String title;

  const _CardTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: LqColors.textDark,
      ),
    );
  }
}
