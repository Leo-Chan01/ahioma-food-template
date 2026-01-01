import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/core/utils/strings/orders_strings.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';
import 'package:ahioma_food_template/shared/widgets/primary_button.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    required this.order,
    required this.onActionPressed,
    required this.actionLabel,
    super.key,
  });

  final OrderEntity order;
  final VoidCallback onActionPressed;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: order.productImage,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_outlined,
                    size: 40,
                  ),
                ),
              ),
            ),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  // Product Name
                  Text(
                    order.productName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Color, Size, Qty
                  Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedCircle,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.color,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                        child: VerticalDivider(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                          thickness: 1,
                          width: 16,
                        ),
                      ),
                      Text(
                        '${OrdersStrings.size} = ${order.size}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                        child: VerticalDivider(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                          thickness: 1,
                          width: 16,
                        ),
                      ),
                      Text(
                        '${OrdersStrings.qty} = ${order.quantity}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Price and Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.price.toNGN(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PrimaryButton(
                        onPressed: onActionPressed,
                        label: actionLabel,
                        borderRadius: 100,
                        height: 36,
                        backgroundColor: theme.colorScheme.onSurface,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
