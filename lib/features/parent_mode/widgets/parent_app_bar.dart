import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';

/// 부모 모드 전용 커스텀 AppBar.
class ParentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showNotification;
  final Widget? trailing;

  const ParentAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showNotification = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: LqColors.cream,
      elevation: 0,
      toolbarHeight: 64,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              tooltip: '뒤로가기',
              icon: const Icon(Icons.arrow_back, color: LqColors.textDark),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: title.isEmpty
          ? null
          : Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: LqColors.textDark,
              ),
            ),
      centerTitle: false,
      actions: [
        ?trailing,
        if (showNotification)
          IconButton(
            tooltip: '부모 모드 알림',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: LqColors.textDark,
                  size: 26,
                ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: LqColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // TODO: 부모 모드 알림 목록 연결
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
