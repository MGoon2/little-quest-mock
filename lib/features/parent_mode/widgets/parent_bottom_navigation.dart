import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/app_shadows.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 부모 모드 내부에서만 쓰는 임시 하단 네비게이션.
class ParentBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const ParentBottomNavigation({super.key, required this.currentIndex});

  static const _items = [
    _ParentNavItem(
      icon: Icons.child_care_outlined,
      label: '아이 모드',
      routeName: '/home',
    ),
    _ParentNavItem(
      icon: Icons.family_restroom,
      label: '부모 모드',
      routeName: '/parent/home',
    ),
    _ParentNavItem(
      icon: Icons.settings_outlined,
      label: '설정',
      routeName: '/parent/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: LqColors.cardCream,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: LqColors.border),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = currentIndex == index;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: selected,
                  label: item.label,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    onTap: selected
                        ? null
                        : () => _navigate(context, item.routeName),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 22,
                          color: selected
                              ? LqColors.primaryGreen
                              : LqColors.textSubtle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? LqColors.primaryGreen
                                : LqColors.textSubtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String routeName) {
    if (routeName == '/home') {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(routeName, (route) => false);
      return;
    }

    Navigator.of(context).pushReplacementNamed(routeName);
  }
}

class _ParentNavItem {
  final IconData icon;
  final String label;
  final String routeName;

  const _ParentNavItem({
    required this.icon,
    required this.label,
    required this.routeName,
  });
}
