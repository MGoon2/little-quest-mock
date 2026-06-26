import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';

/// 마이페이지 AppBar.
class MyPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: LqColors.cream,
      elevation: 0,
      toolbarHeight: 64,
      title: const Text(
        '마이페이지',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: LqColors.deepGreen,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: LqColors.textDark),
          onPressed: () {
            // TODO: notifications page
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: LqColors.textDark),
          onPressed: () {
            // TODO: settings page
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
