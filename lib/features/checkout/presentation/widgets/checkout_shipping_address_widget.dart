import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';
import 'package:ahioma_food_template/features/checkout/data/models/shipping_address_model.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/shipping_address_screen.dart';

class CheckoutShippingAddressWidget extends StatelessWidget {
  const CheckoutShippingAddressWidget({
    required this.selectedAddress,
    this.onAddressChanged,
    super.key,
  });

  final ShippingAddressModel? selectedAddress;
  final ValueChanged<ShippingAddressModel>? onAddressChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CheckoutStrings.shippingAddress,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final result = await context.push<ShippingAddressModel?>(
              ShippingAddressScreen.path,
            );
            if (result != null && onAddressChanged != null) {
              onAddressChanged!(result);
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
                    child: AppIcons.location(
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedAddress?.label ?? 'Select Address',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedAddress?.address ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppIcons.edit(
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
