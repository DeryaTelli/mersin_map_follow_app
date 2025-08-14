import 'package:dio/dio.dart';
import '../model/user_model.dart';

class UserApi {
  final Dio _dio; // AuthApi.client verilecek
  UserApi(this._dio);

  Future<UserModel> me() async {
    final res = await _dio.get('/users/me');
    return UserModel.fromJson(res.data as Map<String, dynamic>);
  }
}
