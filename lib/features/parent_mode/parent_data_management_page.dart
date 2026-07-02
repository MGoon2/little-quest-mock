import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_danger_button.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_list_tile.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_warning_card.dart';

class ParentDataManagementPage extends StatelessWidget {
  const ParentDataManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: '데이터 관리'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ParentWarningCard(
                title: '데이터를 삭제하면 복구할 수 없어요.',
                description: '신중하게 선택해 주세요.',
              ),
              const SizedBox(height: 18),
              ParentSectionCard(
                child: Column(
                  children: [
                    for (final option in ParentModeFixture.deletionOptions)
                      ParentListTile(
                        icon: option.icon,
                        title: option.title,
                        description: option.description,
                        showDivider:
                            option != ParentModeFixture.deletionOptions.last,
                        iconBackgroundColor: option.destructive
                            ? LqColors.dangerSoft
                            : LqColors.softGreen,
                        iconColor: option.destructive
                            ? LqColors.danger
                            : LqColors.primaryGreen,
                        onTap: () => _showDeleteDialog(
                          context,
                          title: option.title,
                          strong: option.destructive,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ParentDangerButton(
                label: '계정 삭제하기',
                onPressed: () => _showAccountDeleteDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context, {
    required String title,
    required bool strong,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: LqColors.cardCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Text(
            '정말 삭제할까요?',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: LqColors.textDark,
            ),
          ),
          content: Text(
            strong
                ? '$title 작업은 되돌릴 수 없어요.\n삭제한 데이터는 복구할 수 없어요.'
                : '삭제한 데이터는 복구할 수 없어요.',
            style: const TextStyle(
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
                // TODO: 데이터 삭제 API 연결
                Navigator.of(context).pop();
              },
              child: const Text(
                '삭제하기',
                style: TextStyle(color: LqColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAccountDeleteDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: LqColors.cardCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Text(
            '계정 삭제는 보호자 확인이 필요해요.',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: LqColors.textDark,
            ),
          ),
          content: const Text(
            '계정 삭제는 모든 기록과 구독 정보에 영향을 줄 수 있어요.\n보호자 확인 후 진행해야 합니다.',
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
                // TODO: 보호자 재인증 후 계정 삭제 API 연결
                Navigator.of(context).pop();
              },
              child: const Text(
                '보호자 확인 후 진행',
                style: TextStyle(color: LqColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }
}
