import 'package:flutter/material.dart';

/// 계정 삭제 버튼.
class DeleteAccountButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DeleteAccountButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: const Text(
          '계정 삭제',
          style: TextStyle(
            fontSize: 14,
            color: Colors.redAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
