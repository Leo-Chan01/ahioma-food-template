import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/core/utils/strings/orders_strings.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/review_entity.dart';
import 'package:ahioma_food_template/features/orders/presentation/provider/orders_provider.dart';
import 'package:ahioma_food_template/features/orders/presentation/widgets/star_rating_widget.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:ahioma_food_template/shared/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LeaveReviewScreen extends StatefulWidget {
  const LeaveReviewScreen({
    required this.order,
    super.key,
  });

  static const String path = '/leave-review';
  static const String name = 'leave-review';

  final OrderEntity order;

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      GlobalSnackBar.showWarning('Please select a rating');
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      GlobalSnackBar.showWarning('Please write a review');
      return;
    }

    final review = ReviewEntity(
      orderId: widget.order.id,
      rating: _rating,
      comment: _reviewController.text.trim(),
    );

    await context.read<OrdersProvider>().submitReview(review);

    if (mounted) {
      GlobalSnackBar.showSuccess('Review submitted successfully');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          OrdersStrings.leaveReview,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Product Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.order.productImage,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_outlined,
                    size: 60,
                    color: theme.colorScheme.surface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Product Name
            Text(
              widget.order.productName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Product Details
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCircle,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  size: 10,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.order.color,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(
                  height: 10,
                  child: VerticalDivider(
                    color: theme.colorScheme.surface.withValues(alpha: 0.3),
                    thickness: 1,
                    width: 16,
                  ),
                ),
                Text(
                  '${OrdersStrings.size} = ${widget.order.size}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(
                  height: 10,
                  child: VerticalDivider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    thickness: 1,
                    width: 16,
                  ),
                ),
                Text(
                  '${OrdersStrings.qty} = ${widget.order.quantity}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Price
            Text(
              widget.order.price.toNGN(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 40),
            // How is your order?
            Text(
              OrdersStrings.howIsYourOrder,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              OrdersStrings.pleaseGiveRatingAndReview,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Star Rating
            StarRatingWidget(
              onRatingChanged: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 40),
            // Review Text Field
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: OrdersStrings.writeReviewHint,
                  border: InputBorder.none,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 40),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => context.pop(),
                      label: OrdersStrings.cancel,
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.onSurface,
                      borderRadius: 100,
                      height: 52,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Consumer<OrdersProvider>(
                      builder: (context, provider, child) {
                        return PrimaryButton(
                          onPressed: provider.isLoading ? null : _submitReview,
                          label: OrdersStrings.submit,
                          backgroundColor: theme.colorScheme.surface,
                          foregroundColor: theme.colorScheme.onSurface,
                          borderRadius: 100,
                          height: 52,
                          fontWeight: FontWeight.bold,
                          isLoading: provider.isLoading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
