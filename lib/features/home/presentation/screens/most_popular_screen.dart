import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_remote_data_source.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/most_popular_strings.dart';
import 'package:ahioma_food_template/core/utils/strings/wishlist_strings.dart';
import 'package:ahioma_food_template/features/home/widgets/filter_chips.dart';
import 'package:ahioma_food_template/features/home/widgets/product_card.dart';
import 'package:ahioma_food_template/features/products/presentation/screens/product_detail_screen.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/screens/search_screen.dart';
import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';
import 'package:ahioma_food_template/injection_container.dart';

class MostPopularScreen extends StatefulWidget {
  const MostPopularScreen({super.key});

  static const String path = '/most-popular';
  static const String name = 'most-popular';

  @override
  State<MostPopularScreen> createState() => _MostPopularScreenState();
}

class _MostPopularScreenState extends State<MostPopularScreen> {
  final StorefrontRemoteDataSource _storefrontDataSource =
      sl<StorefrontRemoteDataSource>();
  List<StorefrontProductModel> _products = [];
  bool _isLoading = true;
  String _selectedFilter = WishlistStrings.all;
  List<String> _filters = [WishlistStrings.all];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _updateFiltersFromProducts(List<StorefrontProductModel> products) {
    // Extract unique categories from products
    final categoriesSet = <String>{};
    for (final product in products) {
      final category = product.category;
      if (category != null && category.isNotEmpty) {
        categoriesSet.add(category);
      }
    }

    // Sort categories alphabetically and add "All" at the beginning
    final sortedCategories = categoriesSet.toList()..sort();
    final newFilters = [WishlistStrings.all, ...sortedCategories];

    // Only update if filters changed
    if (newFilters.length != _filters.length ||
        !newFilters.every((filter) => _filters.contains(filter))) {
      setState(() {
        _filters = newFilters;
        // Reset to "All" if current selection is no longer available
        if (!_filters.contains(_selectedFilter)) {
          _selectedFilter = WishlistStrings.all;
        }
      });
    }
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _storefrontDataSource.getFeaturedProducts(
        limit: 20,
      );

      if (!mounted) return;
      setState(() {
        _products = products;
        _isLoading = false;
      });

      // Update filters from products
      _updateFiltersFromProducts(products);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
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
          MostPopularStrings.mostPopular,
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
          if (_filters.length > 1)
            FilterChips(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterSelected: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
          // Products grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : RefreshIndicator.adaptive(
                    onRefresh: _loadProducts,
                    child: _buildProductsGrid(theme),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(ThemeData theme) {
    // Filter products by selected category
    final filteredProducts = _selectedFilter == WishlistStrings.all
        ? _products
        : _products
              .where((product) => product.category == _selectedFilter)
              .toList();

    if (filteredProducts.isEmpty) {
      return Center(
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
              'No products available',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        final imageUrl = product.images.isNotEmpty
            ? product.images.first
            : 'https://via.placeholder.com/400';

        return ProductCard(
          productId: product.id,
          imageUrl: imageUrl,
          name: product.name,
          price: product.price,
          rating: product.rating ?? 0.0,
          soldCount: product.soldCount,
          onTap: () {
            context.push(
              ProductDetailScreen.getRoutePath(
                product.slug,
              ),
              extra: ProductDetailData(
                id: product.id,
                name: product.name,
                price: product.price,
                rating: product.rating ?? 0.0,
                reviewCount: product.reviewCount,
                soldCount: product.soldCount,
                images: product.images.isNotEmpty ? product.images : [imageUrl],
                description: product.description ?? '',
              ),
            );
          },
        );
      },
    );
  }
}
