import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/l10n/l10n.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.soldCount,
    required this.productId,
    this.onTap,
    this.onAddToCart,
    super.key,
  });

  final String imageUrl;
  final String name;
  final double price;
  final double rating;
  final int soldCount;
  final String productId;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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

    // Call optional callback
    widget.onAddToCart?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with add to cart button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: _isAdding
                          ? null
                          : () => _handleAddToCart(context),
                      icon: _isAdding
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : AppIcons.cart(
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                      iconSize: 20,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      tooltip: context.l10n.homeAddToCart,
                    ),
                  ),
                ),
              ],
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Rating and sold count
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        widget.rating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '|',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          context.l10n.homeSoldCount(widget.soldCount),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text.rich(
                    widget.price.toNairaTextSpan(
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
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
