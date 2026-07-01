import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 저장하기 버튼.
class ProfileSaveButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ProfileSaveButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [LqColors.lightGreen, LqColors.softGreen],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: LqColors.primaryGreen.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              '저장하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LqColors.deepGreen,
              ),
            ),
            Positioned(
              right: 20,
              child: Icon(
                Icons.eco,
                size: 24,
                color: LqColors.primaryGreen.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
