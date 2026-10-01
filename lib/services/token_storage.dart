import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();
  static const _key = 'access_token';

  Future<void> saveToken(String token) async {
    // write under a key like 'access_token'
    await _storage.write(key: _key, value: token);
  }

  Future<String?> readToken() async {
    return await _storage.read(key: _key);
  }

  Future<void> deleteToken() async {
    // for logout
    await _storage.delete(key: _key);
  }
}