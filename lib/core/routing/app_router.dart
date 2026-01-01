import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/login_screen.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/social_login_screen.dart';
import 'package:ahioma_food_template/features/cart/presentation/screens/cart_screen.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/add_promo_screen.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/choose_shipping_screen.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/enter_pin_screen.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/payment_methods_screen.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/shipping_address_screen.dart';
import 'package:ahioma_food_template/features/communications/presentation/screens/notifications_screen.dart';
import 'package:ahioma_food_template/features/fund_management/wallet_screen.dart';
import 'package:ahioma_food_template/features/home/home_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/category_products_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/most_popular_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/special_offers_screen.dart';
import 'package:ahioma_food_template/features/home/presentation/screens/wishlist_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/create_new_pin_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/fill_your_profile_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/set_your_fingerprint_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/verify_email_screen.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';
import 'package:ahioma_food_template/features/orders/presentation/screens/leave_review_screen.dart';
import 'package:ahioma_food_template/features/orders/presentation/screens/my_orders_screen.dart';
import 'package:ahioma_food_template/features/orders/presentation/screens/track_order_screen.dart';
import 'package:ahioma_food_template/features/products/presentation/screens/product_detail_screen.dart';
import 'package:ahioma_food_template/features/products/presentation/screens/product_reviews_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/add_new_address_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/add_new_card_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/address_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/customer_service_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/edit_profile_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/help_center_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/invite_friends_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/language_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/notification_settings_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/payment_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/privacy_policy_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/security_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/profile_screen.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/screens/search_screen.dart';
import 'package:ahioma_food_template/shared/widgets/scaffold_with_bottom_nav.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: HomeScreen.path,
    routes: [
      // Auth screens
      GoRoute(
        path: SocialLoginScreen.path,
        name: SocialLoginScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const SocialLoginScreen();
        },
      ),
      GoRoute(
        path: SignUpScreen.path,
        name: SignUpScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
      ),

      GoRoute(
        path: LoginScreen.path,
        name: LoginScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          final redirectPath = state.extra as String?;
          return LoginScreen(redirectPath: redirectPath);
        },
        routes: [
          GoRoute(
            path: ForgotPasswordScreen.path,
            name: ForgotPasswordScreen.name,
            builder: (BuildContext context, GoRouterState state) {
              return const ForgotPasswordScreen();
            },
          ),
        ],
      ),

      // Track Order screen
      GoRoute(
        path: TrackOrderScreen.path,
        name: TrackOrderScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          final order = state.extra! as OrderEntity;
          return TrackOrderScreen(order: order);
        },
      ),

      // Leave Review screen
      GoRoute(
        path: LeaveReviewScreen.path,
        name: LeaveReviewScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          final order = state.extra! as OrderEntity;
          return LeaveReviewScreen(order: order);
        },
      ),

      // Notifications screen
      GoRoute(
        path: NotificationsScreen.path,
        name: NotificationsScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationsScreen();
        },
      ),

      // Wishlist screen
      GoRoute(
        path: WishlistScreen.path,
        name: WishlistScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const WishlistScreen();
        },
      ),

      // Special Offers screen
      GoRoute(
        path: SpecialOffersScreen.path,
        name: SpecialOffersScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const SpecialOffersScreen();
        },
      ),

      // Most Popular screen
      GoRoute(
        path: MostPopularScreen.path,
        name: MostPopularScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const MostPopularScreen();
        },
      ),

      // Search screen
      GoRoute(
        path: SearchScreen.path,
        name: SearchScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          final autoOpenFilter = state.uri.queryParameters['filter'] == 'true';
          final modeParam = state.uri.queryParameters['mode'];
          final searchMode = SearchModeExtension.fromString(modeParam);
          return SearchScreen(
            searchMode: searchMode,
            autoOpenFilter: autoOpenFilter,
          );
        },
      ),

      // Category products screen
      GoRoute(
        path: CategoryProductsScreen.path,
        name: CategoryProductsScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          final categoryName = state.pathParameters['categoryName'] ?? '';
          return CategoryProductsScreen(
            category: Uri.decodeComponent(categoryName),
          );
        },
      ),

      // Product detail screen
      GoRoute(
        path: ProductDetailScreen.path,
        name: ProductDetailScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          final productId = state.pathParameters['id'] ?? '';
          final productData = state.extra != null
              ? state.extra! as ProductDetailData
              : null;
          return ProductDetailScreen(
            productId: productId,
            productData: productData,
          );
        },
      ),

      // Product reviews screen
      GoRoute(
        path: '/product/:id/reviews',
        name: ProductReviewsScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          final productId = state.pathParameters['id'] ?? '';
          return ProductReviewsScreen(productId: productId);
        },
      ),

      // Checkout flow
      GoRoute(
        path: CheckoutScreen.path,
        name: CheckoutScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const CheckoutScreen();
        },
      ),
      GoRoute(
        path: ShippingAddressScreen.path,
        name: ShippingAddressScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const ShippingAddressScreen();
        },
      ),
      GoRoute(
        path: ChooseShippingScreen.path,
        name: ChooseShippingScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const ChooseShippingScreen();
        },
      ),
      GoRoute(
        path: AddPromoScreen.path,
        name: AddPromoScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const AddPromoScreen();
        },
      ),
      GoRoute(
        path: PaymentMethodsScreen.path,
        name: PaymentMethodsScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const PaymentMethodsScreen();
        },
      ),
      GoRoute(
        path: EnterPinScreen.path,
        name: EnterPinScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const EnterPinScreen();
        },
      ),

      // Onboarding screens
      GoRoute(
        path: FillYourProfileScreen.path,
        name: FillYourProfileScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const FillYourProfileScreen();
        },
      ),
      GoRoute(
        path: CreateNewPinScreen.path,
        name: CreateNewPinScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const CreateNewPinScreen();
        },
      ),
      GoRoute(
        path: SetYourFingerprintScreen.path,
        name: SetYourFingerprintScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const SetYourFingerprintScreen();
        },
      ),
      GoRoute(
        path: VerifyEmailScreen.path,
        name: VerifyEmailScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyEmailScreen();
        },
      ),

      // Profile screens
      GoRoute(
        path: EditProfileScreen.path,
        name: EditProfileScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const EditProfileScreen();
        },
      ),
      GoRoute(
        path: AddressScreen.path,
        name: AddressScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const AddressScreen();
        },
      ),
      GoRoute(
        path: AddNewAddressScreen.path,
        name: AddNewAddressScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const AddNewAddressScreen();
        },
      ),
      GoRoute(
        path: NotificationSettingsScreen.path,
        name: NotificationSettingsScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationSettingsScreen();
        },
      ),
      GoRoute(
        path: PaymentScreen.path,
        name: PaymentScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const PaymentScreen();
        },
      ),
      GoRoute(
        path: AddNewCardScreen.path,
        name: AddNewCardScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const AddNewCardScreen();
        },
      ),
      GoRoute(
        path: SecurityScreen.path,
        name: SecurityScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const SecurityScreen();
        },
      ),
      GoRoute(
        path: LanguageScreen.path,
        name: LanguageScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const LanguageScreen();
        },
      ),
      GoRoute(
        path: PrivacyPolicyScreen.path,
        name: PrivacyPolicyScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const PrivacyPolicyScreen();
        },
      ),
      GoRoute(
        path: HelpCenterScreen.path,
        name: HelpCenterScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const HelpCenterScreen();
        },
      ),
      GoRoute(
        path: CustomerServiceScreen.path,
        name: CustomerServiceScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const CustomerServiceScreen();
        },
      ),
      GoRoute(
        path: InviteFriendsScreen.path,
        name: InviteFriendsScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const InviteFriendsScreen();
        },
      ),

      // Main app with bottom navigation
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithBottomNav(child: child);
        },
        routes: [
          GoRoute(
            path: HomeScreen.path,
            name: HomeScreen.name,
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
            },
          ),
          GoRoute(
            path: CartScreen.path,
            name: CartScreen.name,
            builder: (BuildContext context, GoRouterState state) {
              return const CartScreen();
            },
          ),
          GoRoute(
            path: MyOrdersScreen.path,
            name: MyOrdersScreen.name,
            builder: (BuildContext context, GoRouterState state) {
              return const MyOrdersScreen();
            },
          ),
          GoRoute(
            path: WalletScreen.path,
            name: WalletScreen.name,
            builder: (BuildContext context, GoRouterState state) {
              return const WalletScreen();
            },
          ),
          GoRoute(
            path: ProfileScreen.path,
            name: ProfileScreen.name,
            builder: (BuildContext context, GoRouterState state) {
              return const ProfileScreen();
            },
          ),
        ],
      ),
    ],
  );
  static GoRouter get router => _router;
}
