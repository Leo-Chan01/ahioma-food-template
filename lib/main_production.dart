import 'package:ahioma_food_template/app/app.dart';
import 'package:ahioma_food_template/bootstrap.dart';
import 'package:ahioma_food_template/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await bootstrap(() => const App());
}
