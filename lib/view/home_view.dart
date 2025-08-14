// lib/ui/views/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/custom_app_drawer.dart';
import 'package:mersin_map_follow_app/utility/constant/widget/custom_search_bar.dart';
import 'package:mersin_map_follow_app/viewmodel/home_viewmodel.dart';
import 'package:mersin_map_follow_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    @override
  void initState() {
    super.initState();
    // token zaten login'de set edildiyse bu sadece güvence
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadMe();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..init(),
      child: const _HomeView(),
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
      // Drawer haritanın üstünde açılır
      drawerEnableOpenDragGesture: true,
      drawerScrimColor: Colors.black.withOpacity(.35),
      drawer: const AppDrawer(),

      body: Stack(
        children: [
          // Yandex Map
          YandexMap(
            mapObjects: vm.mapObjects,
            nightModeEnabled: true,
            onMapTap: (p) => vm.addMark(p),
            onMapCreated: (c) => vm.mapControllerCompleter.complete(c),
          ),

          // Üstte kayan menü + arama
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
