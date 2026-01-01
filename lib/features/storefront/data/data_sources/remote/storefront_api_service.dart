import 'package:dio/dio.dart';
import 'package:ahioma_food_template/core/api/base_response.dart';
import 'package:ahioma_food_template/features/checkout/data/models/add_address_request_model.dart';
import 'package:retrofit/retrofit.dart';

part 'storefront_api_service.g.dart';

@RestApi(baseUrl: '') // Base URL is set via Dio in injection_container
abstract class StorefrontApiService {
  factory StorefrontApiService(Dio dio) = _StorefrontApiService;

  /// Get all categories (public)
  @GET('/api/storefront/categories')
  Future<HttpResponse<dynamic>> getCategories({
    @Query('active') String? active,
  });

  /// Get category by slug (public)
  @GET('/api/storefront/categories/{slug}')
  Future<HttpResponse<dynamic>> getCategoryBySlug(
    @Path('slug') String slug,
  );

  /// Get products (public)
  @GET('/api/storefront/products')
  Future<HttpResponse<dynamic>> getProducts({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('category') String? category,
    @Query('search') String? search,
    @Query('featured') String? featured,
    @Query('sortBy') String? sortBy,
    @Query('order') String? order,
  });

  /// Get product by slug (public)
  @GET('/api/storefront/products/{slug}')
  Future<HttpResponse<dynamic>> getProductBySlug(
    @Path('slug') String slug,
  );

  /// Get featured products (public)
  @GET('/api/storefront/products/featured')
  Future<HttpResponse<dynamic>> getFeaturedProducts({
    @Query('limit') int? limit,
  });

  /// Search products (public)
  @GET('/api/storefront/search')
  Future<HttpResponse<dynamic>> searchProducts({
    @Query('q') required String query,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('category') String? category,
  });

  /// Guest Cart - Add product to guest cart (public)
  @POST('/api/storefront/guest-cart')
  Future<HttpResponse<dynamic>> addToGuestCart(
    @Body() Map<String, dynamic> body,
  );

  /// Guest Cart - Get guest cart (public)
  @GET('/api/storefront/guest-cart')
  Future<HttpResponse<dynamic>> getGuestCart();

  /// Guest Cart - Clear guest cart (public)
  @DELETE('/api/storefront/guest-cart')
  Future<HttpResponse<dynamic>> clearGuestCart();

  /// Guest Cart - Update guest cart item (public)
  @PUT('/api/storefront/guest-cart/items/{itemId}')
  Future<HttpResponse<dynamic>> updateGuestCartItem(
    @Path('itemId') String itemId,
    @Body() Map<String, dynamic> body,
  );

  /// Guest Cart - Remove item from guest cart (public)
  @DELETE('/api/storefront/guest-cart/items/{itemId}')
  Future<HttpResponse<dynamic>> removeGuestCartItem(
    @Path('itemId') String itemId,
  );

  /// Authenticated Cart - Add product to authenticated user's cart
  @POST('/api/storefront/cart')
  Future<HttpResponse<dynamic>> addToCart(
    @Body() Map<String, dynamic> body,
  );

  /// Authenticated Cart - Get authenticated user's cart
  @GET('/api/storefront/cart')
  Future<HttpResponse<dynamic>> getCart();

  /// Authenticated Cart - Clear authenticated user's cart
  @DELETE('/api/storefront/customers/cart')
  Future<HttpResponse<dynamic>> clearCart();

  /// Authenticated Cart - Update cart item (requires authentication)
  @PUT('/api/storefront/customers/cart/{itemId}')
  Future<HttpResponse<dynamic>> updateCartItem(
    @Path('itemId') String itemId,
    @Body() Map<String, dynamic> body,
  );

  /// Authenticated Cart - Remove item from cart (requires authentication)
  @DELETE('/api/storefront/customers/cart/{itemId}')
  Future<HttpResponse<dynamic>> removeCartItem(
    @Path('itemId') String itemId,
  );

  /// Register a new storefront customer (public)
  @POST('/api/storefront/customers/register')
  Future<HttpResponse<dynamic>> registerCustomer(
    @Body() Map<String, dynamic> body,
  );

  /// Verify customer email with OTP (public)
  @POST('/api/storefront/customers/verify-email')
  Future<HttpResponse<dynamic>> verifyCustomerEmail(
    @Body() Map<String, dynamic> body,
  );

  /// Resend verification OTP (public)
  @POST('/api/storefront/customers/resend-otp')
  Future<HttpResponse<dynamic>> resendCustomerOtp(
    @Body() Map<String, dynamic> body,
  );

  /// Customer login (public)
  @POST('/api/storefront/customers/login')
  Future<HttpResponse<dynamic>> loginCustomer(
    @Body() Map<String, dynamic> body,
  );

  /// Get authenticated customer profile
  @GET('/api/storefront/customers/profile')
  Future<HttpResponse<dynamic>> getCustomerProfile({
    @Header('Authorization') String? authorization,
  });

  /// Wishlist - Get user's wishlist (requires authentication)
  @GET('/api/storefront/customers/wishlist')
  Future<HttpResponse<dynamic>> getWishlist();

  /// Wishlist - Add product to wishlist (requires authentication)
  @POST('/api/storefront/customers/wishlist')
  Future<HttpResponse<dynamic>> addToWishlist(
    @Body() Map<String, dynamic> body,
  );

  /// Wishlist - Remove product from wishlist (requires authentication)
  @DELETE('/api/storefront/customers/wishlist/{productId}')
  Future<HttpResponse<dynamic>> removeFromWishlist(
    @Path('productId') String productId,
  );

  /// Add customer address (Requires authentication)
  /// Note: API returns nested structure: {"success": true, "data": {"address": {...}}}
  @POST('/api/storefront/customers/addresses')
  Future<HttpResponse<dynamic>> addCustomerAddress(
    @Body() AddAddressRequestModel body,
  );
}
