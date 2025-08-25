import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/viewmodel/worker_day_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MyDayPage extends StatelessWidget {
  const MyDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyDayViewModel(
        trackingRepo: context.read(), // locator/di: TrackingRepository
        authRepo: context.read(),     // locator/di: AuthRepository
      )..init(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyDayViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Günlük Ziyaretler (${_fmtDate(vm.selectedDay)})"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => vm.pickDay(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => vm.loadDay(vm.selectedDay),
          ),
        ],
      ),
      body: Column(
        children: [
          // Harita
          SizedBox(
            height: 280,
            child: YandexMap(
              onMapCreated: (c) => vm.mapController.complete(c),
              mapObjects: vm.mapObjects,
            ),
          ),

          if (vm.loading) const LinearProgressIndicator(),
          if (vm.error != null) Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Hata: ${vm.error}", style: const TextStyle(color: Colors.red)),
          ),

          // Liste
          Expanded(
            child: vm.points.isEmpty
                ? const Center(child: Text("Bu gün için kayıt yok"))
                : ListView.separated(
                    itemCount: vm.points.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final p = vm.points[i];
                      return ListTile(
                        leading: const Icon(Icons.place),
                        title: Text("${p.lat.toStringAsFixed(6)}, ${p.lon.toStringAsFixed(6)}"),
                        subtitle: Text("${_fmtTime(p.createdAt)} • user_id=${p.userId}"),
                        onTap: () async {
                          final ctrl = await vm.mapController.future;
                          await ctrl.moveCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: Point(latitude: p.lat, longitude: p.lon),
                                zoom: 16,
                              ),
                            ),
                            animation: const MapAnimation(type: MapAnimationType.smooth, duration: 0.6),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}";
  static String _fmtTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
}
