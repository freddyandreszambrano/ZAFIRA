import '../flavors/flavors_config.dart';

class AppUrls {
  static String getHereMapsImage(String latitude, String longitude) {
    var hereMapsImage =
        'https://image.maps.hereapi.com/mia/v3/base/mc/center:$latitude,$longitude;zoom=17/400x400/png?apiKey=${Flavor.hereMapApiKey}&style=lite.day&copyright=false&ppi=200&lang=es&ta=45';
    return hereMapsImage;
  }

  static String getHereMapsImageWithPolygon(
    String lat,
    String long,
    String polygon,
    String name,
  ) {
    return 'https://image.maps.hereapi.com/mia/v3/base/mc'
        '/center:$lat,$long;zoom=17'
        '/400x400/png'
        '?apikey=${Flavor.hereMapApiKey}'
        '&style=lite.day'
        '&overlay=polygon:$polygon'
        ';color=%2356237D80'
        '&overlay=point:$lat,$long'
        ';size=large'
        ';label=$name'
        ';text-color=%2356237D'
        ';text-outline-color=%23FFFFFF'
        ';outline-width=2'
        ';color=%2356237D'
        ';outline-color=%23FFFFFF';
  }
}
