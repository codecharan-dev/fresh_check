import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_check/config/env.dart';
import 'package:fresh_check/config/firebase/firebase_options_qa.dart';

class QaConfig implements AppConfig {
  @override
  String get name => 'FreshCheck QA';

  @override
  Environment get environment => Environment.qa;

  @override
  String get baseUrl => 'https://api-qa.freshcheck.app';

  @override
  bool get enableLogging => true;

  @override
  FirebaseOptions get firebaseOptions =>
      DefaultFirebaseOptions.currentPlatform;
}
