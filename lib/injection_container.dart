import 'dart:convert' show jsonEncode;
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';
import 'package:ahioma_food_template/core/constants/tenant_config.dart';
import 'package:ahioma_food_template/core/web/connectivity_service.dart';
import 'package:ahioma_food_template/features/authentication/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:ahioma_food_template/features/cart/data/data_sources/guest_cart_session_manager.dart';
import 'package:ahioma_food_template/features/cart/data/data_sources/local/cart_local_source.dart';
import 'package:ahioma_food_template/features/cart/data/data_sources/remote/cart_remote_data_source.dart';
import 'package:ahioma_food_template/features/cart/data/data_sources/remote/guest_cart_remote_data_source.dart';
import 'package:ahioma_food_template/features/cart/data/repository/cart_repository_impl.dart';
import 'package:ahioma_food_template/features/cart/domain/repository/cart_respository.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_api_service.dart';
import 'package:ahioma_food_template/features/checkout/data/repository/checkout_repository_impl.dart';
import 'package:ahioma_food_template/features/checkout/domain/repository/checkout_repository.dart';
import 'package:ahioma_food_template/features/orders/data/data_sources/local/orders_local_source.dart';
import 'package:ahioma_food_template/features/orders/data/data_sources/remote/orders_api_service.dart';
import 'package:ahioma_food_template/features/orders/data/repository/orders_repository_impl.dart';
import 'package:ahioma_food_template/features/orders/domain/repository/orders_repository.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_remote_data_source.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/tenant_remote_data_source.dart';
import 'package:ahioma_food_template/features/wishlist/data/data_sources/remote/wishlist_remote_data_source.dart';
import 'package:ahioma_food_template/features/wishlist/data/repository/wishlist_repository_impl.dart';
import 'package:ahioma_food_template/features/wishlist/domain/repository/wishlist_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeAppDependencies() async {
  //Dio, shared preferences (Base Dependencies)
  sl
    ..registerSingleton<Dio>(_createDioWithLogging())
    ..registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance(),
    )
    //Dependencies (Data Sources, Repository)
    ..registerSingleton<CartLocalSource>(CartLocalSource())
    ..registerSingleton<OrdersLocalSource>(OrdersLocalSource())
    ..registerSingleton<OrdersApiService>(OrdersApiService(sl<Dio>()))
    ..registerSingleton<StorefrontApiService>(StorefrontApiService(sl<Dio>()))
    ..registerSingleton<ConnectivityService>(ConnectivityService())
    ..registerSingleton<TenantRemoteDataSource>(
      TenantRemoteDataSource(dio: sl<Dio>(), prefs: sl<SharedPreferences>()),
    )
    ..registerSingleton<StorefrontRemoteDataSource>(
      StorefrontRemoteDataSource(sl<Dio>()),
    )
    ..registerSingleton<GuestCartRemoteDataSource>(
      GuestCartRemoteDataSource(sl<Dio>()),
    )
    ..registerSingleton<CartRemoteDataSource>(
      CartRemoteDataSource(
        dio: sl<Dio>(),
        sharedPreferences: sl<SharedPreferences>(),
      ),
    )
    ..registerSingleton<CartRespository>(
      CartRepositoryImpl(
        localDataSource: sl<CartLocalSource>(),
        remoteDataSource: sl<CartRemoteDataSource>(),
      ),
    )
    ..registerSingleton<WishlistRemoteDataSource>(
      WishlistRemoteDataSource(
        dio: sl<Dio>(),
        sharedPreferences: sl<SharedPreferences>(),
      ),
    )
    ..registerSingleton<WishlistRepository>(
      WishlistRepositoryImpl(remoteDataSource: sl<WishlistRemoteDataSource>()),
    )
    ..registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSource(sl<Dio>()))
    ..registerSingleton<OrdersRepository>(
      OrdersRepositoryImpl(sl<OrdersLocalSource>(), sl<OrdersApiService>()),
    )
    ..registerSingleton<CheckoutRepository>(
      CheckoutRepositoryImpl(sl<StorefrontApiService>()),
    );
}

Dio _createDioWithLogging() {
  final dio = Dio();

  // Base configuration
  dio.options.baseUrl = TenantConfig.apiBaseUrl;
  dio.options.connectTimeout = AppConstants.apiTimeout;
  dio.options.receiveTimeout = AppConstants.apiTimeout;
  dio.options.sendTimeout = AppConstants.apiTimeout;

  // Add interceptors for headers and logging
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Inject tenant header if configured
        const tenantHeaderKey = String.fromEnvironment('TENANT_HEADER_KEY');
        const tenantDomain = String.fromEnvironment('TENANT_DOMAIN');
        if (tenantHeaderKey.isNotEmpty && tenantDomain.isNotEmpty) {
          options.headers[tenantHeaderKey] = tenantDomain;
        }

        // Inject Authorization header for authenticated endpoints
        final token = sl<SharedPreferences>().getString(
          AppConstants.userTokenKey,
        );
        if (token != null && token.isNotEmpty) {
          final path = options.path;
          // Add Authorization header for authenticated endpoints
          // Exclude guest-cart endpoints (they use X-Session-ID instead)
          if (!path.contains('/guest-cart')) {
            // Add for authenticated cart endpoints (/api/storefront/cart)
            if (path.contains('/api/storefront/cart') ||
                path.contains('/api/storefront/customers/cart')) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            // Add for customer endpoints (profile, etc.)
            else if (path.contains('/api/storefront/customers')) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            // Add for wishlist endpoints (requires authentication)
            else if (path.contains('/storefront/customers/wishlist')) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            //Add orders endpoints
            else if (path.contains('/api/storefront/orders')) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            //Add promo code validation endpoint
            else if (path.contains('/api/storefront/validate-promo-code')) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            //Add customer addresses endpoint
            else if (path.contains('/api/storefront/customers/addresses')) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
        }

        // Inject X-Session-ID header for guest cart endpoints
        if (options.path.contains('/guest-cart')) {
          try {
            final sessionManager = GuestCartSessionManager();
            final sessionId = await sessionManager.getSessionId();
            options.headers['X-Session-ID'] = sessionId;
          } catch (e) {
            if (kDebugMode) {
              debugPrint('[DioInterceptor] Error getting session ID: $e');
            }
          }
        }

        // Skip logging for specific endpoints
        final path = options.path;
        final shouldSkipRequest =
            path.contains('/storefront/products') ||
            path.contains('/storefront/business');

        // Log request in debug mode (excluding products and business profile)
        if (kDebugMode && !shouldSkipRequest) {
          final requestBody = options.data;
          log(
            '[API_REQUEST] ${options.method} ${options.uri}\n'
            'Headers: ${jsonEncode(options.headers)}\n'
            'Query: ${jsonEncode(options.queryParameters)}\n'
            'Body: ${requestBody is Map ? jsonEncode(requestBody) : requestBody}',
            name: 'API_LOG',
          );
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        // Skip logging for specific endpoints
        final path = response.requestOptions.path;
        final shouldSkip =
            path.contains('/search/photos') ||
            path.contains('/storefront/products') ||
            path.contains('/storefront/business');

        if (shouldSkip) {
          handler.next(response);
          return;
        }

        if (kDebugMode) {
          log(
            '[API] ${response.requestOptions.method}'
            ' ${response.requestOptions.path}\n'
            'Status: ${response.statusCode}\n'
            'Raw Response: ${jsonEncode(response.data)}',
            name: 'API_LOG',
          );
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          log(
            '[API_ERROR] ${error.requestOptions.method}'
            ' ${error.requestOptions.path}\n'
            'Status: ${error.response?.statusCode}\n'
            'Error Response: ${jsonEncode(error.response?.data)}',
            name: 'API_LOG',
          );
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}
