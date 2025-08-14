import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/drawer/custom_admin_drawer.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/drawer/custom_user_drawer.dart';
import 'package:mersin_map_follow_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';


class RoleBasedDrawer extends StatelessWidget {
  const RoleBasedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();

    if (vm.isLoading) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }
    if (vm.user == null) {
      return const Drawer(child: Center(child: Text('Oturum bulunamadı')));
    }

    return vm.isAdmin ? const AdminDrawer() : const UserDrawer();
  }
}
