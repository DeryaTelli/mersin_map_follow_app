import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mersin_map_follow_app/repository/auth_repository.dart';
import 'package:mersin_map_follow_app/repository/tracking_repository.dart';
import 'package:mersin_map_follow_app/repository/user_repository.dart';
import 'package:mersin_map_follow_app/service/auth_api.dart';
import 'package:mersin_map_follow_app/service/dio/dio_setting.dart';
import 'package:mersin_map_follow_app/service/tracking_api.dart';
import 'package:mersin_map_follow_app/service/user_api.dart';
import 'package:mersin_map_follow_app/utility/constant/color/colors.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/appbar_theme.dart';
import 'package:mersin_map_follow_app/view/home_view.dart';
import 'package:mersin_map_follow_app/view/login_view.dart';
import 'package:mersin_map_follow_app/viewmodel/login_viewmodel.dart';
import 'package:mersin_map_follow_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  final dio = DioSettings().dio;
  const baseUrl = 'http://13.62.100.77';
  const baseWs = 'ws://13.62.100.77';

  final authApi = AuthApi(baseUrl: baseUrl);
  final userApi = UserApi(authApi.client);
  final trackingApi = TrackingApi(authApi.client, wsBase: baseWs);

  final authRepo = AuthRepository(authApi, const FlutterSecureStorage());
  final userRepo = UserRepository(userApi);
  final trackingRepo = TrackingRepository(trackingApi);

  runApp(
    MultiProvider(
      providers: [
        // 🔹 Repositories as plain providers
        Provider<AuthRepository>.value(value: authRepo),
        Provider<UserRepository>.value(value: userRepo),
        Provider<TrackingRepository>.value(value: trackingRepo),

        // 🔹 ViewModels
        ChangeNotifierProvider(create: (_) => LoginViewModel(authRepo)),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(userRepo, authRepo),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // app açılışında token'ı header'a koy + profili çek
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AuthRepository>().bootstrapAuth();
      await context.read<UserViewModel>().loadMe();
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (_) => const LoginView(),
        '/home': (_) => const HomePage(),
      },
      initialRoute: '/login',
      theme: AppTheme.lightTheme,
      home: LoginView(),
    );
  }
}
