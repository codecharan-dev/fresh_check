// Environment configuration system.
// Resolves the current environment from the Flutter flavor and provides
// the correct Firebase options and base URLs for each environment.
import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_check/config/dev_config.dart';
import 'package:fresh_check/config/firebase/firebase_options_dev.dart' as dev_fb;
import 'package:fresh_check/config/firebase/firebase_options_prod.dart' as prod_fb;
import 'package:fresh_check/config/firebase/firebase_options_qa.dart' as qa_fb;
import 'package:fresh_check/config/firebase/firebase_options_staging.dart' as staging_fb;
import 'package:fresh_check/config/prod_config.dart';
import 'package:fresh_check/config/qa_config.dart';
import 'package:fresh_check/config/staging_config.dart';

enum Environment { dev, qa, staging, prod }

abstract class AppConfig {
  String get name;
  Environment get environment;
  String get baseUrl;
  bool get enableLogging;
  FirebaseOptions get firebaseOptions;
}

class EnvironmentConfig {
  EnvironmentConfig._();

  static late final AppConfig _current;

  static AppConfig get current => _current;

  static void initialize(String? flavor) {
    final env = _resolveEnvironment(flavor);
    _current = _configForEnvironment(env);
  }

  static Environment _resolveEnvironment(String? flavor) {
    switch (flavor?.toLowerCase()) {
      case 'dev':
        return Environment.dev;
      case 'qa':
        return Environment.qa;
      case 'staging':
        return Environment.staging;
      case 'prod':
        return Environment.prod;
      default:
        return Environment.dev;
    }
  }

  static AppConfig _configForEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        return DevConfig();
      case Environment.qa:
        return QaConfig();
      case Environment.staging:
        return StagingConfig();
      case Environment.prod:
        return ProdConfig();
    }
  }

  static FirebaseOptions firebaseOptionsFor(Environment env) {
    switch (env) {
      case Environment.dev:
        return dev_fb.DefaultFirebaseOptions.currentPlatform;
      case Environment.qa:
        return qa_fb.DefaultFirebaseOptions.currentPlatform;
      case Environment.staging:
        return staging_fb.DefaultFirebaseOptions.currentPlatform;
      case Environment.prod:
        return prod_fb.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
