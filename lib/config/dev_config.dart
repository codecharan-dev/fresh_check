import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_check/config/env.dart';
import 'package:fresh_check/config/firebase/firebase_options_dev.dart';

class DevConfig implements AppConfig {
  @override
  String get name => 'FreshCheck Dev';

  @override
  Environment get environment => Environment.dev;

  @override
  String get baseUrl => 'https://api-dev.freshcheck.app';

  @override
  bool get enableLogging => true;

  @override
  FirebaseOptions get firebaseOptions =>
      DefaultFirebaseOptions.currentPlatform;
}
