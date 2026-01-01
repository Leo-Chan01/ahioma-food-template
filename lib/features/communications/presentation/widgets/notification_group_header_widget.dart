import 'package:flutter/material.dart';

class NotificationGroupHeaderWidget extends StatelessWidget {
  const NotificationGroupHeaderWidget({
    required this.header,
    super.key,
  });

  final String header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Text(
        header,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
