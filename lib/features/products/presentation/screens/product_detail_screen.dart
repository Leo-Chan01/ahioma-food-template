import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/error/error_handler.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_remote_data_source.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/core/utils/strings/product_strings.dart';
import 'package:ahioma_food_template/core/utils/strings/review_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/login_screen.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/products/presentation/screens/product_reviews_screen.dart';
import 'package:ahioma_food_template/features/products/presentation/widgets/product_color_selector_widget.dart';
import 'package:ahioma_food_template/features/products/presentation/widgets/product_image_carousel_widget.dart';
import 'package:ahioma_food_template/features/products/presentation/widgets/product_quantity_selector_widget.dart';
import 'package:ahioma_food_template/features/products/presentation/widgets/product_size_selector_widget.dart';
import 'package:ahioma_food_template/features/wishlist/presentation/provider/wishlist_provider.dart';
import 'package:ahioma_food_template/injection_container.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:provider/provider.dart';

class ProductDetailData {
  const ProductDetailData({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.images,
    this.category,
    this.description,
  });

  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final List<String> images;
  final String? category;
  final String? description;
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({this.productId, this.productData, super.key});

  static const String path = '/product/:id';
  static const String name = 'product-detail';

  final String? productId;
  final ProductDetailData? productData;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();

  static String getRoutePath(String productId) => '/product/$productId';
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final StorefrontRemoteDataSource _storefrontDataSource =
      sl<StorefrontRemoteDataSource>();

  String? _selectedSize;
  Color? _selectedColor;
  int _quantity = 1;
  bool _isWishlistLoading = false;

  ProductDetailData? _product;
  List<String> _images = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _sizes = [
    ProductStrings.sizeS,
    ProductStrings.sizeM,
    ProductStrings.sizeL,
  ];
  final List<Color> _colors = [
    Colors.blue.shade700,
    Colors.brown,
    Colors.grey,
    Colors.grey.shade400,
  ];

  @override
  void initState() {
    super.initState();
    _selectedSize = ProductStrings.sizeM;
    _selectedColor = _colors[0];

    // If productData is provided, use it immediately (for instant display)
    if (widget.productData != null) {
      _product = widget.productData;
      _images = _product!.images.isNotEmpty
          ? _product!.images
          : ['https://via.placeholder.com/400'];
      _isLoading = false;
      // Still fetch from API in background to get latest data
      _loadProduct(showLoading: false);
    } else {
      // No productData, need to load from API
      _loadProduct(showLoading: true);
    }

    // Load wishlist if authenticated
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated) {
      final wishlistProvider = context.read<WishlistProvider>();
      if (wishlistProvider.wishlistProductIds.isEmpty) {
        // Load wishlist if not already loaded
        wishlistProvider.loadWishlist();
      }
    }
  }

  Future<void> _toggleWishlist() async {
    if (_product == null) return;

    final authProvider = context.read<AuthProvider>();
    final wishlistProvider = context.read<WishlistProvider>();

    // Check if user is authenticated
    if (!authProvider.isAuthenticated) {
      // Redirect to login with redirect path
      GlobalSnackBar.showInfo('Please login to add items to your wishlist');
      if (mounted) {
        final currentPath =
            ModalRoute.of(context)?.settings.name ??
            ProductDetailScreen.getRoutePath(_product!.id);
        context.pushNamed(LoginScreen.name, extra: currentPath);
      }
      return;
    }

    setState(() {
      _isWishlistLoading = true;
    });

    try {
      final isInWishlist = wishlistProvider.isInWishlist(_product!.id);
      if (isInWishlist) {
        await wishlistProvider.removeFromWishlist(_product!.id);
      } else {
        await wishlistProvider.addToWishlist(_product!.id);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ProductDetailScreen] Error toggling wishlist: $e');
      }
      GlobalSnackBar.showError('Failed to update wishlist');
    } finally {
      if (mounted) {
        setState(() {
          _isWishlistLoading = false;
        });
      }
    }
  }

  Future<void> _loadProduct({required bool showLoading}) async {
    // If no productId (slug) provided, skip API call
    if (widget.productId == null || widget.productId!.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (_product == null) {
          _errorMessage = 'Product not found';
        }
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      if (showLoading) {
        _isLoading = true;
      }
      _errorMessage = null;
    });

    try {
      final product = await _storefrontDataSource.getProductBySlug(
        widget.productId!,
      );

      if (!mounted) return;

      if (product == null) {
        setState(() {
          _errorMessage = 'Product not found';
          _isLoading = false;
        });
        return;
      }

      // Convert StorefrontProductModel to ProductDetailData
      final imageUrl = product.images.isNotEmpty
          ? product.images.first
          : 'https://via.placeholder.com/400';

      if (kDebugMode) {
        debugPrint('[ProductDetailScreen] Loaded product:');
        debugPrint('  ID: ${product.id}');
        debugPrint('  Name: ${product.name}');
        debugPrint('  Price: ${product.price}');
        debugPrint('  Rating: ${product.rating}');
        debugPrint('  Images: ${product.images.length}');
      }

      setState(() {
        _product = ProductDetailData(
          id: product.id,
          name: product.name,
          price: product.price,
          rating: product.rating ?? 0.0,
          reviewCount: product.reviewCount,
          soldCount: product.soldCount,
          images: product.images.isNotEmpty ? product.images : [imageUrl],
          category: product.category ?? product.categoryId,
          description: product.description ?? '',
        );
        _images = _product!.images;
        _isLoading = false;
        _errorMessage = null; // Clear any previous errors
      });
    } catch (e) {
      if (!mounted) return;

      // Only show error if we don't have initial productData
      // If we have initial data, silently fail and keep showing it
      if (widget.productData == null) {
        final failure = ErrorHandler.handleException(e);
        final userMessage = ErrorHandler.getUserFriendlyMessage(failure);
        setState(() {
          _errorMessage = userMessage;
          _isLoading = false;
        });
      } else {
        // We have initial data, just log the error but don't show it
        // This allows the user to still see the product even if API fails
        setState(() {
          _isLoading = false;
        });
      }

      ErrorHandler.logError(e, context: 'ProductDetailScreen._loadProduct');
    }
  }

  double get _totalPrice {
    if (_product == null) return 0;
    return _product!.price * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Show loading state
    if (_isLoading && _product == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    // Show error state
    if (_errorMessage != null && _product == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: AppIcons.arrowBack(color: theme.colorScheme.onSurface),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Error loading product', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadProduct(showLoading: true),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Show product if available (even if loading updates in background)
    if (_product == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: AppIcons.arrowBack(color: theme.colorScheme.onSurface),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: Text('Product not found')),
      );
    }

    // Use non-null assertion since we've checked above
    final product = _product!;

    return Scaffold(
      body: Stack(
        children: [
          // Scrollable Content
          CustomScrollView(
            slivers: [
              // Image Carousel (takes full screen width)
              SliverToBoxAdapter(
                child: ProductImageCarouselWidget(images: _images),
              ),
              // Product Details
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Name and Wishlist
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Consumer<WishlistProvider>(
                          builder: (context, wishlistProvider, _) {
                            final isInWishlist =
                                _product != null &&
                                wishlistProvider.isInWishlist(_product!.id);
                            return IconButton(
                              icon: _isWishlistLoading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              theme.colorScheme.primary,
                                            ),
                                      ),
                                    )
                                  : isInWishlist
                                  ? AppIcons.favoriteFilled(
                                      color: theme.colorScheme.error,
                                    )
                                  : AppIcons.favorite(
                                      color: theme.colorScheme.onSurface,
                                    ),
                              onPressed: _isWishlistLoading
                                  ? null
                                  : _toggleWishlist,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Sold count and Rating
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${product.soldCount} sold',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            context.push(
                              ProductReviewsScreen.getRoutePath(product.id),
                            );
                          },
                          child: Row(
                            children: [
                              AppIcons.star(color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating} (${product.reviewCount} ${ReviewStrings.reviews.toLowerCase()})',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Description
                    Text(
                      ProductStrings.description,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description ??
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 24),
                    // // Size Selector
                    // ProductSizeSelectorWidget(
                    //   sizes: _sizes,
                    //   selectedSize: _selectedSize,
                    //   onSizeSelected: (size) {
                    //     setState(() {
                    //       _selectedSize = size;
                    //     });
                    //   },
                    // ),
                    // const SizedBox(height: 24),
                    // // Color Selector
                    // ProductColorSelectorWidget(
                    //   colors: _colors,
                    //   selectedColor: _selectedColor,
                    //   onColorSelected: (color) {
                    //     setState(() {
                    //       _selectedColor = color;
                    //     });
                    //   },
                    // ),
                    const SizedBox(height: 24),
                    // Quantity Selector
                    ProductQuantitySelectorWidget(
                      quantity: _quantity,
                      onQuantityChanged: (qty) {
                        setState(() {
                          _quantity = qty;
                        });
                      },
                    ),
                    // Add bottom padding to account for bottom bar
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
          // Sticky AppBar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: AppIcons.arrowBack(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Bar with Price and Add to Cart (sticky)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ProductStrings.totalPrice,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          _totalPrice.toNairaTextSpan(
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (product.id.isEmpty) return;

                            final cartProvider = context.read<CartProvider>();
                            await cartProvider.addToCart(
                              product.id,
                              quantity: _quantity,
                            );

                            if (mounted) {
                              GlobalSnackBar.showSuccess(
                                '${product.name} added to cart',
                              );
                            }
                          },
                          icon: AppIcons.shoppingBag(
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(ProductStrings.addToCart),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
