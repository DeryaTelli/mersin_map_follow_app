import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/token_response_model.dart';
import '../service/auth_api.dart';

class AuthRepository {
  final AuthApi _api;
  final FlutterSecureStorage _storage;
  static const _kTokenKey = 'access_token';

  AuthRepository(this._api, this._storage);

  Future<TokenResponse> login(String email, String password) async {
    final token = await _api.login(email: email, password: password);
    await _storage.write(key: _kTokenKey, value: token.accessToken);
    _api.setAuthToken(token.accessToken); // <-- ÖNEMLİ
    return token;
  }

  Future<String?> getSavedToken() => _storage.read(key: _kTokenKey);

  Future<void> bootstrapAuth() async {
    // app açılışında çağır
    final t = await getSavedToken();
    _api.setAuthToken(t);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _kTokenKey);
    _api.setAuthToken(null);
  }

  Future<void> logout() async {
    await clearToken(); // secure storage'tan siler
    // _api.setAuthToken(null) clearToken içinde zaten çağrılıyorsa tekrar gerekmez
  }
}
