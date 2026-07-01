import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 퀘스트 상세 AppBar.
class QuestDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuestDetailAppBar({super.key});

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
        '퀘스트 상세',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: LqColors.deepGreen,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: LqColors.textDark),
          onPressed: () {
            // TODO: share quest
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
