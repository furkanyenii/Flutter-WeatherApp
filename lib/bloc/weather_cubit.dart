import 'package:bloc/bloc.dart';
import 'package:weather_app/data/repository.dart';
import 'package:weather_app/bloc/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());
  Repository _weatherRepository = Repository();

  Future<void> getWeather(String cityName) async {
    try {
      emit(WeatherLoading());
      final weather = await _weatherRepository.getWeather(cityName);
      emit(WeatherLoaded(weather));
    } catch (_) {
      emit(WeatherError("Veriler getirilirken bir hata oluştu."));
    }
  }
}
