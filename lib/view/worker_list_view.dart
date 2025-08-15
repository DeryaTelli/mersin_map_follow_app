import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/text_theme.dart';
import 'package:mersin_map_follow_app/viewmodel/worker_list_viewmodel.dart';
import 'package:provider/provider.dart';

import '../viewmodel/user_viewmodel.dart'; // admin kontrolü için

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sayfa açılınca yükle
    return ChangeNotifierProvider(
      create: (_) => UsersListViewModel(
        context.read(), // UserRepository
        context.read(), // AuthRepository
      )..loadUsers(),
      child: const _UsersListView(),
    );
  }
}

class _UsersListView extends StatelessWidget {
  const _UsersListView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsersListViewModel>();
    final me = context.watch<UserViewModel>();

    // İSTEĞE BAĞLI: sadece admin bu sayfayı görsün
    if (!(me.isAdmin)) {
      return const Scaffold(
        body: Center(child: Text('Bu sayfayı yalnızca adminler görebilir.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Çalışanlar')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(vm.error!, textAlign: TextAlign.center),
              ),
            )
          : RefreshIndicator(
              onRefresh: vm.refresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: vm.users.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final u = vm.users[i];
                  final avatar = _genderAvatar(u.gender);
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: AssetImage(avatar)),
                    title: Text(
                      '${u.firstName} ${u.lastName}',
                      style: AppTextStyle.nunitoSansSemiBold12Black,
                    ),
                    subtitle: Text(u.email),
                  );
                },
              ),
            ),
    );
  }

  String _genderAvatar(String gender) {
    final g = gender.toLowerCase();
    if (g == 'female') return 'assets/icons/womenavatar.png';
    if (g == 'male') return 'assets/icons/manavatar.png';
    return 'assets/icons/manavatar.png';
  }
}
