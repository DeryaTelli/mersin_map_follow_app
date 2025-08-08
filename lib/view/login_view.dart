import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/custom_button.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/custom_text_field.dart';
import 'package:mersin_map_follow_app/view/home_view.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/images/loginPicture.png', height: 300),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Email',
                controller: _viewModel.emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Şifre',
                controller: _viewModel.passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              CustomButton(
                height: 48,
                width: double.infinity,
                text: 'Giriş Yap',
                onPressed: () {
                  _viewModel.login();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
