import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/custom_button.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/custom_text_field.dart';
import 'package:mersin_map_follow_app/view/home_view.dart';
import 'package:provider/provider.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
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
                controller: vm.emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Şifre',
                controller: vm.passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              CustomButton(
                height: 48,
                width: double.infinity,
                text: 'Giriş Yap',
                onPressed: () {
                  if (!vm.isLoading) {
                    vm.login().then((ok) {
                      if (ok && context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      } else if (vm.error != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(vm.error!)),
                        );
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
