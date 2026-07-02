import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/models/parent_login_method.dart';

class ParentLoginMethodRow extends StatelessWidget {
  final ParentLoginMethod method;
  final VoidCallback? onTap;
  final bool showDivider;

  const ParentLoginMethodRow({
    super.key,
    required this.method,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: LqColors.border))
            : null,
      ),
      child: Row(
        children: [
          _ProviderMark(method: method),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              method.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: LqColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            method.connected ? '연결됨' : '연결 안됨',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: method.connected
                  ? LqColors.primaryGreen
                  : LqColors.textSubtle,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, size: 18, color: LqColors.textSubtle),
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class _ProviderMark extends StatelessWidget {
  final ParentLoginMethod method;

  const _ProviderMark({required this.method});

  @override
  Widget build(BuildContext context) {
    if (method.iconAssetPath != null) {
      return SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(method.iconAssetPath!, fit: BoxFit.contain),
      );
    }

    final mark = method.provider == 'google' ? 'G' : 'A';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: LqColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        mark,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: method.provider == 'google'
              ? LqColors.primaryGreen
              : LqColors.textDark,
        ),
      ),
    );
  }
}
