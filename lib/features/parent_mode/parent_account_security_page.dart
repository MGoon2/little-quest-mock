import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_profile_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_danger_outline_button.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_login_method_row.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_page_header.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_recent_login_row.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

class ParentAccountSecurityPage extends StatelessWidget {
  const ParentAccountSecurityPage({super.key});

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
                title: '계정 및 보안',
                description: '계정 보안 상태를 확인하고 관리할 수 있어요.',
              ),
              const SizedBox(height: 26),
              _SecurityActionCard(
                title: '비밀번호',
                icon: Icons.lock_outline,
                body: '비밀번호를 주기적으로\n변경해 주세요.',
                actionLabel: '변경하기',
                onPressed: () => _showPendingMessage(context, '비밀번호 변경'),
              ),
              const SizedBox(height: 18),
              _TwoFactorAuthCard(
                onTap: () => _showPendingMessage(context, '2단계 인증 설정'),
              ),
              const SizedBox(height: 18),
              ParentSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(title: '로그인 방법'),
                    const SizedBox(height: 10),
                    for (final method in parentLoginMethods)
                      ParentLoginMethodRow(
                        method: method,
                        showDivider: method != parentLoginMethods.last,
                        onTap: () => _showPendingMessage(
                          context,
                          '${method.label} 연결 설정',
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ParentSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      title: '최근 로그인 기록',
                      trailing: TextButton(
                        onPressed: () =>
                            _showPendingMessage(context, '로그인 기록 전체 보기'),
                        child: const Text(
                          '전체 보기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: LqColors.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final item in parentLoginHistoryItems)
                      ParentRecentLoginRow(
                        loggedInAtLabel: _formatLoginDate(item.loggedInAt),
                        deviceName: item.deviceName,
                        showDivider: item != parentLoginHistoryItems.last,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              ParentDangerOutlineButton(
                label: '모든 기기에서 로그아웃',
                onPressed: () => _showLogoutAllDevicesDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPendingMessage(BuildContext context, String label) {
    // TODO: account security flow 연결
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label 화면은 준비 중이에요.')));
  }

  Future<void> _showLogoutAllDevicesDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: LqColors.cardCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Text(
            '모든 기기에서 로그아웃할까요?',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: LqColors.textDark,
            ),
          ),
          content: const Text(
            '현재 사용 중인 기기를 제외한 모든 기기에서 다시 로그인이 필요해요.',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              height: 1.5,
              color: LqColors.textDark,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // TODO: logout all devices API 연결
                Navigator.of(context).pop();
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(color: LqColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SecurityActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String body;
  final String actionLabel;
  final VoidCallback onPressed;

  const _SecurityActionCard({
    required this.title,
    required this.icon,
    required this.body,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ParentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title),
          const SizedBox(height: 14),
          Row(
            children: [
              _SecurityIcon(icon: icon),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    height: 1.45,
                    color: LqColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: LqColors.primaryGreen,
                  side: const BorderSide(color: LqColors.primaryGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                child: Text(actionLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TwoFactorAuthCard extends StatelessWidget {
  final VoidCallback onTap;

  const _TwoFactorAuthCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: ParentSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(title: '2단계 인증'),
              const SizedBox(height: 14),
              Row(
                children: const [
                  _SecurityIcon(icon: Icons.verified_user_outlined),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      '로그인 시 추가 인증으로 계정을 안전하게 보호해요.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        height: 1.45,
                        color: LqColors.textDark,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '사용 중',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: LqColors.primaryGreen,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: LqColors.textSubtle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityIcon extends StatelessWidget {
  final IconData icon;

  const _SecurityIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: LqColors.softGreen,
        shape: BoxShape.circle,
        border: Border.all(color: LqColors.lightGreen),
      ),
      child: Icon(icon, size: 28, color: LqColors.primaryGreen),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: LqColors.textDark,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

String _formatLoginDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour < 12 ? '오전' : '오후';
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  return '${date.year}. $month. $day  $period $hour:$minute';
}
