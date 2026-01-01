import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/l10n/l10n.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:provider/provider.dart';

/// Full-width vertical card for recommended products section
class RecommendedProductCard extends StatefulWidget {
  const RecommendedProductCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.productId,
    this.distance,
    this.onTap,
    this.onAddToCart,
    super.key,
  });

  final String imageUrl;
  final String name;
  final double price;
  final double rating;
  final int reviewCount;
  final String productId;
  final String? distance;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  @override
  State<RecommendedProductCard> createState() => _RecommendedProductCardState();
}

class _RecommendedProductCardState extends State<RecommendedProductCard> {
  bool _isAdding = false;

  Future<void> _handleAddToCart(BuildContext context) async {
    final cartProvider = context.read<CartProvider>();

    setState(() {
      _isAdding = true;
    });

    try {
      await cartProvider.addToCart(widget.productId, quantity: 1);
      if (mounted) {
        GlobalSnackBar.showSuccess('Added to cart');
      }
    } catch (e) {
      if (mounted) {
        GlobalSnackBar.showError('Failed to add to cart');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }

    widget.onAddToCart?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: AppIcons.image(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Distance, rating, and review count
                    Row(
                      children: [
                        if (widget.distance != null) ...[
                          Text(
                            context.l10n.homeDistance(widget.distance!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '|',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '(${widget.reviewCount})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Price and add button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          widget.price.toNairaTextSpan(
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: _isAdding
                                ? null
                                : () => _handleAddToCart(context),
                            icon: _isAdding
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : AppIcons.cart(
                                    color: theme.colorScheme.onPrimary,
                                    size: 18,
                                  ),
                            iconSize: 18,
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                            tooltip: context.l10n.homeAddToCart,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
