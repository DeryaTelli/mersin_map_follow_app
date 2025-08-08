class YandexMapServices {
  
}

class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });
}

//istenilen location bilgisi olarak guncelle 
class BishkekLocation extends AppLatLong {
  const BishkekLocation({
    super.lat = 42.8746210,
    super.long = 74.5697610,
  });
}