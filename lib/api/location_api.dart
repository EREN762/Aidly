import 'dart:convert';
import 'package:http/http.dart' as http;

/// API: OpenStreetMap - Nominatim
/// Endpoint: https://nominatim.openstreetmap.org/search
/// Méthode: GET
/// Paramètres:
///   - q: texte recherché
///   - format: json
///   - limit: 5
/// Exemple:
/// https://nominatim.openstreetmap.org/search?q=Kinshasa&format=json&limit=5
/// Note: User-Agent requis
/// Auteur: Benjamin

class LocationModel {
  final double lat;
  final double lon;
  final String displayName;

  LocationModel({
    required this.lat,
    required this.lon,
    required this.displayName,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      displayName: json['display_name'] as String,
    );
  }
}

class LocationAPI {
  Future<List<LocationModel>> searchLocation(String query) async {
    final url = Uri.https(
    "nominatim.openstreetmap.org",
    "/search",
  {
    "q": query,
    "format": "json",
    "limit": "5",
  },
);

    final response = await http.get(
      url,
      headers: {"User-Agent": "AidlyApp/1.0"},
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur API localisation");
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => LocationModel.fromJson(e))
        .toList();
  }
}
