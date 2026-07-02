import 'package:flutter/material.dart';

import 'package:little_quest/features/parent_mode/models/parent_menu_item.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_menu_tile.dart';

/// 부모 홈 2열 메뉴 그리드.
class ParentMenuGrid extends StatelessWidget {
  final List<ParentMenuItem> items;
  final ValueChanged<ParentMenuType> onItemTap;

  const ParentMenuGrid({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.04,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return ParentMenuTile(item: item, onTap: () => onItemTap(item.type));
      },
    );
  }
}
