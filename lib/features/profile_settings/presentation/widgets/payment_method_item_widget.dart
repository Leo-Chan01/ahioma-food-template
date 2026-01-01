import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/payment_screen.dart';

class PaymentMethodItemWidget extends StatelessWidget {
  const PaymentMethodItemWidget({
    required this.paymentMethod,
    super.key,
  });

  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Payment Method Icon/Logo
            _buildPaymentIcon(context, paymentMethod.type),
            const SizedBox(width: 16),
            // Payment Method Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentMethod.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (paymentMethod.cardLastFour != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '.... .... .... ${paymentMethod.cardLastFour}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Connected Status
            Text(
              ProfileStrings.connected,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(BuildContext context, PaymentMethodType type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (type) {
      case PaymentMethodType.paypal:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF0070BA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'P',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        );
      case PaymentMethodType.googlePay:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Center(
            child: Text(
              'G',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        );
      case PaymentMethodType.applePay:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(
              Icons.apple,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      case PaymentMethodType.card:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: AppIcons.creditCard(
            color: colorScheme.onSurface,
            size: 24,
          ),
        );
    }
  }
}
