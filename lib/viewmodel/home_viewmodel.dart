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

  Future<void> init() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = TurkiyeMersinLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    addUserObjects(location);
    moveTo(location);
  }

  Future<void> moveTo(AppLatLong appLatLong) async {
    (await mapControllerCompleter.future).moveCamera(
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
    notifyListeners();
  }

  void addMark(Point point) {
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
    notifyListeners();
  }

  void onSearchChanged(String q) {
    // TODO: burada arama (workers) filtrelemesini tetikle
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged('');
    notifyListeners();
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();
}
