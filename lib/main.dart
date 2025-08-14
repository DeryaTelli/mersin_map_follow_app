import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mersin_map_follow_app/repository/auth_repository.dart';
import 'package:mersin_map_follow_app/service/auth_api.dart';
import 'package:mersin_map_follow_app/utility/constant/color/colors.dart';
import 'package:mersin_map_follow_app/view/login_view.dart';
import 'package:mersin_map_follow_app/viewmodel/login_viewmodel.dart';
import 'package:mersin_map_follow_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  ); // Android emülatör için
  final api = AuthApi(baseUrl: baseUrl);
  final repo = AuthRepository(api, const FlutterSecureStorage());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel(repo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: LoginView(),
    );
  }
}
