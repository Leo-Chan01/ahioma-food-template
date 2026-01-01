import 'dart:async';

import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/tenant_remote_data_source.dart';
import 'package:ahioma_food_template/injection_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Load environment variables
  await dotenv.load();

  // Initialize dependencies
  await initializeAppDependencies();

  // Initialize tenant configuration (fetch business profile)
  await sl<TenantRemoteDataSource>().initialize();

  runApp(await builder());
}
