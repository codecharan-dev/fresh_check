import 'package:flutter/material.dart';
import 'package:fresh_check/app/di/injection.dart';
import 'package:fresh_check/config/env.dart';
import 'package:go_router/go_router.dart';

/// Root widget of the FreshCheck application.
///
/// Uses [MaterialApp.router] with the [GoRouter] resolved from GetIt.
/// Theme will be replaced with [AppTheme.light] once the theme layer is built.
class FreshCheckApp extends StatelessWidget {
  const FreshCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: sl<AppConfig>().name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: sl<GoRouter>(),
    );
  }
}
