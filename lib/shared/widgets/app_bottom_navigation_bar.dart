import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:provider/provider.dart';

/// Navigation item model for bottom navigation
class NavigationItem {
  const NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final Widget icon;
  final String route;
}

/// Custom bottom navigation bar widget
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final void Function(int) onTap;

  static final List<NavigationItem> items = [
    NavigationItem(
      label: 'Home',
      icon: AppIcons.home(),
      route: '/home',
    ),
    NavigationItem(
      label: 'Cart',
      icon: AppIcons.cart(),
      route: '/cart',
    ),
    NavigationItem(
      label: 'Orders',
      icon: AppIcons.orders(),
      route: '/orders',
    ),
    NavigationItem(
      label: 'Wallet',
      icon: AppIcons.wallet(),
      route: '/wallet',
    ),
    NavigationItem(
      label: 'Profile',
      icon: AppIcons.profile(),
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProvider = context.watch<CartProvider>();
    final cartItemCount = cartProvider.cartItems?.length ?? 0;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      selectedFontSize: 12,
      items: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        // Add badge to cart icon (index 1)
        var icon = item.icon;
        if (index == 1 && cartItemCount > 0) {
          icon = Badge(
            label: Text(
              cartItemCount > 99 ? '99+' : cartItemCount.toString(),
              style: TextStyle(
                color: theme.colorScheme.brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: theme.colorScheme.error,
            child: item.icon,
          );
        }

        return BottomNavigationBarItem(
          icon: icon,
          label: item.label,
        );
      }).toList(),
    );
  }
}
