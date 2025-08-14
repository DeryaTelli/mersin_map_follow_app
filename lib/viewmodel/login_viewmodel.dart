// lib/viewmodel/login_viewmodel.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../repository/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? error;

  LoginViewModel(this._repo);

  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      error = 'Email ve şifre gerekli';
      notifyListeners();
      return false;
    }

    if (isLoading) {
      debugPrint("⏳ Giriş işlemi zaten devam ediyor...");
      return false;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    // ---- Request log
    debugPrint("📤 [REQUEST]");
    debugPrint("➡️ Email: $email");
    debugPrint("➡️ Password: ${'*' * password.length}"); // maskeli

    try {
      final result = await _repo.login(email, password);

      // ---- Success log (JSON güvenli)
      debugPrint("\n📥 [RESPONSE]");
      debugPrint("✅ Giriş başarılı!");
      debugPrint("➡️ Dönen tip: ${result.runtimeType}");
      // Sadece Map/List gibi JSON'lanabilir türlerde jsonEncode dene
      try {
        if (result is Map || result is List) {
          debugPrint("➡️ Dönen veri (json): ${jsonEncode(result)}");
        } else {
          // toJson varsa deneyelim
          final dynamic maybeToJson =
              (result as dynamic);
          if (maybeToJson is dynamic && (result as dynamic).toJson != null) {
            // toJson çağrısı başarılıysa encode et
            final encoded = jsonEncode((result as dynamic).toJson());
            debugPrint("➡️ Dönen veri (json via toJson): $encoded");
          } else {
            // değilse düz string bas
            debugPrint("➡️ Dönen veri (string): $result");
          }
        }
      } catch (_) {
        // jsonEncode yine patlarsa stringe düş
        debugPrint("➡️ Dönen veri (string fallback): $result");
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // ---- Error log
      debugPrint("\n📥 [RESPONSE]");
      debugPrint("❌ Giriş başarısız!");
      debugPrint("❌ Hata: $e");

      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
