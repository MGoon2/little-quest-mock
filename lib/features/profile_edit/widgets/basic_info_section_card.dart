import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/profile_edit_data.dart';
import 'profile_setting_row.dart';

/// 기본 정보 섹션 카드.
class BasicInfoSectionCard extends StatelessWidget {
  final ProfileEditData data;

  const BasicInfoSectionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기본 정보',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: LqColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          ProfileSettingRow(
            leadingIcon: const Icon(
              Icons.spa,
              size: 20,
              color: LqColors.primaryGreen,
            ),
            label: '닉네임',
            value: data.nickname,
            onTap: () {
              // TODO: nickname edit
            },
          ),
          ProfileSettingRow(
            leadingIcon: const Icon(
              Icons.calendar_today,
              size: 20,
              color: LqColors.primaryGreen,
            ),
            label: '생년월일',
            value: data.birthDate,
            onTap: () {
              // TODO: birth date picker
            },
          ),
          ProfileSettingRow(
            leadingIcon: const Icon(
              Icons.person,
              size: 20,
              color: LqColors.primaryGreen,
            ),
            label: '성별',
            value: data.genderLabel,
            onTap: () {
              // TODO: gender selector
            },
          ),
          ProfileSettingRow(
            leadingIcon: const Icon(
              Icons.language,
              size: 20,
              color: LqColors.primaryGreen,
            ),
            label: '언어',
            value: data.languageLabel,
            showDivider: false,
            onTap: () {
              // TODO: language selector
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LqColors.border),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
