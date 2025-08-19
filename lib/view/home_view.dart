// lib/ui/views/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:mersin_map_follow_app/utility/constant/widget/custom_search_bar.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/drawer/custom_drawer.dart';
import 'package:mersin_map_follow_app/viewmodel/home_viewmodel.dart';
import 'package:mersin_map_follow_app/viewmodel/user_viewmodel.dart';

// 🔽 Eğer HomeViewModel ctor'unda bu parametreleri bekliyorsa (önerilen):
// HomeViewModel({required TrackingRepository trackingRepo, required AuthRepository authRepo})

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // HomeViewModel’i burada oluşturuyoruz
      create: (ctx) => HomeViewModel(
        trackingRepo: ctx
            .read(), // Provider<TrackingRepository> üstte var olmalı
        authRepo: ctx.read(), // Provider<AuthRepository> üstte var olmalı
      )..init(),

      // ⬇️ provider artık ağaçta; güvenle erişebilirsin
      builder: (context, child) {
        // Bu bloğun bir kez çalışması için postFrameCallback
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final me = context.read<UserViewModel>();
          final home = context.read<HomeViewModel>();

          // Profil yükle (token header’ı set olur)
          await me.loadMe();

          // Role’e göre canlı takip başlat
          if (me.isUser) {
            await home.startUserTracking();
          } else if (me.isAdmin) {
            await home.startAdminListening();
          }
        });

        return const _HomeView();
      },
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      key: vm.scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawerScrimColor: Colors.black.withOpacity(.35),
      drawer: const RoleBasedDrawer(),
      body: Stack(
        children: [
          YandexMap(
            mapObjects: vm.mapObjects,
            nightModeEnabled: true,
            onMapTap: (p) => vm.addMark(p),
            onMapCreated: (c) async {
              vm.mapControllerCompleter.complete(c);
              // Kullanıcı konum katmanı
              await c.toggleUserLayer(
                visible: true,
                headingEnabled: false, // isterse true
                autoZoomEnabled:
                    false, // isterse true (ilk konuma otomatik zoom)
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: TopSearchBar(
              onMenuTap: vm.openDrawer,
              controller: vm.searchController,
              onChanged: vm.onSearchChanged,
              onClear: vm.clearSearch,
            ),
          ),
        ],
      ),
    );
  }
}
