import 'package:flutter/foundation.dart';
import 'package:mersin_map_follow_app/model/user_model.dart';


class UserViewModel extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  // Örnek: login sonrasında set edersin
  void setUser(AppUser u) {
    _user = u;
    notifyListeners();
  }

  // Çıkış
  void logout() {
    _user = null;
    notifyListeners();
  }
}