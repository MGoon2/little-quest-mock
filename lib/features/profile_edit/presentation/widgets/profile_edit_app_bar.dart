import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 개인 정보 수정 AppBar.
class ProfileEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileEditAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: LqColors.cream,
      elevation: 0,
      toolbarHeight: 64,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: LqColors.textDark),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        '개인 정보 수정',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: LqColors.deepGreen,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
