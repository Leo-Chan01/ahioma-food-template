import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/core/utils/strings/cart_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/login_screen.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/screens/search_screen.dart';
import 'package:ahioma_food_template/shared/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const String path = '/cart';
  static const String name = 'cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          CartStrings.cartTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: AppIcons.search(color: theme.colorScheme.onSurface),
            onPressed: () {
              context.push(SearchScreen.getRoutePath(SearchMode.products));
            },
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 16),
      ),
      body: context.watch<CartProvider>().isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _buildCartBody(context, theme),
    );
  }

  Widget _buildCartBody(BuildContext context, ThemeData theme) {
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cartItems ?? [];

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: _loadCartItems,
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcons.shoppingBag(
                          size: 64,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items to get started',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox.shrink(),
                    itemBuilder: (context, index) {
                      return CartItemWidget(cartItem: cartItems[index]);
                    },
                  ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CartStrings.totalPrice,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          context
                              .watch<CartProvider>()
                              .totalPrice
                              .toNairaTextSpan(
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: PrimaryButton(
                      elevation: 0,
                      onPressed: () {
                        context.read<AuthProvider>().isAuthenticated
                            ? context.push(CheckoutScreen.path)
                            : context.pushNamed(
                                LoginScreen.name,
                                extra: CheckoutScreen.path,
                              );
                      },
                      height: 48,
                      borderRadius: 100,
                      iconWidget: AppIcons.arrowForward(
                        color: theme.colorScheme.onPrimary,
                        size: 18,
                      ),
                      isEnabled: context.watch<CartProvider>().totalPrice > 0,
                      iconPosition: IconPosition.trailing,
                      label: CartStrings.checkout,
                      fontWeight: FontWeight.bold,
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loadCartItems() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.loadCartItems();
  }
}
