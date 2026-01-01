import 'package:flutter/material.dart';
import 'package:ahioma_food_template/features/profile_settings/domain/entities/profile_menu_item_entity.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/profile_menu_item_widget.dart';

class ProfileMenuListWidget extends StatelessWidget {
  const ProfileMenuListWidget({
    required this.menuItems,
    super.key,
  });

  final List<ProfileMenuItemEntity> menuItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Column(
        children: menuItems.map((item) {
          return ProfileMenuItemWidget(menuItem: item);
        }).toList(),
      ),
    );
  }
}
