// lib/viewmodels/my_day_view_model.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:mersin_map_follow_app/model/work_day_location_model.dart'; // LocationPoint
import 'package:mersin_map_follow_app/repository/tracking_repository.dart';
import 'package:mersin_map_follow_app/repository/auth_repository.dart';

class MyDayViewModel extends ChangeNotifier {
  final TrackingRepository trackingRepo;
  final AuthRepository authRepo;

  MyDayViewModel({required this.trackingRepo, required this.authRepo});

  /// Yandex Map controller
  final Completer<YandexMapController> mapController =
      Completer<YandexMapController>();

  /// Seçili gün
  DateTime selectedDay = DateTime.now();

  /// UI state
  bool loading = false;
  String? error;

  /// Veriler
  List<LocationPoint> points = [];
  List<MapObject> mapObjects = [];

  /// İlk yükleme
  Future<void> init() async {
    await loadDay(selectedDay);
  }

  /// Gün seç
  Future<void> pickDay(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: selectedDay,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDay = DateTime(picked.year, picked.month, picked.day);
      await loadDay(selectedDay);
    }
  }

  /// Günün tüm kayıtlarını getir
  Future<void> loadDay(DateTime day) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final token = await authRepo.getSavedToken();
      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      points = await trackingRepo.myDay(token, day);
      await _renderOnMap();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Haritaya çiz
  Future<void> _renderOnMap() async {
    final ctrl = await mapController.future;
    mapObjects = [];

    if (points.isEmpty) {
      notifyListeners();
      return;
    }

    // 1) Marker'lar (zaman etiketiyle)
    final placemarks = <PlacemarkMapObject>[];
    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      placemarks.add(
        PlacemarkMapObject(
          mapId: MapObjectId('pt_$i'),
          point: Point(latitude: p.lat, longitude: p.lon),
          opacity: 1,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('assets/icons/mark.png'),
              scale: 0.3,
              rotationType: RotationType.noRotation,
            ),
          ),
          text: PlacemarkText(
            text: _fmtTime(p.createdAt),
            style: const PlacemarkTextStyle(), // default stil
          ),
        ),
      );
    }

    // 2) Rota (polyline)
    final polyline = PolylineMapObject(
      mapId: const MapObjectId('route'),
      polyline: Polyline(
        points: points
            .map((p) => Point(latitude: p.lat, longitude: p.lon))
            .toList(),
      ),
      strokeWidth: 3,
    );

    mapObjects = [...placemarks, polyline];

    // 3) Kamerayı tüm noktaları kapsayacak şekilde ayarla
    final lats = points.map((e) => e.lat).toList();
    final lons = points.map((e) => e.lon).toList();
    final south = lats.reduce((a, b) => a < b ? a : b);
    final north = lats.reduce((a, b) => a > b ? a : b);
    final west = lons.reduce((a, b) => a < b ? a : b);
    final east = lons.reduce((a, b) => a > b ? a : b);

    final bbox = BoundingBox(
      southWest: Point(latitude: south, longitude: west),
      northEast: Point(latitude: north, longitude: east),
    );

    // Eğer tüm noktalar aynı yerdeyse bounds hata verebilir -> fallback
    final hasArea = (south != north) || (west != east);
    if (hasArea) {
      await ctrl.moveCamera(
        CameraUpdate.newBounds(Geometry.fromBoundingBox(bbox) as BoundingBox),
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 0.8,
        ),
      );
    } else {
      await ctrl.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: south, longitude: west),
            zoom: 16,
          ),
        ),
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 0.8,
        ),
      );
    }

    notifyListeners();
  }

  String _fmtTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
