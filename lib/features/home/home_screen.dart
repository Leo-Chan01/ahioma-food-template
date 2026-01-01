import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/error/error_handler.dart';
import 'package:ahioma_food_template/features/home/data/mock_food_data.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_remote_data_source.dart';
import 'package:ahioma_food_template/l10n/l10n.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/communications/presentation/screens/notifications_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/category_products_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/most_popular_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/special_offers_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/wishlist_screen.dart';
import 'package:ahioma_food_template/features/home/widgets/category_grid.dart';
import 'package:ahioma_food_template/features/home/widgets/discount_product_card.dart';
import 'package:ahioma_food_template/features/home/widgets/filter_chips.dart';
import 'package:ahioma_food_template/features/home/widgets/home_header.dart';
import 'package:ahioma_food_template/features/home/widgets/recommended_product_card.dart';
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
  List<StorefrontProductModel> _discountProducts = []; // First 4 products
  List<StorefrontProductModel> _recommendedProducts = []; // Remaining products
  List<StorefrontProductModel> _featuredProducts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  String _allFilterLabel = 'All';
  String _selectedFilter = 'All';

  // Pagination state
  int _currentPage = 1;
  static const int _itemsPerPage = 20;
  bool _hasMore = true;
  String? _currentCategorySlug; // Track current category filter for pagination
  bool _isLoadingTriggered = false; // Prevent multiple simultaneous loads

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizedAll = context.l10n.homeFilterAll;
    if (_allFilterLabel != localizedAll) {
      setState(() {
        if (_selectedFilter == _allFilterLabel || _selectedFilter.isEmpty) {
          _selectedFilter = localizedAll;
        }
        _allFilterLabel = localizedAll;
      });
    }
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

    // Prevent loading if already triggered or currently loading
    if (_isLoadingTriggered || _isLoadingMore || !_hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Load more when scrolled 80% of the way down
    // Add a threshold to handle edge cases where maxScrollExtent might be 0
    if (maxScroll > 0 && currentScroll >= (maxScroll * 0.8)) {
      _isLoadingTriggered = true;
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
        _discountProducts = [];
        _recommendedProducts = [];
        _currentCategorySlug = null;
        _selectedFilter = _allFilterLabel;
      }
    });

    try {
      // Check if we should use mock data
      if (MockFoodData.useMockData) {
        // Use mock data
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulate API delay
        if (!mounted) return;

        setState(() {
          _categories = []; // Categories loaded separately
          _discountProducts = MockFoodData.getDiscountProducts();
          _recommendedProducts = MockFoodData.getRecommendedProducts();
          _featuredProducts = MockFoodData.getDiscountProducts()
              .take(1)
              .toList();
          _isLoading = false;
          _hasMore = false; // Mock data doesn't paginate
        });
      } else {
        // Load categories and products in parallel from API
        final results = await Future.wait([
          _storefrontDataSource.getCategories(),
          _storefrontDataSource.getProducts(page: _currentPage),
          _storefrontDataSource.getFeaturedProducts(limit: 1),
        ]);

        if (!mounted) return;

        final newProducts = results[1] as List<StorefrontProductModel>;

        setState(() {
          _categories = results[0] as List<CategoryModel>;
          // Split products: first 4 for discount section, rest for recommended
          if (newProducts.length > 4) {
            _discountProducts = newProducts.sublist(0, 4);
            _recommendedProducts = newProducts.sublist(4);
          } else {
            _discountProducts = newProducts;
            _recommendedProducts = [];
          }
          _featuredProducts = results[2] as List<StorefrontProductModel>;
          _isLoading = false;
          // If we got fewer items than requested, there are no more
          _hasMore = newProducts.length >= _itemsPerPage;
        });
      }
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
    if (!mounted || _isLoadingMore || !_hasMore) {
      _isLoadingTriggered = false;
      return;
    }

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
        _recommendedProducts.addAll(newProducts);
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
    } finally {
      // Reset the trigger flag after a short delay to prevent immediate retriggering
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        _isLoadingTriggered = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.homeErrorLoadingTitle,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (_errorMessage?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: Text(context.l10n.homeRetry),
                  ),
                ],
              ),
            ),
          ),
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

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          notificationPredicate: (notification) {
            // Only allow pull-to-refresh when at the top
            return notification.depth == 0;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
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

              SliverToBoxAdapter(
                child: SearchBarWidget(
                  onTap: () {
                    unawaited(
                      context.push(
                        SearchScreen.getRoutePath(SearchMode.products),
                      ),
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

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.homeSpecialOffers,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          unawaited(context.push(SpecialOffersScreen.path));
                        },
                        child: Text(context.l10n.homeSeeAll),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverToBoxAdapter(
                child:
                    _featuredProducts.isNotEmpty &&
                        _featuredProducts[0].images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SpecialOffersBanner(
                          imageUrl: _featuredProducts[0].images.first,
                          title: context.l10n.homeSpecialTitleDefault,
                          description:
                              context.l10n.homeSpecialDescriptionDefault,
                        ),
                      )
                    : const SizedBox(),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              SliverToBoxAdapter(
                child: CategoryGrid(
                  categories: _categories,
                  onCategoryTap: (category) {
                    unawaited(
                      context.push(
                        CategoryProductsScreen.getRoutePath(category),
                      ),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Discount Guaranteed Section (replaces Most Popular)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${context.l10n.homeDiscountGuaranteed} 👌',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          unawaited(context.push(MostPopularScreen.path));
                        },
                        child: Text(context.l10n.homeSeeAll),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Discount Products - Horizontal Scroll
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 280,
                  child: _discountProducts.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _discountProducts.length,
                          itemBuilder: (context, index) {
                            final product = _discountProducts[index];
                            final imageUrl = product.images.isNotEmpty
                                ? product.images.first
                                : 'https://via.placeholder.com/400';

                            return DiscountProductCard(
                              productId: product.id,
                              imageUrl: imageUrl,
                              name: product.name,
                              price: product.price,
                              originalPrice: product.price * 1.3,
                              rating: product.rating ?? 0.0,
                              soldCount: product.soldCount,
                              onTap: () {
                                unawaited(
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
                                      images: product.images.isNotEmpty
                                          ? product.images
                                          : [imageUrl],
                                      description: product.description ?? '',
                                      category:
                                          product.category ??
                                          product.categoryId,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Recommended For You Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${context.l10n.homeRecommendedForYou} 😍',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          unawaited(context.push(MostPopularScreen.path));
                        },
                        child: Text(context.l10n.homeSeeAll),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              if (_categories.isNotEmpty)
                SliverToBoxAdapter(
                  child: FilterChips(
                    filters: [
                      _allFilterLabel,
                      ..._categories.take(4).map((cat) => cat.name),
                    ],
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

              // Recommended products list - start from 5th product onwards
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: _recommendedProducts.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Text(
                              context.l10n.homeNoProductsAvailable,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = _recommendedProducts[index];
                          final imageUrl = product.images.isNotEmpty
                              ? product.images.first
                              : 'https://via.placeholder.com/400';

                          return AnimatedListItem(
                            index: index,
                            slideOffset: const Offset(0, 0.3),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: RecommendedProductCard(
                                productId: product.id,
                                imageUrl: imageUrl,
                                name: product.name,
                                price: product.price,
                                rating: product.rating ?? 0.0,
                                reviewCount: product.reviewCount,
                                distance: '${(index + 1) * 0.5} km',
                                onTap: () {
                                  unawaited(
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
                                        images: product.images.isNotEmpty
                                            ? product.images
                                            : [imageUrl],
                                        description: product.description ?? '',
                                        category:
                                            product.category ??
                                            product.categoryId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }, childCount: _recommendedProducts.length),
                      ),
              ),

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
                          context.l10n.homeLoadingMore,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (!_hasMore &&
                  (_discountProducts.isNotEmpty ||
                      _recommendedProducts.isNotEmpty))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        context.l10n.homeNoMoreProducts,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadProductsForFilter(String filter) async {
    if (!mounted) return;

    try {
      final categorySlug = filter == _allFilterLabel
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
        _discountProducts = []; // Clear existing products
        _recommendedProducts = [];
      });

      final products = await _storefrontDataSource.getProducts(
        category: categorySlug,
      );

      if (!mounted) return;
      setState(() {
        // Split products: first 4 for discount section, rest for recommended
        if (products.length > 4) {
          _discountProducts = products.sublist(0, 4);
          _recommendedProducts = products.sublist(4);
        } else {
          _discountProducts = products;
          _recommendedProducts = [];
        }
        _hasMore = products.length >= _itemsPerPage;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[HomeScreen] Error loading products for filter: $e');
      }
    }
  }
}
