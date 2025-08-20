import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/repository/auth_repository.dart';
import 'package:mersin_map_follow_app/repository/tracking_repository.dart';
import 'package:mersin_map_follow_app/service/map/yandex_map_service.dart';
import 'package:mersin_map_follow_app/utility/constant/theme/text_theme.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeViewModel extends ChangeNotifier {
  final mapControllerCompleter = Completer<YandexMapController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  final focusNode = FocusNode();

  // Map içerikleri
  List<MapObject> mapObjects = [];
  Map<int, PlacemarkMapObject> userMarkers = {}; // user_id -> marker

  // Repos
  final TrackingRepository trackingRepo;
  final AuthRepository authRepo;

  // Subscriptions
  StreamSubscription? _posSub;
  StreamSubscription? _adminSub;

  // Lifecycle
  bool _disposed = false;
  void _safeNotify() {
    if (!_disposed) {
      debugPrint('HomeViewModel: notifyListeners() çağrıldı');
      notifyListeners();
    }
  }

  HomeViewModel({required this.trackingRepo, required this.authRepo});

  @override
  void dispose() {
    debugPrint('HomeViewModel dispose() çağrıldı');
    _disposed = true;
    _adminSub?.cancel();
    _posSub?.cancel();
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // --------- USER: cihaz konumu gönderimi (foreground tracking) ----------
  Future<void> startUserTracking() async {
    debugPrint('startUserTracking() başlatıldı');
    final token = await authRepo.getSavedToken();

    if (token == null) {
      debugPrint('❌ Token bulunamadı, tracking başlatılamıyor');
      return;
    }

    debugPrint('📡 Token bulundu: $token');
    debugPrint('🌐 WebSocket bağlantısı kuruluyor (user/foreground)...');

    final stream = await trackingRepo.startForegroundTracking(token);

    // Eğer daha önce subscription varsa iptal et
    await _posSub?.cancel();
    bool firstFixMoved = false;

    _posSub = stream.listen(
      (pos) async {
        final here = AppLatLong(lat: pos.latitude, long: pos.longitude);

        // Konum logları
        debugPrint(
          '📍 Yeni konum alındı -> lat=${pos.latitude}, lon=${pos.longitude}',
        );

        // Sunucuya gönderilen event logu
        debugPrint(
          '📤 [WS SEND] -> {"event":"loc","lat":${pos.latitude},"lon":${pos.longitude},"ts":${DateTime.now().millisecondsSinceEpoch}}',
        );

        // Simüle: Server'dan ack cevabı
        debugPrint(
          '📥 [WS RESPONSE] -> {"event":"ack","msg":"location received","lat":${pos.latitude},"lon":${pos.longitude}}',
        );

        if (!firstFixMoved) {
          await moveTo(here);
          firstFixMoved = true;
        }
      },
      onError: (e, st) {
        debugPrint('❌ WebSocket hata: $e\n$st');
      },
      onDone: () {
        debugPrint('✅ WebSocket bağlantısı kapandı');
      },
    );
  }

  Future<void> stopUserTracking() async {
    debugPrint('stopUserTracking() çağrıldı');
    await trackingRepo.stopForegroundTracking();
    await _posSub?.cancel();
    _posSub = null;
    debugPrint('📤 [WS SEND] -> {"event":"stop","role":"user"}');
    debugPrint(
      '📥 [WS RESPONSE] -> {"event":"stopped","msg":"tracking stopped"}',
    );
    debugPrint('✅ Tracking durduruldu ve subscription iptal edildi');
  }

  // --------- ADMIN: snapshot + canlı dinleme ----------
  Future<void> startAdminListening() async {
    debugPrint('startAdminListening() başlatıldı');
    final token = await authRepo.getSavedToken();
    if (token == null) {
      debugPrint('❌ startAdminListening: Token bulunamadı');
      return;
    }

    try {
      // 1) REST Snapshot
      debugPrint('🌐 [REST CALL] -> adminLast() çağrılıyor...');
      final last = await trackingRepo.adminLast();
      debugPrint('📥 [REST RESPONSE] -> ${last.length} kayıt döndü');

      for (final item in last) {
        debugPrint(
          '📍 REST snapshot -> user=${item['user_id']} '
          'name=${item['first_name']} ${item['last_name']} '
          'lat=${item['lat']} lon=${item['lon']}',
        );

        _upsertUserMarker(
          item['user_id'] as int,
          '${item['first_name']} ${item['last_name']}',
          (item['lat'] as num).toDouble(),
          (item['lon'] as num).toDouble(),
        );
      }
      _safeNotify();

      // 2) WebSocket Live
      debugPrint('🌐 [WS CONNECT] -> adminLive dinlemeye başlanıyor...');
      _adminSub?.cancel();
      _adminSub = trackingRepo
          .adminLive(token)
          .listen(
            (event) {
              debugPrint('📥 [WS EVENT] -> $event');

              final kind = event['event'];
              if (kind == 'snapshot') {
                final items = (event['items'] as List)
                    .cast<Map<String, dynamic>>();
                debugPrint('📥 [WS SNAPSHOT] -> ${items.length} kayıt');
                for (final m in items) {
                  debugPrint(
                    '📍 WS snapshot -> user=${m['user_id']} '
                    'name=${m['first_name']} ${m['last_name']} '
                    'lat=${m['lat']} lon=${m['lon']}',
                  );
                  _upsertUserMarker(
                    m['user_id'] as int,
                    '${m['first_name'] ?? ''} ${m['last_name'] ?? ''}',
                    (m['lat'] as num).toDouble(),
                    (m['lon'] as num).toDouble(),
                  );
                }
                _safeNotify();
                return;
              }

              if (kind == 'loc') {
                debugPrint(
                  '📍 [WS LOC UPDATE] -> user=${event['user_id']} '
                  'lat=${event['lat']} lon=${event['lon']}',
                );
                _upsertUserMarker(
                  event['user_id'] as int,
                  '',
                  (event['lat'] as num).toDouble(),
                  (event['lon'] as num).toDouble(),
                );
                _safeNotify();

                // Simüle: admin’e server’dan ack cevabı
                debugPrint(
                  '📤 [WS SEND] -> {"event":"ack","msg":"location received","user_id":${event['user_id']}}',
                );
              }
            },
            onError: (e, st) {
              debugPrint('❌ [WS ERROR] -> $e\n$st');
            },
            onDone: () {
              debugPrint('✅ [WS CLOSED] -> bağlantı kapandı');
            },
            cancelOnError: false,
          );
    } catch (e, st) {
      debugPrint('❌ startAdminListening hata: $e\n$st');
    }
  }

  // --------- Init & konum alma ----------
  Future<void> init() async {
    debugPrint('init() çağrıldı');
    if (_disposed) return;
    if (!await LocationService().checkPermission()) {
      debugPrint('init: konum izni yok, isteniyor...');
      if (_disposed) return;
      await LocationService().requestPermission();
    }
    if (_disposed) return;
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    debugPrint('_fetchCurrentLocation() çağrıldı');
    if (_disposed) return;
    AppLatLong location;
    const defLocation = TurkiyeMersinLocation(); // turkiye konumu
    try {
      location = await LocationService().getCurrentLocation();
      debugPrint(
        '_fetchCurrentLocation: cihaz konumu bulundu ${location.lat}, ${location.long}',
      );
    } catch (e) {
      debugPrint('_fetchCurrentLocation hata: $e, default konum kullanılacak');
      location = defLocation;
    }
    if (_disposed) return;
    addUserObjects(location);
    await moveTo(location);
  }

  Future<void> moveTo(AppLatLong appLatLong) async {
    if (_disposed) return;
    debugPrint('moveTo: lat=${appLatLong.lat}, lon=${appLatLong.long}');
    final controller = await mapControllerCompleter.future;
    if (_disposed) return;
    await controller.moveCamera(
      animation: const MapAnimation(
        type: MapAnimationType.smooth,
        duration: 0.8,
      ),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
          zoom: 15,
        ),
      ),
    );
    debugPrint('moveTo: kamera hareketi tamamlandı');
  }

  // --------- Benim marker + alan ----------
  void addUserObjects(AppLatLong appLatLong) {
    debugPrint('addUserObjects: lat=${appLatLong.lat}, lon=${appLatLong.long}');
    if (_disposed) return;

    final me = PlacemarkMapObject(
      opacity: 1,
      mapId: const MapObjectId('currentLocation'),
      point: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/icons/mark.png'),
          scale: 0.1,
          rotationType: RotationType.noRotation,
        ),
      ),
    );
    mapObjects = List<MapObject>.from(mapObjects)..addAll([me]);
    debugPrint('addUserObjects: kendi marker ve alan eklendi');
    _safeNotify();
  }

  void addMark(Point point) {
    debugPrint('addMark: point=$point');
    if (_disposed) return;
    final marker = PlacemarkMapObject(
      opacity: 1,
      mapId: const MapObjectId('secondLocation'),
      point: point,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/icons/mark.png'),
          scale: 0.1,
          rotationType: RotationType.noRotation,
        ),
      ),
    );
    mapObjects = List<MapObject>.from(mapObjects)..add(marker);
    debugPrint('addMark: yeni marker eklendi');
    _safeNotify();
  }


  // --------- Marker yönetimi ----------
  void _upsertUserMarker(int userId, String name, double lat, double lon) {
    debugPrint('_upsertUserMarker: user=$userId name=$name lat=$lat lon=$lon');
    final id = MapObjectId('u_$userId');

    PlacemarkText? text;
    if (name.isNotEmpty) {
      text = PlacemarkText(
        text: name,
        style: PlacemarkTextStyle(
          color: Colors.white,
        ),
      );
    }

    final marker = PlacemarkMapObject(
      mapId: id,
      point: Point(latitude: lat, longitude: lon),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/icons/mark.png'),
          scale: 0.5,
          rotationType: RotationType.noRotation,
        ),
      ),
      text: text,
    );

    final idx = mapObjects.indexWhere((e) => e.mapId == id);
    if (idx >= 0) {
      final next = List<MapObject>.from(mapObjects);
      next[idx] = marker;
      mapObjects = next;
      debugPrint('_upsertUserMarker: mevcut marker güncellendi (user=$userId)');
    } else {
      mapObjects = List<MapObject>.from(mapObjects)..add(marker);
      debugPrint('_upsertUserMarker: yeni marker eklendi (user=$userId)');
    }

    userMarkers[userId] = marker;
  }

  // --------- UI helpers ----------
  void clearSearch() {
    debugPrint('clearSearch() çağrıldı');
    if (_disposed) return;
    searchController.clear();
    onSearchChanged('');
    _safeNotify();
  }

  void onSearchChanged(String q) {
    debugPrint('onSearchChanged: query="$q"');
    // TODO: burada arama (workers) filtrelemesini tetikle
  }

  void openDrawer() {
    debugPrint('openDrawer() çağrıldı');
    scaffoldKey.currentState?.openDrawer();
  }
}
