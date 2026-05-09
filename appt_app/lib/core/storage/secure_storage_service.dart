import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;
  String? _fallbackToken;

  SecureStorageService(this._storage);

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } on PlatformException catch (e) {
      print('[Storage] Keychain entitlement missing or other error. Using in-memory fallback. Error: $e');
      _fallbackToken = token;
    }
  }

  Future<String?> getToken() async {
    if (_fallbackToken != null) return _fallbackToken;
    try {
      return await _storage.read(key: _tokenKey);
    } on PlatformException catch (e) {
      print('[Storage] Failed to read token: $e');
      return _fallbackToken;
    }
  }

  Future<void> clearToken() async {
    _fallbackToken = null;
    try {
      await _storage.delete(key: _tokenKey);
    } on PlatformException catch (e) {
      print('[Storage] Failed to delete token: $e');
    }
  }
}

