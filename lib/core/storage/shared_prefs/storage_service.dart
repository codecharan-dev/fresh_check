/// Abstract contract for local key-value storage.
///
/// Features depend on this interface — never on [SharedPreferences] directly.
/// This allows swapping implementations (Hive, MMKV, in-memory for tests)
/// without touching a single feature file.
///
/// Read operations are synchronous (in-memory cache after async init).
/// Write operations return [Future<bool>] (disk persistence).
abstract class StorageService {
  // ── Read ────────────────────────────────────────────────────────────────────
  String? getString(String key);
  int? getInt(String key);
  double? getDouble(String key);
  bool? getBool(String key);
  List<String>? getStringList(String key);

  // ── Write ───────────────────────────────────────────────────────────────────
  Future<bool> setString(String key, String value);
  Future<bool> setInt(String key, int value);
  Future<bool> setDouble(String key, double value);
  Future<bool> setBool(String key, bool value);
  Future<bool> setStringList(String key, List<String> value);

  // ── Delete ──────────────────────────────────────────────────────────────────
  Future<bool> remove(String key);
  Future<bool> clear();

  // ── Query ───────────────────────────────────────────────────────────────────
  bool containsKey(String key);
}
