import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/add_new_card_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/payment_method_item_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  static const String path = '/profile/payment';
  static const String name = 'payment';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: 'paypal',
      name: 'PayPal',
      type: PaymentMethodType.paypal,
      isConnected: true,
    ),
    PaymentMethod(
      id: 'google_pay',
      name: 'Google Pay',
      type: PaymentMethodType.googlePay,
      isConnected: true,
    ),
    PaymentMethod(
      id: 'apple_pay',
      name: 'Apple Pay',
      type: PaymentMethodType.applePay,
      isConnected: true,
    ),
    PaymentMethod(
      id: 'mastercard',
      name: 'Mastercard',
      type: PaymentMethodType.card,
      cardLastFour: '4679',
      isConnected: true,
    ),
  ];

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
          ProfileStrings.payment,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.moreVertical(
              color: colorScheme.onSurface,
            ),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PaymentMethodItemWidget(
                    paymentMethod: _paymentMethods[index],
                  ),
                );
              },
            ),
          ),
          // Add New Card Button
          ElevatedButton(
            onPressed: () {
              context.push(AddNewCardScreen.path);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              ProfileStrings.addNewCardText,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethod {
  PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.isConnected,
    this.cardLastFour,
  });

  final String id;
  final String name;
  final PaymentMethodType type;
  final bool isConnected;
  final String? cardLastFour;
}

enum PaymentMethodType {
  paypal,
  googlePay,
  applePay,
  card,
}
