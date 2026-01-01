import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/wishlist_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/login_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/widgets/wishlist_category_filter_widget.dart';
import 'package:ahioma_food_template/features/home/presentation/widgets/wishlist_empty_state_widget.dart';
import 'package:ahioma_food_template/features/home/presentation/widgets/wishlist_product_card_widget.dart';
import 'package:ahioma_food_template/features/products/presentation/screens/product_detail_screen.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/screens/search_screen.dart';
import 'package:ahioma_food_template/features/wishlist/presentation/provider/wishlist_provider.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  static const String path = '/wishlist';
  static const String name = 'wishlist';

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _selectedCategory = WishlistStrings.all;
  List<String> _categories = [WishlistStrings.all];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthenticationAndLoadWishlist();
    });
  }

  Future<void> _checkAuthenticationAndLoadWishlist() async {
    final authProvider = context.read<AuthProvider>();
    final wishlistProvider = context.read<WishlistProvider>();

    // Check if user is authenticated
    if (!authProvider.isAuthenticated) {
      if (mounted) {
        // Redirect to login with redirect path
        GlobalSnackBar.showInfo('Please login to view your wishlist');
        context.pushNamed(LoginScreen.name, extra: WishlistScreen.path);
      }
      return;
    }

    // Load wishlist if not already loaded
    if (wishlistProvider.wishlistProductIds.isEmpty &&
        !wishlistProvider.isLoading) {
      await wishlistProvider.loadWishlist();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          WishlistStrings.myWishlist,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.search(color: theme.colorScheme.onSurface),
            onPressed: () {
              context.push(SearchScreen.getRoutePath(SearchMode.products));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filters (only show if there are categories beyond "All")
          if (_categories.length > 1)
            WishlistCategoryFilterWidget(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          // Product grid
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  /// Helper method to extract category name from category field
  /// Handles both String and Map cases
  String? _extractCategoryName(dynamic category) {
    if (category == null) return null;

    // If it's already a String, return it
    if (category is String) {
      return category.isNotEmpty ? category : null;
    }

    // If it's a Map, extract the 'name' field
    if (category is Map) {
      try {
        // Access the 'name' key from the Map
        final nameValue = category['name'];
        if (nameValue != null) {
          final nameString = nameValue.toString();
          return nameString.isNotEmpty ? nameString : null;
        }
      } catch (e) {
        // If extraction fails, return null
        return null;
      }
    }

    return null;
  }

  void _updateCategoriesFromProducts(List<dynamic> products) {
    // Extract unique categories from products
    final categoriesSet = <String>{};
    for (final product in products) {
      final categoryName = _extractCategoryName(product.category);
      if (categoryName != null && categoryName.isNotEmpty) {
        categoriesSet.add(categoryName);
      }
    }

    // Sort categories alphabetically and add "All" at the beginning
    final sortedCategories = categoriesSet.toList()..sort();
    final newCategories = [WishlistStrings.all, ...sortedCategories];

    // Only update if categories changed
    if (newCategories.length != _categories.length ||
        !newCategories.every((cat) => _categories.contains(cat))) {
      setState(() {
        _categories = newCategories;
        // Reset to "All" if current selection is no longer available
        if (!_categories.contains(_selectedCategory)) {
          _selectedCategory = WishlistStrings.all;
        }
      });
    }
  }

  Widget _buildBody() {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, _) {
        final products = wishlistProvider.wishlistProducts;
        final isLoading = wishlistProvider.isLoading;
        final errorMessage = wishlistProvider.errorMessage;

        // Update categories from products when they change
        if (products.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateCategoriesFromProducts(products);
          });
        }

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    wishlistProvider.loadWishlist();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Filter products by category
        final filteredProducts = _selectedCategory == WishlistStrings.all
            ? products
            : products.where((product) {
                final categoryName = _extractCategoryName(product.category);
                return categoryName == _selectedCategory;
              }).toList();

        if (filteredProducts.isEmpty) {
          return const WishlistEmptyStateWidget();
        }

        return MasonryGridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            final productId = product.id;
            final productName = product.name;
            final productPrice = product.price;
            final productRating = product.rating ?? 0.0;
            final productSoldCount = product.soldCount;
            final productImages = product.images;
            final productImageUrl = productImages.isNotEmpty
                ? productImages.first
                : '';

            return WishlistProductCardWidget(
              imageUrl: productImageUrl,
              name: productName,
              price: productPrice,
              rating: productRating,
              soldCount: productSoldCount,
              onTap: () {
                context.push(
                  ProductDetailScreen.getRoutePath(product.slug),
                  extra: ProductDetailData(
                    id: productId,
                    name: productName,
                    price: productPrice,
                    rating: productRating,
                    reviewCount: product.reviewCount,
                    soldCount: productSoldCount,
                    images: productImages,
                    description: product.description ?? '',
                  ),
                );
              },
              onRemove: () {
                wishlistProvider.removeFromWishlist(productId);
              },
            );
          },
        );
      },
    );
  }
}
