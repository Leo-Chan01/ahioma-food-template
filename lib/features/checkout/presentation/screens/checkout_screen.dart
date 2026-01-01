import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/cart/data/models/cart/cart_item_model.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/checkout/data/models/checkout_data.dart';
import 'package:ahioma_food_template/features/checkout/data/models/shipping_address_model.dart';
// import 'package:ahioma_food_template/features/checkout/data/models/shipping_option_model.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/payment_methods_screen.dart';
import 'package:ahioma_food_template/features/checkout/presentation/widgets/checkout_order_item_widget.dart';
import 'package:ahioma_food_template/features/checkout/presentation/widgets/checkout_promo_code_widget.dart';
import 'package:ahioma_food_template/features/checkout/presentation/widgets/checkout_shipping_address_widget.dart';
// import 'package:ahioma_food_template/features/checkout/presentation/widgets/checkout_shipping_option_widget.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  static const String path = '/checkout';
  static const String name = 'checkout';

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  ShippingAddressModel? _selectedAddress;
  // ShippingOptionModel? _selectedShipping;
  String? _selectedPromoCode;
  int? _promoDiscount;
  bool _isLoadingAddresses = true;
  double _shippingCost = 0;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadShippingAddresses();
    // Ensure cart items are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = context.read<CartProvider>();
      if (cartProvider.cartItems == null || cartProvider.cartItems!.isEmpty) {
        cartProvider.loadCartItems();
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadShippingAddresses() async {
    try {
      final authProvider = context.read<AuthProvider>();
      // Ensure profile is loaded
      await authProvider.fetchCustomerProfile(forceRefresh: false);

      if (mounted) {
        final customer = authProvider.customer;
        final addresses = customer?.addresses;

        setState(() {
          if (addresses != null && addresses.isNotEmpty) {
            // Convert AddAddressResponseModel to ShippingAddressModel
            final shippingAddresses = addresses
                .map(
                  (addr) => ShippingAddressModel.fromAddAddressResponse(addr),
                )
                .toList();

            // Set default address if available
            _selectedAddress = shippingAddresses.firstWhere(
              (address) => address.isDefault == true,
              orElse: () => shippingAddresses.first,
            );
          }
          _isLoadingAddresses = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAddresses = false;
        });
      }
    }
  }

  double _calculateSubtotal(List<CartItemModel>? cartItems) {
    if (cartItems == null || cartItems.isEmpty) return 0.0;
    return cartItems.fold<double>(0.0, (sum, item) {
      final quantity = item.quantity ?? 1;
      final price = item.price ?? 0.0;
      return sum + (price * quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cartItems ?? [];
    final subtotal = _calculateSubtotal(cartItems);
    final discountAmount = _promoDiscount != null
        ? (subtotal * _promoDiscount! / 100)
        : 0.0;
    final subtotalAfterDiscount = subtotal - discountAmount;
    // Calculate 7.5% VAT on subtotal after discount
    final taxAmount = subtotalAfterDiscount * 0.075;
    // Calculate shipping cost (default 500 NGN, can be made dynamic later)
    final shippingAmount = _shippingCost > 0 ? _shippingCost : 500.0;
    final finalTotal = subtotalAfterDiscount + taxAmount + shippingAmount;

    // Show loading indicator if cart is loading
    if (cartProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            CheckoutStrings.checkout,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          CheckoutStrings.checkout,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: AppIcons.moreVertical(color: theme.colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Address
                    if (_isLoadingAddresses)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    else
                      CheckoutShippingAddressWidget(
                        selectedAddress: _selectedAddress,
                        onAddressChanged: (address) {
                          setState(() {
                            _selectedAddress = address;
                          });
                        },
                      ),
                    const SizedBox(height: 24),

                    // Order List
                    Text(
                      CheckoutStrings.orderList,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (cartItems.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No items in cart',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: cartItems.map((item) {
                          return CheckoutOrderItemWidget(cartItem: item);
                        }).toList(),
                      ),

                    // // Shipping Option
                    // const SizedBox(height: 24),
                    // CheckoutShippingOptionWidget(
                    //   selectedShipping: _selectedShipping,
                    //   onShippingChanged: (shipping) {
                    //     setState(() {
                    //       _selectedShipping = shipping;
                    //       _shippingCost = shipping.price;
                    //     });
                    //   },
                    // ),
                    const SizedBox(height: 24),

                    // Promo Code
                    CheckoutPromoCodeWidget(
                      selectedPromoCode: _selectedPromoCode,
                      cartTotal: subtotal,
                      onPromoCodeChanged: (result) {
                        setState(() {
                          if (result.isValid) {
                            _selectedPromoCode = result.code;
                            // Calculate discount based on validation result
                            if (result.discountType == 'PERCENTAGE' &&
                                result.discountAmount != null) {
                              _promoDiscount = result.discountAmount;
                            } else if (result.discountType == 'FIXED' &&
                                result.discountAmount != null &&
                                subtotal > 0) {
                              // For fixed amount, calculate percentage
                              _promoDiscount =
                                  ((result.discountAmount! / subtotal) * 100)
                                      .round();
                            } else {
                              _promoDiscount = null;
                            }
                          } else {
                            _selectedPromoCode = null;
                            _promoDiscount = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Notes Field
                    Text(
                      'Order Notes (Optional)',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add any special instructions...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Order Summary
                    Text(
                      CheckoutStrings.orderSummary,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CheckoutStrings.amount,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  subtotal.toNaira(),
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tax (VAT 7.5%)',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  taxAmount.toNaira(),
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CheckoutStrings.shipping,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  shippingAmount.toNaira(),
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            if (_promoDiscount != null) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discount (${_promoDiscount!}%)',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                    ),
                                  ),
                                  Text(
                                    '-${discountAmount.toNaira()}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CheckoutStrings.total,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  finalTotal.toNaira(),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cartItems.isEmpty || _selectedAddress == null
                      ? null
                      : () {
                          final subtotal = _calculateSubtotal(cartItems);
                          final discountAmount = _promoDiscount != null
                              ? (subtotal * _promoDiscount! / 100)
                              : 0.0;
                          final subtotalAfterDiscount =
                              subtotal - discountAmount;
                          final calculatedTaxAmount =
                              subtotalAfterDiscount * 0.075;
                          final calculatedShippingAmount = _shippingCost > 0
                              ? _shippingCost
                              : 500.0;

                          final checkoutData = CheckoutData(
                            shippingAddressId: _selectedAddress!.id,
                            paymentMethod:
                                'CARD', // Will be updated in payment screen
                            couponCode: _selectedPromoCode,
                            shippingAmount: calculatedShippingAmount,
                            taxAmount: calculatedTaxAmount,
                            notes: _notesController.text.trim().isEmpty
                                ? null
                                : _notesController.text.trim(),
                          );
                          context.push(
                            PaymentMethodsScreen.path,
                            extra: checkoutData,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        CheckoutStrings.continueToPayment,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppIcons.arrowForward(color: theme.colorScheme.onPrimary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
