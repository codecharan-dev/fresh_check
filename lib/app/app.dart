import 'package:flutter/material.dart';
import 'package:fresh_check/app/app_exports.dart';
import 'package:fresh_check/app/di/injection.dart';
import 'package:fresh_check/config/env.dart';
import 'package:go_router/go_router.dart';

/// Root widget of the FreshCheck application.
///
/// Uses [MaterialApp.router] with the [GoRouter] resolved from GetIt.
class FreshCheckApp extends StatelessWidget {
  const FreshCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: sl<AppConfig>().name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: sl<GoRouter>(),
    );
  }
}
