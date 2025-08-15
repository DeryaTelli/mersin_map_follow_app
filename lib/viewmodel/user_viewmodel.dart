// lib/viewmodel/user_viewmodel.dart
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../repository/user_repository.dart';
import '../repository/auth_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repo;
  final AuthRepository _authRepo;

  UserModel? user;
  bool isLoading = false;
  String? error;

  UserViewModel(this._repo, this._authRepo);

  Future<void> loadMe() async {
    isLoading = true;
    error = null;
    notifyListeners();

    // uygulama açılışında kaydedilmiş token'ı header'a set et
    await _authRepo.bootstrapAuth();

    try {
      user = await _repo.me();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool get isAdmin => user?.isAdmin ?? false;
  bool get isUser => user?.isUser ?? false;

  String get avatarAsset {
    final g = user?.gender.toLowerCase();
    if (g == 'female') return 'assets/icons/womenavatar.png';
    if (g == 'male') return 'assets/icons/manavatar.png';
    return 'assets/icons/manavatar.png';
  }

    Future<void> logout() async {
    await _authRepo.logout();  // token'ı sil + header'ı temizle
    user = null;               // profil bilgisini sıfırla
    notifyListeners();
  }
}
