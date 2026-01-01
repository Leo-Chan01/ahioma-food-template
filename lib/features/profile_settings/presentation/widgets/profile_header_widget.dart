import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({
    required this.name,
    required this.phone,
    this.profileImageUrl,
    this.onEditPressed,
    super.key,
  });

  final String name;
  final String phone;
  final String? profileImageUrl;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          // Profile picture with edit button
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: profileImageUrl != null
                      ? Image.network(
                          profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar(theme);
                          },
                        )
                      : _buildDefaultAvatar(theme),
                ),
              ),
              // Edit button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditPressed,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 3,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AppIcons.edit(
                        color: theme.colorScheme.surface,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            name,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Phone number
          Text(
            phone,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: AppIcons.profile(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          size: 60,
        ),
      ),
    );
  }
}
