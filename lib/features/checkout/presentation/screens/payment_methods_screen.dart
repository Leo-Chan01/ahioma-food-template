// ignore_for_file: no_default_cases

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/cart/data/models/cart/cart_item_model.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/checkout/data/data_sources/local/checkout_local_source.dart';
import 'package:ahioma_food_template/features/checkout/data/models/checkout_data.dart';
import 'package:ahioma_food_template/features/checkout/data/models/payment_method_model.dart';
import 'package:ahioma_food_template/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/enter_pin_screen.dart';
import 'package:ahioma_food_template/features/checkout/presentation/widgets/order_success_dialog.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/repository/orders_repository.dart';
import 'package:ahioma_food_template/injection_container.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:provider/provider.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  static const String path = '/payment-methods';
  static const String name = 'payment-methods';

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  PaystackTransactionVerified? transactionProcessResponse;
  final CheckoutLocalSource _localSource = CheckoutLocalSource();
  final OrdersRepository _ordersRepository = sl<OrdersRepository>();
  List<PaymentMethodModel> _methods = [];
  String? _selectedId;
  bool _isLoading = true;
  bool _isCreatingOrder = false;

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  Future<void> _loadMethods() async {
    final methods = await _localSource.getPaymentMethods();
    setState(() {
      _methods = methods;
      _selectedId = methods[1].id; // Default to Wallet
      log('selected id is $_selectedId, type is ${methods[1].type}, ');
      _isLoading = false;
    });
  }

  double _calculateSubtotal(List<CartItemModel> cartItems) {
    if (cartItems.isEmpty) return 0.0;
    return cartItems.fold<double>(0.0, (sum, item) {
      final quantity = item.quantity ?? 1;
      final price = item.price ?? 0.0;
      return sum + (price * quantity);
    });
  }

  Widget _getPaymentIcon(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.wallet:
        return Padding(
          padding: const EdgeInsets.all(8),
          child: AppIcons.wallet(color: Colors.white, size: 24),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8),
          child: AppIcons.creditCard(color: Colors.white, size: 24),
        );
    }
  }

  Future<void> _handleConfirmPayment() async {
    final routerState = GoRouterState.of(context);
    final checkoutData = routerState.extra as CheckoutData?;
    if (checkoutData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checkout data is missing')),
        );
      }
      return;
    }

    // Check if wallet is selected
    final selectedMethod = _methods.firstWhere(
      (method) => method.id == _selectedId,
      orElse: () => _methods.first,
    );

    // Determine payment method type
    final paymentMethodType = selectedMethod.type == PaymentMethodType.wallet
        ? 'WALLET'
        : selectedMethod.type == PaymentMethodType.external
        ? 'BANK_TRANSFER'
        : 'CARD';

    // Update checkout data with selected payment method
    final updatedCheckoutData = CheckoutData(
      shippingAddressId: checkoutData.shippingAddressId,
      paymentMethod: paymentMethodType,
      couponCode: checkoutData.couponCode,
      taxAmount: checkoutData.taxAmount,
      shippingAmount: checkoutData.shippingAmount,
      notes: checkoutData.notes,
    );

    // If wallet, show PIN screen first
    if (selectedMethod.type == PaymentMethodType.wallet) {
      final pinEntered = await context.push<bool>(
        EnterPinScreen.path,
        extra: updatedCheckoutData,
      );
      if (pinEntered == true && mounted) {
        await _createOrder(updatedCheckoutData);
      }
    } else if (selectedMethod.type == PaymentMethodType.external) {
      log('External payment method selected');

      // Get user email from AuthProvider
      final authProvider = context.read<AuthProvider>();
      final userEmail = authProvider.customer?.email;

      if (userEmail == null || userEmail.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User email is required for payment'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Calculate actual total price from cart and checkout data
      final cartProvider = context.read<CartProvider>();
      final cartItems = cartProvider.cartItems ?? [];
      final subtotal = _calculateSubtotal(cartItems);

      // Calculate discount if coupon code exists
      double discountAmount = 0.0;
      if (checkoutData.couponCode != null &&
          checkoutData.couponCode!.isNotEmpty) {
        // Note: This assumes discount was already validated in checkout screen
        // If you need to recalculate, you'd need to call validatePromoCode again
        // For now, we'll use a simple calculation based on the coupon code
        // You may want to store the discount amount in CheckoutData
      }

      final subtotalAfterDiscount = subtotal - discountAmount;
      final taxAmount =
          checkoutData.taxAmount ?? (subtotalAfterDiscount * 0.075);
      final shippingAmount = checkoutData.shippingAmount ?? 500.0;
      final totalPrice = subtotalAfterDiscount + taxAmount + shippingAmount;

      if (kDebugMode) {
        log(
          'Payment calculation: subtotal=$subtotal, discount=$discountAmount, tax=$taxAmount, shipping=$shippingAmount, total=$totalPrice',
        );
      }

      // Generate unique transaction reference using UUID
      final uniqueTransRef =
          DateTime.now().millisecondsSinceEpoch.toString() +
          '_${DateTime.now().microsecondsSinceEpoch}';

      final statusAndResponse = await _makePayment(
        context: context,
        uniqueTransRef: uniqueTransRef,
        secretKey: 'sk_test_e6c1c3469e8cd34431a5e2c9b4c19294b2ed0b9f',
        price: totalPrice,
        email: userEmail,
        checkoutData: updatedCheckoutData,
      );

      if (!mounted) return;

      if (statusAndResponse.$1?.data.status ==
          PaystackTransactionStatus.success) {
        // Payment successful - verify cart has items before creating order
        final cartProvider = context.read<CartProvider>();
        final cartItems = cartProvider.cartItems ?? [];

        if (cartItems.isEmpty) {
          if (mounted) {
            GlobalSnackBar.showError('Cart is empty. Cannot create order.');
          }
          return;
        }

        // Payment successful - create order
        if (kDebugMode) {
          log('Payment successful, creating order with data:');
          log('  shippingAddressId: ${updatedCheckoutData.shippingAddressId}');
          log('  paymentMethod: ${updatedCheckoutData.paymentMethod}');
          log('  cartItems count: ${cartItems.length}');
        }
        await _createOrder(updatedCheckoutData);
      } else {
        GlobalSnackBar.showError(
          statusAndResponse.$1?.data.status.name ?? 'Payment failed',
        );
        return;
      }
    } else {
      // For card, create order directly
      // await _createOrder(updatedCheckoutData);
    }
  }

  Future<void> _createOrder(CheckoutData checkoutData) async {
    if (!mounted) return;

    setState(() {
      _isCreatingOrder = true;
    });

    try {
      // Validate required fields before creating order
      if (checkoutData.shippingAddressId.isEmpty) {
        throw Exception('Shipping address is required');
      }

      if (kDebugMode) {
        log('Creating order with:');
        log('  shippingAddressId: ${checkoutData.shippingAddressId}');
        log('  paymentMethod: ${checkoutData.paymentMethod}');
        log('  couponCode: ${checkoutData.couponCode}');
        log('  taxAmount: ${checkoutData.taxAmount}');
        log('  shippingAmount: ${checkoutData.shippingAmount}');
        log('  notes: ${checkoutData.notes}');
      }

      final request = CreateOrderRequestEntity(
        shippingAddressId: checkoutData.shippingAddressId,
        couponCode: checkoutData.couponCode,
        paymentMethod: checkoutData.paymentMethod,
        taxAmount: checkoutData.taxAmount,
        shippingAmount: checkoutData.shippingAmount,
        notes: checkoutData.notes,
        // branchId is not included as requested
      );

      final orderResponse = await _ordersRepository.createOrder(request);

      if (kDebugMode) {
        log(
          'Order created successfully: ${orderResponse.orderNumber ?? orderResponse.id}',
        );
      }

      // Clear cart after successful order
      if (mounted) {
        final cartProvider = context.read<CartProvider>();
        await cartProvider.clearCart();
      }

      // Show success dialog
      if (mounted) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const OrderSuccessDialog(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create order: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          CheckoutStrings.paymentMethods,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            // fontSize: 50,
          ),
        ),
        actions: [
          IconButton(
            icon: AppIcons.addition(color: theme.colorScheme.onSurface),
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) => AlertDialog.adaptive(
                  title: Text('Coming soon'),
                  content: Text('This feature is coming soon'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      CheckoutStrings.selectPaymentMethod,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _methods.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final method = _methods[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RadioListTile<String>(
                            value: method.id,
                            groupValue: _selectedId,
                            onChanged: (value) {
                              setState(() {
                                _selectedId = value;
                              });
                            },
                            title: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: _getPaymentIcon(method.type),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        method.name,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      if (method.balance != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          method.balance!.toNaira(),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.6),
                                              ),
                                        ),
                                      ],
                                      if (method.cardNumber != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          method.cardNumber!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.6),
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isCreatingOrder
                            ? null
                            : _handleConfirmPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isCreatingOrder
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                CheckoutStrings.confirmPayment,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Future<void> _beginPaystackPayment(
  //   BuildContext context, {
  //   required CheckoutData checkoutData,
  //   required double amount,
  // }) async {
  //   // final uniqueTransRef = PayWithPayStack().generateUuidV4();
  //   final uniqueTransRef = DateTime.now().millisecondsSinceEpoch.toString();
  //   final customer = context.read<AuthProvider>();
  //   final paystack = PayWithPayStack().now(
  //     context: context,
  //     secretKey: "sk_test_e6c1c3469e8cd34431a5e2c9b4c19294b2ed0b9f",
  //     customerEmail: customer.customer?.email ?? '',
  //     reference: uniqueTransRef,
  //     currency: "NGN",
  //     amount: amount,
  //     callbackUrl: "https://google.com",
  //     transactionCompleted: (paymentData) async {
  //       if (kDebugMode) log('payment data is $paymentData');
  //       await _createOrder(checkoutData);
  //     },
  //     transactionNotCompleted: (reason) {
  //       debugPrint("==> Transaction failed reason $reason");
  //     },
  //   );
  // }

  // Future<T?> showBlurredPaymentModal<T>({
  //   required BuildContext context,
  //   required double height,
  //   required PaystackInitializedTraction initializedTransaction,
  //   required String secretKey,
  // }) {
  //   return showAdaptiveDialog<T>(
  //     context: context,
  //     barrierColor: Colors.black.withValues(alpha: 0.3),
  //     builder: (context) {
  //       return BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
  //         child: Center(
  //           child: SizedBox(
  //             height: height,
  //             child: Material(
  //               color: Colors.transparent,
  //               child: Builder(
  //                 builder: (context) {
  //                   PaymentService.showPaymentModal(
  //                     context,
  //                     transaction: initializedTransaction,
  //                     backgroundColor: AppColor.white,
  //                     callbackUrl: 'https://google.com',
  //                   );
  //                   return const SizedBox.shrink();
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<(PaystackTransactionVerified?, PaystackTransactionStatus)>
  _makePayment({
    required BuildContext context,
    required String uniqueTransRef,
    required String secretKey,
    required double price,
    required String email,
    CheckoutData? checkoutData,
  }) async {
    final request = PaystackTransactionRequest(
      reference: uniqueTransRef,
      secretKey: secretKey,
      email: email,
      amount: price * 100,
      currency: PaystackCurrency.ngn,
      channel: [
        PaystackPaymentChannel.mobileMoney,
        PaystackPaymentChannel.card,
        PaystackPaymentChannel.ussd,
        PaystackPaymentChannel.bankTransfer,
        PaystackPaymentChannel.bank,
        PaystackPaymentChannel.qr,
        PaystackPaymentChannel.eft,
      ],
    );

    final initializedTransaction = await PaymentService.initializeTransaction(
      request,
    );

    if (!initializedTransaction.status) {
      if (!context.mounted) return (null, PaystackTransactionStatus.failed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(initializedTransaction.message),
        ),
      );
      return (null, PaystackTransactionStatus.failed);
    }

    if (!context.mounted) return (null, PaystackTransactionStatus.failed);

    // Show payment modal - it will close automatically when payment is completed
    await PaymentService.showPaymentModal(
      context,
      transaction: initializedTransaction,
      backgroundColor: Colors.white,
      callbackUrl: 'https://google.com',
    );

    // Verify the transaction after modal closes
    if (!context.mounted) return (null, PaystackTransactionStatus.failed);

    final response = await PaymentService.verifyTransaction(
      paystackSecretKey: secretKey,
      initializedTransaction.data?.reference ?? request.reference,
    );

    if (kDebugMode) {
      log('Payment verification response: ${response.data.status}');
      log(
        'Transaction reference: ${initializedTransaction.data?.reference ?? request.reference}',
      );
    }

    setState(() {
      transactionProcessResponse = response;
    });

    // If payment was successful, the modal should have closed automatically
    // If payment failed, we return the failed status
    return (transactionProcessResponse, response.data.status);
  }
}
