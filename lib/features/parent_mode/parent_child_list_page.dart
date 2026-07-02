import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_profile_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_add_child_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_child_list_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_page_header.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_safe_notice_card.dart';

class ParentChildListPage extends StatelessWidget {
  const ParentChildListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: ParentAppBar(
        title: '',
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: _AddChildAction(onTap: () => _openChildCreateFlow(context)),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ParentPageHeader(
                title: '아이 목록',
                description: '관리할 아이를 선택하거나 새 아이를 추가할 수 있어요.',
              ),
              const SizedBox(height: 28),
              for (final child in parentChildProfiles) ...[
                ParentChildListCard(
                  child: child,
                  onTap: () => Navigator.of(context).pushNamed(
                    '/parent/children/${Uri.encodeComponent(child.id)}',
                  ),
                ),
                const SizedBox(height: 14),
              ],
              ParentAddChildCard(onTap: () => _openChildCreateFlow(context)),
              const SizedBox(height: 18),
              const ParentSafeNoticeCard(
                title: '아이 정보는 보호자 확인 후 안전하게 관리돼요.',
                description: '모든 아이의 데이터는 개별로 보호되고 관리됩니다.',
                icon: Icons.health_and_safety_outlined,
              ),
              const SizedBox(height: 18),
              const Text(
                '관리할 아이를 선택하면 해당 아이의 기록과 설정을 확인할 수 있어요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  height: 1.45,
                  color: LqColors.textSubtle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChildCreateFlow(BuildContext context) {
    // TODO: ParentChildCreatePage 또는 아이 추가 flow 연결
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('아이 추가 화면은 준비 중이에요.')));
  }
}

class _AddChildAction extends StatelessWidget {
  final VoidCallback onTap;

  const _AddChildAction({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: const SizedBox(
        width: 72,
        height: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AddCircle(),
            SizedBox(height: 3),
            Text(
              '아이 추가',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: LqColors.deepGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCircle extends StatelessWidget {
  const _AddCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: LqColors.primaryGreen,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 24),
    );
  }
}
