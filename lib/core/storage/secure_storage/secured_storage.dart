import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_check/core/storage/secure_storage/secured_storage_service.dart';

/// Concrete [SecuredStorageService] backed by [FlutterSecureStorage].
///
/// Constructor is synchronous — safe for lazy singleton registration in DI.
class SecuredStorage implements SecuredStorageService {
  SecuredStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}