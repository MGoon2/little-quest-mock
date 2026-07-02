import 'package:flutter/material.dart';

import 'package:little_quest/features/profile_edit/data/datasources/profile_edit_fixture.dart';
import 'package:little_quest/features/profile_edit/data/models/profile_edit_data.dart';
import 'package:little_quest/features/profile_edit/presentation/widgets/basic_info_section_card.dart';
import 'package:little_quest/features/profile_edit/presentation/widgets/connected_accounts_section_card.dart';
import 'package:little_quest/features/profile_edit/presentation/widgets/email_section_card.dart';
import 'package:little_quest/features/profile_edit/presentation/widgets/notification_settings_section_card.dart';
import 'package:little_quest/features/profile_edit/presentation/widgets/password_section_card.dart';
import 'package:little_quest/features/profile_edit/presentation/widgets/profile_edit_app_bar.dart';
import 'package:little_quest/features/profile_edit/presentation/widgets/profile_edit_header_card.dart';
import 'package:little_quest/features/profile_edit/presentation/widgets/profile_save_button.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 개인 정보 수정 페이지.
class ProfileEditScreen extends StatelessWidget {
  final ProfileEditData? data;

  const ProfileEditScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final profileData = data ?? ProfileEditFixture.sample;

    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ProfileEditAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileEditHeaderCard(data: profileData),
              const SizedBox(height: 14),
              BasicInfoSectionCard(data: profileData),
              const SizedBox(height: 14),
              EmailSectionCard(data: profileData),
              const SizedBox(height: 14),
              const PasswordSectionCard(),
              const SizedBox(height: 14),
              ConnectedAccountsSectionCard(data: profileData),
              const SizedBox(height: 14),
              const NotificationSettingsSectionCard(),
              const SizedBox(height: 24),
              ProfileSaveButton(
                onPressed: () {
                  // TODO: validate form and call update profile API
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
