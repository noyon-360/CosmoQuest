import 'package:cosmoquest/Model/ExoplanetModel/PlanetModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlanetViewModel {
  Future<Planet?> fetchPlanetDetails(String planetName) async {
    final response = await http.get(
      Uri.parse('https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query=SELECT+pl_name,pl_rade,st_teff,pl_orbsmax+FROM+ps+WHERE+pl_name=%27$planetName%27&format=json'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data.isNotEmpty) {
        return Planet.fromJson(data[0]);
      }
    }
    return null;
  }

  static Future<List<Planet>> fetchPlanets({int offset = 0, int limit = 20}) async {
    final response = await http.get(
      Uri.parse('https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query=SELECT+pl_name,pl_rade,st_teff+FROM+ps+WHERE+pl_rade+BETWEEN+0.8+AND+1.25&format=json'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Planet> planets = (data as List).map((json) => Planet.fromJson(json)).toList();
      print(data);
      return planets;
    } else {
      throw Exception('Failed to load planets');
    }
  }

  String isHabitable(Planet planet) {
    if (planet.radius >= 0.8 && planet.radius <= 1.25 && planet.starTemp >= 2600 && planet.starTemp <= 7200) {
      return 'This planet is potentially habitable';
    } else {
      return 'This planet is likely not habitable';
    }
  }

}
