import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mersin_map_follow_app/model/token_response_model.dart';
import 'package:mersin_map_follow_app/service/auth_api.dart';


class AuthRepository {
  final AuthApi _api;
  final FlutterSecureStorage _storage;

  static const _kTokenKey = 'access_token';

  AuthRepository(this._api, this._storage);

  Future<TokenResponse> login(String email, String password) async {
    final token = await _api.login(email: email, password: password);
    await _storage.write(key: _kTokenKey, value: token.accessToken);
    return token;
  }

  Future<String?> getSavedToken() => _storage.read(key: _kTokenKey);

  Future<void> clearToken() => _storage.delete(key: _kTokenKey);
}
