import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fresh_check/app/app.dart';
import 'package:fresh_check/app/di/injection.dart';
import 'package:fresh_check/config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter automatically sets FLUTTER_APP_FLAVOR when using --flavor flag.
  // Defaults to 'dev' when running without a flavor.
  const flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');
  EnvironmentConfig.initialize(flavor.isEmpty ? 'dev' : flavor);

  await Firebase.initializeApp(
    options: EnvironmentConfig.current.firebaseOptions,
  );

  initCoreDependencies();
  runApp(const FreshCheckApp());
}
