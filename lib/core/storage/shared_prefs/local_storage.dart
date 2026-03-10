import 'package:fresh_check/core/storage/shared_prefs/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Concrete [StorageService] backed by [SharedPreferences].
///
/// Requires an already-initialized [SharedPreferences] instance.
/// Initialization is async and happens once in [SplashBloc] before navigation.
/// After that, all reads are synchronous from the in-memory cache.
class LocalStorage implements StorageService {
  LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  // ── Read ────────────────────────────────────────────────────────────────────

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  double? getDouble(String key) => _prefs.getDouble(key);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // ── Write ───────────────────────────────────────────────────────────────────

  @override
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  @override
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);

  @override
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  // ── Delete ──────────────────────────────────────────────────────────────────

  @override
  Future<bool> remove(String key) => _prefs.remove(key);

  @override
  Future<bool> clear() => _prefs.clear();

  // ── Query ───────────────────────────────────────────────────────────────────

  @override
  bool containsKey(String key) => _prefs.containsKey(key);
}
