
/// Abstract contract for sensitive key-value storage (tokens, credentials).
///
/// All operations are async — the OS encryption layer (Keychain on iOS,
/// EncryptedSharedPreferences on Android) decrypts on every read.
///
/// Never store preferences (theme, flags) here. Use [StorageService] instead.
abstract class SecuredStorageService {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> deleteAll();
}


