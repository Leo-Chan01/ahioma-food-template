import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  static const String path = '/profile/security';
  static const String name = 'security';

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _rememberMe = true;
  bool _faceID = false;
  bool _biometricID = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          ProfileStrings.security,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Security Options
            _buildSecurityOption(
              context: context,
              title: ProfileStrings.rememberMe,
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
            _buildSecurityOption(
              context: context,
              title: ProfileStrings.faceID,
              value: _faceID,
              onChanged: (value) {
                setState(() {
                  _faceID = value;
                });
              },
            ),
            _buildSecurityOption(
              context: context,
              title: ProfileStrings.biometricID,
              value: _biometricID,
              onChanged: (value) {
                setState(() {
                  _biometricID = value;
                });
              },
            ),
            _buildNavigationOption(
              context: context,
              title: ProfileStrings.googleAuthenticator,
              onTap: () {
                // TODO: Navigate to Google Authenticator setup
              },
            ),
            const SizedBox(height: 32),
            // Action Buttons
            _buildActionButton(
              context: context,
              title: ProfileStrings.changePIN,
              onPressed: () {
                // TODO: Navigate to Change PIN screen
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context: context,
              title: ProfileStrings.changePassword,
              onPressed: () {
                // TODO: Navigate to Change Password screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationOption({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            AppIcons.arrowRight(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide.none,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
