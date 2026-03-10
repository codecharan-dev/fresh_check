/// Centralized key constants for all storage operations.
///
/// Every key used in [StorageService] or [SecuredStorageService] must
/// be declared here. No magic strings scattered across features.
///
/// Naming convention: camelCase, grouped by feature/domain.
abstract final class StorageKeys {
  // — Auth (Secure Storage)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // — User Preferences (Shared Prefs)
  static const String isFirstLaunch = 'is_first_launch';
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';

  // — App State (Shared Prefs)
  static const String onboardingDone = 'onboarding_done';
  static const String lastSyncTime = 'last_sync_time';
}
