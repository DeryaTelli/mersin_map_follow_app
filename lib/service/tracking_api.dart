// lib/service/tracking_api.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

class TrackingApi {
  final Dio _dio;
  final String _wsBase; // ws://10.0.2.2:8000
  TrackingApi(this._dio, {required String wsBase}) : _wsBase = wsBase;

  IOWebSocketChannel? _userCh;
  IOWebSocketChannel? _adminCh;

  // ---- REST
  Future<List<Map<String, dynamic>>> adminLast() async {
    final res = await _dio.get('/tracking/admin/last');
    return (res.data as List).cast<Map<String, dynamic>>();
  }

  // ---- USER WS
  Future<void> connectUserWS(String jwt) async {
    final uri = Uri.parse('$_wsBase/tracking/ws/track?token=$jwt');
    _userCh = IOWebSocketChannel.connect(
      uri,
      pingInterval: const Duration(seconds: 30), // bağlantı canlı kalsın
    );
  }

  void sendUserLocation(double lat, double lon) {
    _userCh?.sink.add(jsonEncode({"type": "loc", "lat": lat, "lon": lon}));
  }

  Future<void> closeUserWS() async {
    await _userCh?.sink.close(ws_status.goingAway);
    _userCh = null;
  }

  // ---- ADMIN WS
  Stream<Map<String, dynamic>> connectAdminWS(String jwt) {
    final uri = Uri.parse('$_wsBase/tracking/ws/admin?token=$jwt');
    _adminCh = IOWebSocketChannel.connect(
      uri,
      pingInterval: const Duration(seconds: 30),
    );
    return _adminCh!.stream.map<Map<String, dynamic>>((e) {
      if (e is String) return jsonDecode(e) as Map<String, dynamic>;
      return Map<String, dynamic>.from(e as Map);
    });
  }

  Future<void> closeAdminWS() async {
    await _adminCh?.sink.close(ws_status.goingAway);
    _adminCh = null;
  }

    Future<List<Map<String, dynamic>>> myDayRaw({
  required String jwt,
  required DateTime day,
}) async {
  // Backend "day" alanını UTC date olarak bekliyor
  final dayStr = day.toUtc().toIso8601String().split('T').first; // yyyy-MM-dd

  final res = await _dio.get(
    '/tracking/my/day',
    queryParameters: {'day': dayStr},
    options: Options(headers: {'Authorization': 'Bearer $jwt'}),
  );

  return (res.data as List).cast<Map<String, dynamic>>();
}
}
