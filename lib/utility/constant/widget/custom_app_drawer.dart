import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/color/colors.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/text_theme.dart';
import 'package:mersin_map_follow_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //giris yapan kullaniciya gora avatar ayarlanmasi
    // final userVM = context.watch<UserViewModel>();
    //final user = userVM.user;

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.78,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          children: [
            // Üst kart
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/icons/manavatar.png'),
                  ),
                  const SizedBox(height: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hoşgeldiniz',
                        style: AppTextStyle.nunitoExtraBold16White,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kullanıcı\nkullanici@gmail.com',
                        style: AppTextStyle.nunitoRegular14Purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(
                Icons.history,
                color: AppColors.primaryColor,
                size: 24,
              ),
              title: const Text(
                'Geçmiş Ziyaretler',
                style: AppTextStyle.nunitoBold16White,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: AppColors.primaryColor,
                size: 24,
              ),
              title: const Text(
                'Çıkış Yap',
                style: AppTextStyle.nunitoBold16White,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
