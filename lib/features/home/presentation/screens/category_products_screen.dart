import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_remote_data_source.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/features/home/widgets/product_card.dart';
import 'package:ahioma_food_template/features/products/presentation/screens/product_detail_screen.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/screens/search_screen.dart';
import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';
import 'package:ahioma_food_template/injection_container.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({required this.category, super.key});

  static const String path = '/category/:categoryName';
  static const String name = 'category-products';

  final String category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();

  static String getRoutePath(String category) =>
      '/category/${Uri.encodeComponent(category)}';
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final StorefrontRemoteDataSource _storefrontDataSource =
      sl<StorefrontRemoteDataSource>();
  List<StorefrontProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _storefrontDataSource.getProducts(
        category: widget.category.toLowerCase(),
      );

      if (!mounted) return;
      setState(() {
        _products = products;
        _isLoading = false;
      });
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
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.category,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : RefreshIndicator.adaptive(
              onRefresh: _loadProducts,
              child: _products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppIcons.store(
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products available',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : MasonryGridView.count(
                      padding: const EdgeInsets.all(16),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
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
                              ProductDetailScreen.getRoutePath(product.slug),
                              extra: ProductDetailData(
                                id: product.id,
                                name: product.name,
                                price: product.price,
                                rating: product.rating ?? 0.0,
                                reviewCount: product.reviewCount,
                                soldCount: product.soldCount,
                                images: product.images.isNotEmpty
                                    ? product.images
                                    : [imageUrl],
                                category:
                                    product.category ?? product.categoryId,
                                description: product.description ?? '',
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
    );
  }
}
