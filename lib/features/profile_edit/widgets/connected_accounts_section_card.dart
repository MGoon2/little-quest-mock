import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/profile_edit_data.dart';

/// 연결 계정 섹션 카드.
class ConnectedAccountsSectionCard extends StatelessWidget {
  final ProfileEditData data;

  const ConnectedAccountsSectionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '연결 계정',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: LqColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          _AccountRow(
            icon: Icons.g_mobiledata,
            label: 'Google',
            connected: data.googleConnected,
            onTap: () {
              // TODO: Google account connection management
            },
          ),
          _AccountRow(
            icon: Icons.phone_iphone,
            label: 'Apple',
            connected: data.appleConnected,
            onTap: () {
              // TODO: Apple account connection management
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

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool connected;
  final VoidCallback? onTap;

  const _AccountRow({
    required this.icon,
    required this.label,
    required this.connected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: label == 'Google'
              ? Border(
                  bottom: BorderSide(color: LqColors.border),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: LqColors.textDark),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: LqColors.textDark,
                ),
              ),
            ),
            Text(
              connected ? '연결됨' : '연결하기',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: connected ? LqColors.primaryGreen : LqColors.textSubtle,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: LqColors.textSubtle,
            ),
          ],
        ),
      ),
    );
  }
}
