import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';
import 'package:ahioma_food_template/features/checkout/data/models/shipping_option_model.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/choose_shipping_screen.dart';

class CheckoutShippingOptionWidget extends StatelessWidget {
  const CheckoutShippingOptionWidget({
    required this.selectedShipping,
    this.onShippingChanged,
    super.key,
  });

  final ShippingOptionModel? selectedShipping;
  final ValueChanged<ShippingOptionModel>? onShippingChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CheckoutStrings.chooseShipping,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final result = await context.push<ShippingOptionModel?>(
              ChooseShippingScreen.path,
            );
            if (result != null && onShippingChanged != null) {
              onShippingChanged!(result);
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: AppIcons.truck(
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedShipping?.name ??
                          CheckoutStrings.chooseShippingType,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AppIcons.arrowRight(
                    color: theme.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
