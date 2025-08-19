import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/io.dart';
import '../service/tracking_api.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
class TrackingRepository {
  final TrackingApi _api;
  TrackingRepository(this._api);

  /// WS'e bağlanır ve Geolocator stream'ini geri döndürür.
  Future<Stream<Position>> startForegroundTracking(String jwt) async {
    await _api.connectUserWS(jwt); // pingInterval içeride ayarlı
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 15,
      // intervalDuration: Duration(seconds: 5), // sürümün destekliyorsa ekleyebilirsin
      // NOT: timeLimit koyma -> TimeoutException atar
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }

  /// HomeViewModel dinlerken WS'e gönderirken bunu çağıracağız.
  void sendLivePosition(double lat, double lon) {
    _api.sendUserLocation(lat, lon); // {"event":"loc", ...} gönderir
  }

  Future<void> stopForegroundTracking() => _api.closeUserWS();

  // Admin tarafı
  Future<List<Map<String, dynamic>>> adminLast() => _api.adminLast();
  Stream<Map<String, dynamic>> adminLive(String jwt) => _api.connectAdminWS(jwt);
  Future<void> closeAdminLive() => _api.closeAdminWS();
}