import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/color/colors.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/drawer/custom_header_drawer.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/drawer/custom_tile_drawer.dart';
import 'package:mersin_map_follow_app/view/worker_list_view.dart';
import 'package:mersin_map_follow_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();
    final u = vm.user!;

    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.background,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DrawerHeaderCard(
              avatar: vm.avatarAsset,
              name: '${u.firstName} ${u.lastName}',
              email: u.email,
            ),
            const SizedBox(height: 8),

            DrawerTile(
              icon: Icons.groups,
              label: 'Çalışanlar',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UsersListPage(),
                  ),
                );
              },
            ),
            DrawerTile(
              icon: Icons.apartment,
              label: 'Belediyeler',
              onTap: () {
                /* TODO */
              },
            ),
            const Divider(height: 24),
            DrawerTile(
              icon: Icons.logout,
              label: 'Çıkış Yap',
              onTap: () async {
                await context.read<UserViewModel>().logout();
                Navigator.of(context).pop();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
