import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/search_strings.dart';
import 'package:ahioma_food_template/core/utils/strings/wishlist_strings.dart';
import 'package:ahioma_food_template/features/home/widgets/product_card.dart';
import 'package:ahioma_food_template/features/products/presentation/screens/product_detail_screen.dart';
import 'package:ahioma_food_template/features/search/data/data_sources/local/search_local_source.dart';
import 'package:ahioma_food_template/features/search/data/repositories/search_repository_impl.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_filter_entity.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/widgets/filter_modal_widget.dart';
import 'package:ahioma_food_template/features/search/presentation/widgets/recent_searches_widget.dart';
import 'package:ahioma_food_template/features/search/presentation/widgets/search_no_results_widget.dart';
import 'package:ahioma_food_template/features/search/presentation/widgets/search_results_header_widget.dart';
import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';

enum SearchState { initial, searching, results, noResults }

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    this.searchMode = SearchMode.general,
    this.autoOpenFilter = false,
    super.key,
  });

  static const String path = '/search';
  static const String name = 'search';

  static String getRoutePath(SearchMode mode, {bool autoOpenFilter = false}) {
    final params = <String>[];
    if (mode != SearchMode.general) {
      params.add('mode=${mode.stringValue}');
    }
    if (autoOpenFilter) {
      params.add('filter=true');
    }
    return params.isEmpty ? path : '$path?${params.join('&')}';
  }

  final SearchMode searchMode;
  final bool autoOpenFilter;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchRepositoryImpl _searchRepository = SearchRepositoryImpl();
  final SearchLocalSource _searchSource = SearchLocalSource();
  final FocusNode _focusNode = FocusNode();

  SearchState _state = SearchState.initial;
  List<String> _recentSearches = [];
  List<dynamic> _searchResults =
      []; // Can be products, transactions, orders, etc.
  String _currentQuery = '';
  SearchMode get _searchMode => widget.searchMode;

  SearchFilterEntity _filter = const SearchFilterEntity(
    categories: [
      WishlistStrings.all,
      WishlistStrings.clothes,
      WishlistStrings.shoes,
      WishlistStrings.bags,
      WishlistStrings.electronics,
    ],
    sortOptions: [
      SearchStrings.popular,
      SearchStrings.mostRecent,
      SearchStrings.priceHigh,
      SearchStrings.priceLow,
      SearchStrings.highestRating,
    ],
    ratingOptions: [
      SearchStrings.all,
      SearchStrings.fiveStars,
      SearchStrings.fourStars,
      SearchStrings.threeStars,
      SearchStrings.twoStars,
      SearchStrings.oneStar,
    ],
  );

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _focusNode.requestFocus();

    // Auto-open filter modal if requested
    if (widget.autoOpenFilter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GlobalSnackBar.showInfo('Filter modal is not available yet');
        // _showFilterModal();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await _searchSource.getRecentSearches(_searchMode);
    setState(() {
      _recentSearches = searches;
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _state = SearchState.initial;
        _currentQuery = '';
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _state = SearchState.searching;
      _currentQuery = query;
    });

    // Save to recent searches
    await _searchSource.saveSearchQuery(query, _searchMode);

    try {
      dynamic results;

      switch (_searchMode) {
        case SearchMode.products:
          final productsResult = await _searchRepository.searchProducts(query);
          productsResult.fold(
            (failure) => throw Exception(failure.message),
            (photos) => results = photos,
          );

        case SearchMode.wallet:
          final walletResult = await _searchRepository.searchWallet(query);
          walletResult.fold(
            (failure) => throw Exception(failure.message),
            (transactions) => results = transactions,
          );

        case SearchMode.orders:
          final ordersResult = await _searchRepository.searchOrders(query);
          ordersResult.fold(
            (failure) => throw Exception(failure.message),
            (orders) => results = orders,
          );

        case SearchMode.notifications:
          final notifResult = await _searchRepository.searchNotifications(
            query,
          );
          notifResult.fold(
            (failure) => throw Exception(failure.message),
            (notifications) => results = notifications,
          );

        case SearchMode.general:
          // Default to products for general search
          final productsResult = await _searchRepository.searchProducts(query);
          productsResult.fold(
            (failure) => throw Exception(failure.message),
            (photos) => results = photos,
          );
      }

      final resultsList = results as List<dynamic>;
      setState(() {
        _searchResults = resultsList;
        _state = resultsList.isEmpty
            ? SearchState.noResults
            : SearchState.results;
        _recentSearches = [..._recentSearches];
      });

      await _loadRecentSearches();
    } catch (e) {
      setState(() {
        _state = SearchState.noResults;
        _searchResults = [];
      });
    }
  }

  void _handleRecentSearchTap(String search) {
    if (search.startsWith('__DELETE__')) {
      final queryToDelete = search.replaceFirst('__DELETE__', '');
      _searchSource.deleteSearchQuery(queryToDelete, _searchMode);
      _loadRecentSearches();
    } else {
      _searchController.text = search;
      _performSearch(search);
    }
  }

  void _showFilterModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        filter: _filter,
        onApply: (filter) {
          setState(() {
            _filter = filter;
          });
          if (_currentQuery.isNotEmpty) {
            _performSearch(_currentQuery);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: AppIcons.arrowBack(
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      autofocus: true,
                      onSubmitted: _performSearch,
                      decoration: InputDecoration(
                        hintText: _searchMode.placeholderText,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: AppIcons.search(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                            size: 20,
                          ),
                        ),
                        suffixIcon: _searchMode == SearchMode.products
                            ? IconButton(
                                icon: AppIcons.filter(
                                  color: theme.colorScheme.onSurface,
                                  size: 20,
                                ),
                                // onPressed: _showFilterModal,
                                onPressed: () {
                                  GlobalSnackBar.showInfo(
                                    'Filter modal is not available yet',
                                  );
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(child: _buildContent(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    switch (_state) {
      case SearchState.initial:
        return RecentSearchesWidget(
          recentSearches: _recentSearches,
          onSearchTap: _handleRecentSearchTap,
          onClearAll: () async {
            await _searchSource.clearAllSearches(_searchMode);
            setState(() {
              _recentSearches = [];
            });
          },
        );

      case SearchState.searching:
        return const Center(child: CircularProgressIndicator.adaptive());

      case SearchState.noResults:
        return const SearchNoResultsWidget();

      case SearchState.results:
        return _buildResultsView(theme);
    }
  }

  Widget _buildResultsView(ThemeData theme) {
    return Column(
      children: [
        SearchResultsHeaderWidget(
          query: _currentQuery,
          resultCount: _searchResults.length,
        ),
        Expanded(child: _buildResultsList(theme, _searchResults)),
      ],
    );
  }

  Widget _buildResultsList(ThemeData theme, List<dynamic> results) {
    switch (_searchMode) {
      case SearchMode.products:
        return _buildProductResults(
          theme,
          results.cast<StorefrontProductModel>(),
        );

      case SearchMode.wallet:
        return _buildWalletResults(theme, results.cast<Map<String, dynamic>>());

      case SearchMode.orders:
        return _buildOrderResults(theme, results.cast<Map<String, dynamic>>());

      case SearchMode.notifications:
        return _buildNotificationResults(
          theme,
          results.cast<Map<String, dynamic>>(),
        );

      case SearchMode.general:
        return _buildProductResults(
          theme,
          results.cast<StorefrontProductModel>(),
        );
    }
  }

  Widget _buildProductResults(
    ThemeData theme,
    List<StorefrontProductModel> products,
  ) {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
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
                images: product.images.isNotEmpty ? product.images : [imageUrl],
                description: product.description ?? '',
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWalletResults(
    ThemeData theme,
    List<Map<String, dynamic>> results,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final transaction = results[index];
        final isDebit = transaction['type'] == 'order';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: transaction['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      transaction['imageUrl'] as String,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          AppIcons.wallet(size: 30),
                    ),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: AppIcons.wallet(size: 30),
                  ),
            title: Text(transaction['title'] as String? ?? ''),
            subtitle: Text(
              '${transaction['date'] as String? ?? ''} • ${transaction['time'] as String? ?? ''}',
            ),
            trailing: Text(
              '\$${(transaction['amount'] as num).toStringAsFixed(2)}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDebit
                    ? theme.colorScheme.error
                    : theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderResults(
    ThemeData theme,
    List<Map<String, dynamic>> results,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final order = results[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                order['productImage'] as String? ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    AppIcons.orders(size: 30),
              ),
            ),
            title: Text(order['productName'] as String? ?? ''),
            subtitle: Text(
              order['status'] as String? ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            trailing: Text(
              '\$${(order['price'] as num).toStringAsFixed(2)}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationResults(
    ThemeData theme,
    List<Map<String, dynamic>> results,
  ) {
    return results.isEmpty
        ? const Center(child: Text('No notifications found'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final notification = results[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(notification['title'] as String? ?? ''),
                  subtitle: Text(notification['message'] as String? ?? ''),
                ),
              );
            },
          );
  }
}
