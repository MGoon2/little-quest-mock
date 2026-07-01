import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 계정 확인 AppBar.
class AccountVerificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;

  const AccountVerificationAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: LqColors.cream,
      elevation: 0,
      toolbarHeight: title != null ? 64 : 56,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: LqColors.textDark),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: LqColors.deepGreen,
              ),
            )
          : null,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(title != null ? 64 : 56);
}
