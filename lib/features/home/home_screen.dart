import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/error/error_handler.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_remote_data_source.dart';
import 'package:ahioma_food_template/core/utils/strings/most_popular_strings.dart';
import 'package:ahioma_food_template/core/utils/strings/special_offers_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/communications/presentation/screens/notifications_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/category_products_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/most_popular_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/special_offers_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/wishlist_screen.dart';
import 'package:ahioma_food_template/features/home/widgets/category_grid.dart';
import 'package:ahioma_food_template/features/home/widgets/filter_chips.dart';
import 'package:ahioma_food_template/features/home/widgets/home_header.dart';
import 'package:ahioma_food_template/features/home/widgets/product_card.dart';
import 'package:ahioma_food_template/features/home/widgets/search_bar_widget.dart';
import 'package:ahioma_food_template/features/home/widgets/special_offers_banner.dart';
import 'package:ahioma_food_template/features/products/presentation/screens/product_detail_screen.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/screens/search_screen.dart';
import 'package:ahioma_food_template/features/storefront/data/models/category_model.dart';
import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';
import 'package:ahioma_food_template/features/wishlist/presentation/provider/wishlist_provider.dart';
import 'package:ahioma_food_template/injection_container.dart';
import 'package:ahioma_food_template/shared/animations/animated_list_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String path = '/home';
  static const String name = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorefrontRemoteDataSource _storefrontDataSource =
      sl<StorefrontRemoteDataSource>();
  final ScrollController _scrollController = ScrollController();

  List<CategoryModel> _categories = [];
  List<StorefrontProductModel> _products = [];
  List<StorefrontProductModel> _featuredProducts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  String _selectedFilter = 'All';

  // Pagination state
  int _currentPage = 1;
  static const int _itemsPerPage = 20;
  bool _hasMore = true;
  String? _currentCategorySlug; // Track current category filter for pagination

  // Save reference to AuthProvider to safely remove listener in dispose
  AuthProvider? _authProvider;

  @override
  void initState() {
    super.initState();
    unawaited(_loadData());
    // Listen for scroll events to load more products
    _scrollController.addListener(_onScroll);
    // Set up wishlist listener after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupWishlistListener();
      _loadCartIfAuthenticated();
    });
  }

  /// Load cart items (works for both guest and authenticated users)
  /// This ensures the cart badge shows the correct count
  void _loadCartIfAuthenticated() {
    if (!mounted) return;
    try {
      final cartProvider = context.read<CartProvider>();

      // Load cart for both guest and authenticated users
      // CartService automatically handles the distinction
      // Only load if cart is empty or hasn't been loaded yet
      final cartItems = cartProvider.cartItems;
      if (cartItems == null || cartItems.isEmpty) {
        unawaited(cartProvider.loadCartItems());
      }
    } catch (e) {
      // Silently handle errors - cart will load when cart screen opens
      if (kDebugMode) {
        debugPrint('[HomeScreen] Error loading cart: $e');
      }
    }
  }

  void _setupWishlistListener() {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final wishlistProvider = context.read<WishlistProvider>();

    // Save reference for safe disposal
    _authProvider = authProvider;

    // Load wishlist if authenticated
    if (authProvider.isAuthenticated) {
      if (wishlistProvider.wishlistProductIds.isEmpty &&
          !wishlistProvider.isLoading) {
        wishlistProvider.loadWishlist();
      }
    } else {
      // Clear wishlist if not authenticated
      if (wishlistProvider.wishlistProductIds.isNotEmpty) {
        wishlistProvider.clearWishlist();
      }
    }

    // Listen to auth changes
    authProvider.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    final wishlistProvider = context.read<WishlistProvider>();
    final cartProvider = context.read<CartProvider>();

    if (authProvider.isAuthenticated) {
      if (wishlistProvider.wishlistProductIds.isEmpty &&
          !wishlistProvider.isLoading) {
        wishlistProvider.loadWishlist();
      }
      // Reload cart when user becomes authenticated (may merge guest cart)
      // CartService handles merging guest cart into authenticated cart
      unawaited(cartProvider.loadCartItems());
    } else {
      if (wishlistProvider.wishlistProductIds.isNotEmpty) {
        wishlistProvider.clearWishlist();
      }
      // Reload cart when user logs out (switches to guest cart)
      // Don't clear - guest cart should persist
      unawaited(cartProvider.loadCartItems());
    }
  }

  @override
  void dispose() {
    // Remove auth listener using saved reference
    // This is safe because we saved the reference before the widget was deactivated
    _authProvider?.removeListener(_onAuthStateChanged);
    _authProvider = null;

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // Only load more if we have a valid scroll position
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Load more when scrolled 80% of the way down
    // Add a threshold to handle edge cases where maxScrollExtent might be 0
    if (maxScroll > 0 &&
        currentScroll >= (maxScroll * 0.8) &&
        !_isLoadingMore &&
        _hasMore) {
      unawaited(_loadMoreProducts());
    }
  }

  Future<void> _loadData({bool reset = true}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      if (reset) {
        _currentPage = 1;
        _hasMore = true;
        _products = [];
        _currentCategorySlug = null;
      }
    });

    try {
      // Load categories and products in parallel
      final results = await Future.wait([
        _storefrontDataSource.getCategories(),
        _storefrontDataSource.getProducts(page: _currentPage),
        _storefrontDataSource.getFeaturedProducts(limit: 1),
      ]);

      if (!mounted) return;

      final newProducts = results[1] as List<StorefrontProductModel>;

      setState(() {
        _categories = results[0] as List<CategoryModel>;
        _products = newProducts;
        _featuredProducts = results[2] as List<StorefrontProductModel>;
        _isLoading = false;
        // If we got fewer items than requested, there are no more
        _hasMore = newProducts.length >= _itemsPerPage;
      });
    } catch (e) {
      if (!mounted) return;
      final failure = ErrorHandler.handleException(e);
      final userMessage = ErrorHandler.getUserFriendlyMessage(failure);
      setState(() {
        _errorMessage = userMessage;
        _isLoading = false;
      });

      // Log the full error for debugging
      ErrorHandler.logError(e, context: 'HomeScreen._loadData');
    }
  }

  Future<void> _loadMoreProducts() async {
    if (!mounted || _isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final newProducts = await _storefrontDataSource.getProducts(
        page: nextPage,
        category: _currentCategorySlug,
      );

      if (!mounted) return;

      setState(() {
        _products.addAll(newProducts);
        _currentPage = nextPage;
        // If we got fewer items than requested, there are no more
        _hasMore = newProducts.length >= _itemsPerPage;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      if (kDebugMode) {
        debugPrint('[HomeScreen] Error loading more products: $e');
      }
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
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
              'Error loading data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    final authProvider = context.watch<AuthProvider>();
    final accountSetupProvider = context.watch<AccountSetupProvider>();
    final customer = authProvider.customer;

    String? displayName;
    if (customer != null) {
      final first = customer.firstName.trim();
      final last = customer.lastName.trim();
      if (first.isNotEmpty) {
        displayName = first;
      } else if (customer.fullName.trim().isNotEmpty) {
        displayName = customer.fullName.trim();
      } else if (last.isNotEmpty) {
        displayName = last;
      } else {
        displayName = customer.email;
      }
    }

    displayName ??= (accountSetupProvider.firstName?.trim().isNotEmpty ?? false)
        ? accountSetupProvider.firstName!.trim()
        : null;
    displayName ??= accountSetupProvider.fullName?.trim();
    displayName ??= accountSetupProvider.email?.trim();

    final avatarUrl = customer?.avatarUrl;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: HomeHeader(
              userName: displayName,
              avatarUrl: avatarUrl,
              onNotificationTap: () {
                unawaited(context.push(NotificationsScreen.path));
              },
              onFavoriteTap: () {
                unawaited(context.push(WishlistScreen.path));
              },
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: SearchBarWidget(
              onTap: () {
                unawaited(
                  context.push(SearchScreen.getRoutePath(SearchMode.products)),
                );
              },
              onFilterTap: () {
                unawaited(
                  context.push(
                    SearchScreen.getRoutePath(
                      SearchMode.products,
                      autoOpenFilter: true,
                    ),
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Special Offers Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    SpecialOffersStrings.specialOffers,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      unawaited(context.push(SpecialOffersScreen.path));
                    },
                    child: const Text(MostPopularStrings.seeAll),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Special Offers Banner
          SliverToBoxAdapter(
            child:
                _featuredProducts.isNotEmpty &&
                    _featuredProducts[0].images.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SpecialOffersBanner(
                      imageUrl: _featuredProducts[0].images.first,
                    ),
                  )
                : const SizedBox(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Categories Grid
          SliverToBoxAdapter(
            child: CategoryGrid(
              categories: _categories,
              onCategoryTap: (category) {
                unawaited(
                  context.push(CategoryProductsScreen.getRoutePath(category)),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Most Popular Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    MostPopularStrings.mostPopular,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      unawaited(context.push(MostPopularScreen.path));
                    },
                    child: const Text(MostPopularStrings.seeAll),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Filter Chips - Show category-based filters
          if (_categories.isNotEmpty)
            SliverToBoxAdapter(
              child: FilterChips(
                filters: ['All', ..._categories.take(4).map((cat) => cat.name)],
                selectedFilter: _selectedFilter,
                onFilterSelected: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  unawaited(_loadProductsForFilter(filter));
                },
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Products Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _products.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No products available',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  )
                : SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final imageUrl = product.images.isNotEmpty
                          ? product.images.first
                          : 'https://via.placeholder.com/400';

                      return AnimatedListItem(
                        index: index,
                        slideOffset: const Offset(0, 0.3),
                        child: ProductCard(
                          productId: product.id,
                          imageUrl: imageUrl,
                          name: product.name,
                          price: product.price,
                          rating: product.rating ?? 0.0,
                          soldCount: product.soldCount,
                          onTap: () {
                            // Use slug for navigation (API uses slug)
                            unawaited(
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
                                  description: product.description ?? '',
                                  category:
                                      product.category ?? product.categoryId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    childCount: _products.length,
                  ),
          ),

          // Loading indicator for pagination
          if (_isLoadingMore)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 16),
                    Text(
                      'Loading more products...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // End of list indicator
          if (!_hasMore && _products.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No more products to load',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Future<void> _loadProductsForFilter(String filter) async {
    if (!mounted) return;

    try {
      final categorySlug = filter == 'All'
          ? null
          : _categories
                .firstWhere(
                  (cat) => cat.name == filter,
                  orElse: () => _categories.first,
                )
                .slug;

      // Reset pagination when filter changes
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _isLoadingMore = false;
        _currentCategorySlug = categorySlug;
        _products = []; // Clear existing products
      });

      final products = await _storefrontDataSource.getProducts(
        category: categorySlug,
      );

      if (!mounted) return;
      setState(() {
        _products = products;
        _hasMore = products.length >= _itemsPerPage;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[HomeScreen] Error loading products for filter: $e');
      }
    }
  }
}
