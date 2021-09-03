import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/models/weather.dart';

class ApiClient {
  static const baseUrl = "https://www.metaweather.com";

  final http.Client httpClient = http.Client();

  Future<int> getLocationId(String cityName) async {
    final cityUrl =
        Uri.parse(baseUrl + "/api/location/search/?query=" + cityName);
    final response = await http.get(cityUrl);

    if (response.statusCode != 200) {
      print("LocationId getirilemedi");
    }

    final recentResponse = (jsonDecode(response.body)) as List;
    return recentResponse[0]["woeid"];
  }

  Future<Weather> getWeather(int cityId) async {
    final weatherUrl = Uri.parse(baseUrl + "/api/location/$cityId");
    final responseWeather = await http.get(weatherUrl);
    print(responseWeather.body);
    if (responseWeather.statusCode != 200) {
      print("Şehire ait havadurumu bilgisi getirilemedi");
    }

    final weatherResponse = jsonDecode(responseWeather.body);
    print(weatherResponse);
    return Weather.fromJson(weatherResponse);
  }
}
