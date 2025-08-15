import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/service/map/yandex_map_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeViewModel extends ChangeNotifier {
  final mapControllerCompleter = Completer<YandexMapController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final searchController = TextEditingController();
  final focusNode = FocusNode();

  List<MapObject> mapObjects = [];

  bool _disposed = false;
  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> init() async {
    if (_disposed) return;
    if (!await LocationService().checkPermission()) {
      if (_disposed) return;
      await LocationService().requestPermission();
    }
    if (_disposed) return;
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    if (_disposed) return;
    AppLatLong location;
    const defLocation = TurkiyeMersinLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    if (_disposed) return;
    addUserObjects(location);
    await moveTo(location);
  }

  Future<void> moveTo(AppLatLong appLatLong) async {
    if (_disposed) return;
    final controller = await mapControllerCompleter.future;
    if (_disposed) return;
    await controller.moveCamera(
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 5),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
          zoom: 15,
        ),
      ),
    );
  }

  void addUserObjects(AppLatLong appLatLong) {
    if (_disposed) return;
    final me = PlacemarkMapObject(
      opacity: 1,
      mapId: const MapObjectId('currentLocation'),
      point: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/images/mark.png'),
          scale: 0.1,
          rotationType: RotationType.noRotation,
        ),
      ),
    );
    final area = CircleMapObject(
      mapId: const MapObjectId('currentLocationCircle'),
      circle: Circle(
        center: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
        radius: 250,
      ),
      strokeWidth: 0,
      fillColor: const Color(0xFF080A8E).withOpacity(.10),
    );

    mapObjects.addAll([area, me]);
    _safeNotify(); // notifyListeners yerine
  }

  void addMark(Point point) {
    if (_disposed) return;
    mapObjects.add(
      PlacemarkMapObject(
        opacity: 1,
        mapId: const MapObjectId('secondLocation'),
        point: point,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/images/mark.png'),
            scale: 0.1,
            rotationType: RotationType.noRotation,
          ),
        ),
      ),
    );
    _safeNotify();
  }

  void clearSearch() {
    if (_disposed) return;
    searchController.clear();
    onSearchChanged('');
    _safeNotify();
  }

  void onSearchChanged(String q) {
    // TODO: burada arama (workers) filtrelemesini tetikle
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();
}
