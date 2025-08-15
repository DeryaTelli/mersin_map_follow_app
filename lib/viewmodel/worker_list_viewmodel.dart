import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../repository/user_repository.dart';
import '../repository/auth_repository.dart';

class UsersListViewModel extends ChangeNotifier {
  final UserRepository _userRepo;
  final AuthRepository _authRepo;

  UsersListViewModel(this._userRepo, this._authRepo);

  bool loading = false;
  String? error;
  List<UserModel> users = [];

  Future<void> loadUsers() async {
    loading = true; error = null; notifyListeners();

    // header'a token set olsun (soğuk başlatmada)
    await _authRepo.bootstrapAuth();

    try {
      users = await _userRepo.listUsersByRole('user');
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> refresh() => loadUsers();
}
