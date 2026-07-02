import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_profile_fixture.dart';
import 'package:little_quest/features/parent_mode/models/parent_child_profile.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_image_placeholder.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_info_row.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_page_header.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_primary_button.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_safe_notice_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

class ParentChildInfoPage extends StatelessWidget {
  final String childId;

  const ParentChildInfoPage({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    final child = findParentChildProfile(childId);

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
                title: '아이 정보',
                description: '우리 아이의 기본 정보를 확인하고 수정할 수 있어요.',
              ),
              const SizedBox(height: 26),
              _ParentChildProfileDetailCard(child: child),
              const SizedBox(height: 20),
              _ParentChildAdditionalInfoCard(child: child),
              const SizedBox(height: 20),
              const ParentSafeNoticeCard(
                title: '우리 아이의 정보는 안전하게 보호돼요.',
                description: '개인정보는 보호자만 수정할 수 있어요.',
              ),
              const SizedBox(height: 28),
              ParentPrimaryButton(
                label: '정보 수정하기',
                onPressed: () => _showPendingEditMessage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPendingEditMessage(BuildContext context) {
    // TODO: child info edit flow 연결
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('아이 정보 수정 화면은 준비 중이에요.')));
  }
}

class _ParentChildProfileDetailCard extends StatelessWidget {
  final ParentChildProfile child;

  const _ParentChildProfileDetailCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ParentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('프로필'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _ProfileImage(child: child),
                  const SizedBox(height: 10),
                  const Text(
                    '프로필 이미지',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      color: LqColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    ParentInfoRow(
                      label: '이름',
                      value: child.name,
                      labelWidth: 64,
                      onTap: () => _showPendingRowMessage(context, '이름'),
                    ),
                    ParentInfoRow(
                      label: '닉네임',
                      value: child.nickname,
                      labelWidth: 64,
                      onTap: () => _showPendingRowMessage(context, '닉네임'),
                    ),
                    ParentInfoRow(
                      label: '생년월일',
                      value: '${_formatDate(child.birthDate)}\n(${child.age}세)',
                      labelWidth: 64,
                      onTap: () => _showPendingRowMessage(context, '생년월일'),
                    ),
                    ParentInfoRow(
                      label: '성별',
                      value: child.genderLabel,
                      labelWidth: 64,
                      showDivider: false,
                      onTap: () => _showPendingRowMessage(context, '성별'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ParentInfoRow(
            label: '탐험 레벨',
            value: '레벨 ${child.explorerLevel}',
            showChevron: false,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  void _showPendingRowMessage(BuildContext context, String label) {
    // TODO: 아이 정보 항목 수정 bottom sheet 또는 edit page 연결
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label 수정 화면은 준비 중이에요.')));
  }
}

class _ParentChildAdditionalInfoCard extends StatelessWidget {
  final ParentChildProfile child;

  const _ParentChildAdditionalInfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ParentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('추가 정보'),
          const SizedBox(height: 10),
          ParentInfoRow(
            label: '관심 분야',
            value: child.interests.join(', '),
            onTap: () => _showPendingRowMessage(context, '관심 분야'),
          ),
          ParentInfoRow(
            label: '선호 활동 시간',
            value: child.preferredActivityTime,
            onTap: () => _showPendingRowMessage(context, '선호 활동 시간'),
          ),
          ParentInfoRow(
            label: '메모',
            value: child.memo,
            showDivider: false,
            onTap: () => _showPendingRowMessage(context, '메모'),
          ),
        ],
      ),
    );
  }

  void _showPendingRowMessage(BuildContext context, String label) {
    // TODO: 아이 추가 정보 수정 bottom sheet 또는 edit page 연결
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label 수정 화면은 준비 중이에요.')));
  }
}

class _ProfileImage extends StatelessWidget {
  final ParentChildProfile child;

  const _ProfileImage({required this.child});

  @override
  Widget build(BuildContext context) {
    if (child.avatarAssetPath == null) {
      return const ParentImagePlaceholder(
        label: '프로필 이미지',
        shape: BoxShape.circle,
        size: 104,
      );
    }

    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: LqColors.lightGreen, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(child.avatarAssetPath!, fit: BoxFit.cover),
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

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}.$month.$day';
}
