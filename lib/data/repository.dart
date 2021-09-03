import 'package:weather_app/data/api_client.dart';
import 'package:weather_app/models/weather.dart';

class Repository {
  ApiClient weatherApiClient = ApiClient();

  Future<Weather> getWeather(String city) async {
    final int cityId = await weatherApiClient.getLocationId(city);
    return await weatherApiClient.getWeather(cityId);
  }
}
