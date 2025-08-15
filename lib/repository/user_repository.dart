import '../model/user_model.dart';
import '../service/user_api.dart';

class UserRepository {
  final UserApi _api;
  UserRepository(this._api);
  Future<UserModel> me() => _api.me();

  Future<List<UserModel>> listUsersByRole(String role) =>
      _api.listUsers(role: role);
}
