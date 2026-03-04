import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_check/config/env.dart';
import 'package:fresh_check/config/firebase/firebase_options_prod.dart';

class ProdConfig implements AppConfig {
  @override
  String get name => 'FreshCheck';

  @override
  Environment get environment => Environment.prod;

  @override
  String get baseUrl => 'https://api.freshcheck.app';

  @override
  bool get enableLogging => false;

  @override
  FirebaseOptions get firebaseOptions =>
      DefaultFirebaseOptions.currentPlatform;
}
