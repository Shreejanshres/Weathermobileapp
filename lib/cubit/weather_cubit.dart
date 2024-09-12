import 'package:flutter_bloc/flutter_bloc.dart';
import './weather_state.dart';
import 'package:weatherapp/repo/weather_repo.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository = WeatherRepository();
  final String city;

  WeatherCubit(this.city) : super(WeatherInitial());

  void getweather(String city) async {
    print(city);
    try {
      emit(WeatherLoading());
      final weather = await _weatherRepository.fetchWeather(city);
      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
}
