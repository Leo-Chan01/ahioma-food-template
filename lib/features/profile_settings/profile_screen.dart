import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/common_strings.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/authentication/data/models/customer_model.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/home/home_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/domain/entities/profile_menu_item_entity.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/address_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/edit_profile_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/help_center_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/invite_friends_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/language_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/notification_settings_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/payment_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/privacy_policy_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/security_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/profile_header_widget.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/profile_menu_list_widget.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:ahioma_food_template/shared/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String path = '/profile';
  static const String name = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoadingProfile = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadProfile());
  }

  Future<void> _loadProfile() async {
    final authProvider = context.read<AuthProvider>();
    if (_isLoadingProfile) return;
    setState(() {
      _isLoadingProfile = true;
    });
    await authProvider.fetchCustomerProfile(forceRefresh: true);
    if (!mounted) return;
    setState(() {
      _isLoadingProfile = false;
    });
  }

  List<ProfileMenuItemEntity> _buildMenuItems(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDark(context);

    return [
      ProfileMenuItemEntity(
        id: 'edit_profile',
        title: ProfileStrings.editProfile,
        iconBuilder: () => AppIcons.editProfile(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(
            context.push(EditProfileScreen.path).then((_) async {
              if (mounted) {
                await _loadProfile();
              }
            }),
          );
        },
      ),
      ProfileMenuItemEntity(
        id: 'address',
        title: ProfileStrings.address,
        iconBuilder: () => AppIcons.location(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(context.push(AddressScreen.path));
        },
      ),
      ProfileMenuItemEntity(
        id: 'notification',
        title: ProfileStrings.notification,
        iconBuilder: () => AppIcons.notification(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(context.push(NotificationSettingsScreen.path));
        },
      ),
      ProfileMenuItemEntity(
        id: 'payment',
        title: ProfileStrings.payment,
        iconBuilder: () => AppIcons.wallet(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(context.push(PaymentScreen.path));
        },
      ),
      ProfileMenuItemEntity(
        id: 'security',
        title: ProfileStrings.security,
        iconBuilder: () => AppIcons.security(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(context.push(SecurityScreen.path));
        },
      ),
      ProfileMenuItemEntity(
        id: 'language',
        title: ProfileStrings.language,
        subtitle: ProfileStrings.englishUS,
        iconBuilder: () => AppIcons.language(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(context.push(LanguageScreen.path));
        },
      ),
      ProfileMenuItemEntity(
        id: 'dark_mode',
        title: ProfileStrings.darkMode,
        iconBuilder: () => AppIcons.darkMode(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.toggle,
        isToggleOn: isDark,
        onToggleChanged: (value) {
          unawaited(themeProvider.toggleTheme());
        },
      ),
      ProfileMenuItemEntity(
        id: 'privacy',
        title: ProfileStrings.privacyPolicy,
        iconBuilder: () => AppIcons.privacy(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(context.push(PrivacyPolicyScreen.path));
        },
      ),
      ProfileMenuItemEntity(
        id: 'help',
        title: ProfileStrings.helpCenter,
        iconBuilder: () => AppIcons.help(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(context.push(HelpCenterScreen.path));
        },
      ),
      ProfileMenuItemEntity(
        id: 'invite',
        title: ProfileStrings.inviteFriends,
        iconBuilder: () => AppIcons.inviteFriends(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        type: ProfileMenuItemType.navigation,
        onTap: () {
          unawaited(context.push(InviteFriendsScreen.path));
        },
      ),
      ProfileMenuItemEntity(
        id: 'logout',
        title: ProfileStrings.logout,
        iconBuilder: () => AppIcons.logout(
          color: Theme.of(context).colorScheme.error,
        ),
        type: ProfileMenuItemType.action,
        isDestructive: true,
        onTap: _handleLogout,
      ),
    ];
  }

  void _handleLogout() {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(ProfileStrings.logout),
          content: const Text(ProfileStrings.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(CommonStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // GlobalSnackBar.showInfo(ProfileStrings.logoutComingSoon);
                await context.read<AuthProvider>().logout().whenComplete(() {
                  context.goNamed(HomeScreen.name);
                  GlobalSnackBar.showSuccess(
                    ProfileStrings.loggedOutSuccessfully,
                  );
                });
              },
              child: Text(
                ProfileStrings.logout,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AppIcons.profile(
              color: theme.colorScheme.onSurface,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              ProfileStrings.profile,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: AppIcons.moreVertical(
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              // TODO(ahioma): Implement more options.
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, child) {
          final customer = authProvider.customer;
          final displayName = _buildDisplayName(customer);
          final phoneNumber = _buildPhoneNumber(customer);
          final avatarUrl = customer?.avatarUrl;

          return RefreshIndicator(
            onRefresh: _loadProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  if (_isLoadingProfile && customer == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  if (!_isLoadingProfile || customer != null)
                    ProfileHeaderWidget(
                      name: displayName,
                      phone: phoneNumber,
                      profileImageUrl: avatarUrl,
                      onEditPressed: () {
                        unawaited(
                          context.push(EditProfileScreen.path).then((_) async {
                            if (mounted) {
                              await _loadProfile();
                            }
                          }),
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                  ProfileMenuListWidget(menuItems: _buildMenuItems(context)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _buildDisplayName(CustomerModel? customer) {
    if (customer == null) return 'Guest Shopper';
    final first = customer.firstName.trim();
    final last = customer.lastName.trim();
    final email = customer.email.trim();
    if (first.isNotEmpty && last.isNotEmpty) {
      return '$first $last';
    }
    if (first.isNotEmpty) {
      return first;
    }
    if (last.isNotEmpty) {
      return last;
    }
    if (email.isNotEmpty) {
      return email;
    }
    return 'Guest Shopper';
  }

  String _buildPhoneNumber(CustomerModel? customer) {
    if (customer == null) return 'Add your phone number';
    final phone = customer.phoneNumber ?? '';
    if (phone.trim().isEmpty) {
      return 'Add your phone number';
    }
    return phone;
  }
}
