import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ahioma_food_template/core/routing/app_router.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/tenant_remote_data_source.dart';
import 'package:ahioma_food_template/core/web/connectivity_provider.dart';
import 'package:ahioma_food_template/core/web/connectivity_service.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/orders/presentation/provider/orders_provider.dart';
import 'package:ahioma_food_template/features/wishlist/presentation/provider/wishlist_provider.dart';
import 'package:ahioma_food_template/injection_container.dart';
import 'package:ahioma_food_template/l10n/l10n.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:ahioma_food_template/shared/theme/app_theme.dart';
import 'package:ahioma_food_template/shared/theme/theme_provider.dart';
import 'package:ahioma_food_template/shared/widgets/connectivity_overlay.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(sl<ConnectivityService>()),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final authProvider = AuthProvider();
            unawaited(authProvider.initialize());
            return authProvider;
          },
        ),
        ChangeNotifierProvider(create: (context) => AccountSetupProvider()),
        ChangeNotifierProvider.value(value: sl<TenantRemoteDataSource>()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return OrientationBuilder(
                builder: (context, orientation) {
                  return ScreenUtilInit(
                    designSize: const Size(375, 812),
                    minTextAdapt: true,
                    useInheritedMediaQuery: true,
                    ensureScreenSize: true,
                    rebuildFactor: (old, data) => true,
                    builder: (context, child) {
                      return Consumer<ConnectivityProvider>(
                        builder: (context, connectivityProvider, _) {
                          return ConnectivityOverlay(
                            connectivityStatus: connectivityProvider.status,
                            child: Consumer<TenantRemoteDataSource>(
                              builder: (context, tenantDataSource, _) {
                                return MaterialApp.router(
                                  title: tenantDataSource.appTitle,
                                  theme: AppTheme.lightTheme(
                                    primaryColor: tenantDataSource.primaryColor,
                                    secondaryColor:
                                        tenantDataSource.secondaryColor,
                                  ),
                                  darkTheme: AppTheme.darkTheme(
                                    primaryColor: tenantDataSource.primaryColor,
                                    secondaryColor:
                                        tenantDataSource.secondaryColor,
                                  ),
                                  themeMode: _getThemeMode(themeProvider),
                                  localizationsDelegates:
                                      AppLocalizations.localizationsDelegates,
                                  supportedLocales:
                                      AppLocalizations.supportedLocales,
                                  routerConfig: AppRouter.router,
                                  scaffoldMessengerKey:
                                      GlobalSnackBar.scaffoldMessengerKey,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
    // return MaterialApp(
    //   theme: ThemeData(
    //     appBarTheme: AppBarTheme(
    //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //     ),
    //     useMaterial3: true,
    //   ),
    //   localizationsDelegates: AppLocalizations.localizationsDelegates,
    //   supportedLocales: AppLocalizations.supportedLocales,
    //   home: const HomeScreen(),
    // );
  }

  material.ThemeMode _getThemeMode(ThemeProvider themeProvider) {
    switch (themeProvider.themeMode) {
      case AppThemeMode.light:
        // return material.ThemeMode.light;
        return material.ThemeMode.light;
      case AppThemeMode.dark:
        return material.ThemeMode.dark;
      case AppThemeMode.system:
        return material.ThemeMode.system;
    }
  }
}
