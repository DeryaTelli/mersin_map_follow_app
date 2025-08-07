import 'package:flutter/material.dart';

class LoginViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    final email = emailController.text;
    final password = passwordController.text;

    // Giriş işlemleri burada yapılır
    debugPrint('Email: $email');
    debugPrint('Password: $password');
  }
}
