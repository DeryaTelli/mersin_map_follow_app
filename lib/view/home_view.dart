import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mersin_map_follow_app/service/map/yandex_map_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _initPermission().ignore();
  }

  List<MapObject> mapObject = [];
  //AppLatLong? currentLocation;
  AnimationController? _animationController;
  Animation<double>? _animation;
  double opacity = 0;

  final mapControllerCompleter = Completer<YandexMapController>();
  @override
  Widget build(BuildContext context) {
    // addObject(appLatLong: currentLocation ?? const UzbekistanLocation());
    return Scaffold(
        body: Stack(
      children: [
        YandexMap(
          mapObjects: mapObject,
          onMapTap: (point) {
            addMark(point: point);
          },
          nightModeEnabled: true,
          onMapCreated: (controller) {
            mapControllerCompleter.complete(controller);
          },
        ),
        // Positioned(
        //   left: MediaQuery.of(context).size.width / 2,
        //    top: MediaQuery.of(context).size.height / 2,
        //  child: Image.asset("assets/images/mark.png")),
      ],
    ));
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    //buradaki location degisecek
    const defLocation = TurkiyeMersinLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }

    addObject(appLatLong: location);
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    //currentLocation = appLatLong;
    (await mapControllerCompleter.future).moveCamera(
        animation:
            const MapAnimation(type: MapAnimationType.smooth, duration: 5),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(
              latitude: appLatLong.lat,
              longitude: appLatLong.long,
            ),
            zoom: 15,
          ),
        ));
  }

  void addObject({required AppLatLong appLatLong}) {
    final myLocationMarker = PlacemarkMapObject(
      opacity: 1,
      mapId: MapObjectId('currentLocation'),
      point: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/images/mark.png'),
            scale: 0.1,
            rotationType: RotationType.noRotation),
      ),
    );
    final currentLocationCircle = CircleMapObject(
        mapId: MapObjectId('currentLocationCircle'),
        circle: Circle(
          center: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
          radius: 250,
        ),
        strokeWidth: 0,
        fillColor: const Color.fromARGB(255, 8, 10, 142).withOpacity(0.1));

    mapObject.addAll([currentLocationCircle, myLocationMarker]);
    setState(() {});
  }

  void addMark({required Point point}) {
    final secondLocation = PlacemarkMapObject(
      opacity: 1,
      mapId: MapObjectId('secondLocation'),
      point: point,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/images/mark.png'),
            scale: 0.1,
            rotationType: RotationType.noRotation),
      ),
    );
    mapObject.add(secondLocation);
    setState(() {});
  }
}