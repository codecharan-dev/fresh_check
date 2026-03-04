import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_check/config/env.dart';
import 'package:fresh_check/config/firebase/firebase_options_staging.dart';

class StagingConfig implements AppConfig {
  @override
  String get name => 'FreshCheck Staging';

  @override
  Environment get environment => Environment.staging;

  @override
  String get baseUrl => 'https://api-staging.freshcheck.app';

  @override
  bool get enableLogging => true;

  @override
  FirebaseOptions get firebaseOptions =>
      DefaultFirebaseOptions.currentPlatform;
}
