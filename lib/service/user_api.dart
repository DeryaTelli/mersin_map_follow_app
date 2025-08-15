import 'package:dio/dio.dart';
import '../model/user_model.dart';

class UserApi {
  final Dio _dio; // AuthApi.client verilecek
  UserApi(this._dio);

  Future<UserModel> me() async {
    final res = await _dio.get('/users/me');
    return UserModel.fromJson(res.data as Map<String, dynamic>);
  }

   // NEW: role=user listesi
  Future<List<UserModel>> listUsers({String? role}) async {
    final res = await _dio.get('/users/admin/users',
        queryParameters: role != null ? {'role': role} : null);
    final data = res.data as List<dynamic>;
    return data.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
