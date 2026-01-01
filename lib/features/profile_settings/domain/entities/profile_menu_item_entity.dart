import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

enum ProfileMenuItemType {
  navigation,
  toggle,
  action,
}

class ProfileMenuItemEntity extends Equatable {
  const ProfileMenuItemEntity({
    required this.id,
    required this.title,
    required this.iconBuilder,
    required this.type,
    this.subtitle,
    this.onTap,
    this.isToggleOn = false,
    this.onToggleChanged,
    this.isDestructive = false,
  });

  final String id;
  final String title;
  final Widget Function() iconBuilder;
  final ProfileMenuItemType type;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isToggleOn;
  final ValueChanged<bool>? onToggleChanged;
  final bool isDestructive;

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    type,
    isToggleOn,
    isDestructive,
  ];
}
