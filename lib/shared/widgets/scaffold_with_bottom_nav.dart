import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/login_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/profile_screen.dart';
import 'package:ahioma_food_template/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

/// Scaffold with bottom navigation bar for use with GoRouter's ShellRoute
class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  /// Calculate which tab is currently selected based on the current route
  static int _calculateSelectedIndex(BuildContext context) {
    try {
      // Safely get router state - may fail if context is deactivated
      final routerState = GoRouterState.of(context);
      final location = routerState.uri.path;

      if (location.startsWith('/home')) return 0;
      if (location.startsWith('/cart')) return 1;
      if (location.startsWith('/my-orders')) return 2;
      if (location.startsWith('/wallet')) return 3;
      if (location.startsWith('/profile')) return 4;

      return 0; // Default to home
    } catch (e) {
      // If context is deactivated or any error occurs, default to home
      // This can happen during navigation transitions when widgets are being
      // deactivated and reactivated
      return 0;
    }
  }

  /// Navigate to the selected tab
  void _onItemTapped(int index, BuildContext context) {
    try {
      // Safely get router - may fail if context is deactivated
      final router = GoRouter.maybeOf(context);
      if (router == null) {
        return; // Can't navigate if router is not available
      }

      switch (index) {
        case 0:
          router.go('/home');
          return;
        case 1:
          router.go('/cart');
          return;
        case 2:
          router.go('/my-orders');
          return;
        case 3:
          router.go('/wallet');
          return;
        case 4:
          // Safely read provider - may fail if context is deactivated
          try {
            final authProvider = context.read<AuthProvider>();
            if (authProvider.isInitializing) {
              return;
            }
            if (authProvider.isAuthenticated) {
              router.go(ProfileScreen.path);
            } else {
              authProvider.setRedirectAfterLogin(ProfileScreen.path);
              unawaited(
                router.pushNamed(
                  LoginScreen.name,
                  extra: ProfileScreen.path,
                ),
              );
            }
          } catch (e) {
            // If context is deactivated, just navigate to login
            unawaited(
              router.pushNamed(
                LoginScreen.name,
                extra: ProfileScreen.path,
              ),
            );
          }
          return;
        default:
          return;
      }
    } catch (e) {
      // Silently fail if context is deactivated
      // This can happen during navigation transitions
    }
  }
}
