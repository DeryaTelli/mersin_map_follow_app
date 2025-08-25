class LocationPoint {
  final int userId;
  final double lat;
  final double lon;
  final DateTime createdAt;

  LocationPoint({
    required this.userId,
    required this.lat,
    required this.lon,
    required this.createdAt,
  });

  factory LocationPoint.fromJson(Map<String, dynamic> j) {
    return LocationPoint(
      userId: j['user_id'] as int,
      lat: (j['lat'] as num).toDouble(),
      lon: (j['lon'] as num).toDouble(),
      createdAt: DateTime.parse(j['created_at'] as String).toLocal(),
    );
  }
}
