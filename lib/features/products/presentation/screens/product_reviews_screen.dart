import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/review_strings.dart';
import 'package:ahioma_food_template/features/products/data/models/review_model.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/screens/search_screen.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({
    this.productId,
    super.key,
  });

  static const String path = '/product/:id/reviews';
  static const String name = 'product-reviews';

  final String? productId;

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();

  static String getRoutePath(String productId) => '/product/$productId/reviews';
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  String _selectedFilter = ReviewStrings.all;
  final List<String> _filters = [
    ReviewStrings.all,
    ReviewStrings.fiveStars,
    ReviewStrings.fourStars,
    ReviewStrings.threeStars,
    ReviewStrings.twoStars,
  ];

  // Mock reviews data
  final List<ReviewModel> _reviews = [
    const ReviewModel(
      id: '1',
      userName: 'Darlene Robertson',
      userImageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 5,
      comment:
          'The item is very good, my son likes it very much and plays every day 💯 💯 💯',
      likeCount: 729,
      timeAgo: '6 days ago',
    ),
    const ReviewModel(
      id: '2',
      userName: 'Jane Cooper',
      userImageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 4,
      comment:
          'The seller is very fast in sending packet, I just bought it and the item arrived in just 1 day! 👍 👍',
      likeCount: 625,
      timeAgo: '6 days ago',
    ),
    const ReviewModel(
      id: '3',
      userName: 'Jenny Wilson',
      userImageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      rating: 4,
      comment:
          'I just bought it and the stuff is really good! I highly recommend it! 😁 😁',
      likeCount: 578,
      timeAgo: '6 days ago',
    ),
    const ReviewModel(
      id: '4',
      userName: 'Marvin McKinney',
      userImageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      rating: 5,
      comment:
          'The item is very good, my son likes it very much and plays every day 💯 💯 💯',
      likeCount: 347,
      timeAgo: '6 weeks ago',
    ),
  ];

  List<ReviewModel> get _filteredReviews {
    if (_selectedFilter == ReviewStrings.all) {
      return _reviews;
    }
    final rating = int.tryParse(_selectedFilter);
    if (rating == null) return _reviews;
    return _reviews.where((r) => r.rating == rating).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredReviews = _filteredReviews;
    final averageRating = _reviews.isEmpty
        ? 0.0
        : _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
              _reviews.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.star(color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              '${averageRating.toStringAsFixed(1)} (${_reviews.length} ${ReviewStrings.reviews.toLowerCase()})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.search(color: theme.colorScheme.onSurface),
            onPressed: () {
              context.push(
                SearchScreen.getRoutePath(SearchMode.products),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcons.star(
                          color: isSelected ? Colors.white : Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          filter == ReviewStrings.all
                              ? ReviewStrings.all
                              : filter,
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: theme.colorScheme.onSurface,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          // Reviews list
          Expanded(
            child: filteredReviews.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcons.star(
                          size: 64,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          ReviewStrings.noReviews,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ReviewStrings.beFirstToReview,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      return _buildReviewItem(context, review, theme);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    ReviewModel review,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          CircleAvatar(
            radius: 24,
            backgroundImage: CachedNetworkImageProvider(review.userImageUrl),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 12),
          // Review content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.userName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcons.star(color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            review.rating.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: AppIcons.moreVertical(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // TODO: Show review options
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review.comment,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: AppIcons.favorite(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        size: 16,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // TODO: Like review
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${review.likeCount}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      review.timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
