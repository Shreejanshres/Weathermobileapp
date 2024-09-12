import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/cubit/weather_cubit.dart';
import 'package:weatherapp/cubit/weather_state.dart';
import 'package:weatherapp/core/colors.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoaded) {
              return Text(
                state.weather.city,
                style: const TextStyle(color: AppColor.text, fontSize: 24),
              );
            }
            return const Text(
              'Weather',
              style: TextStyle(color: AppColor.text, fontSize: 24),
            );
          },
        ),
        backgroundColor: AppColor.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.blue, AppColor.white],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WeatherLoaded) {
              final weather = state.weather;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for a city',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              final searchQuery = _searchController.text;
                              if (searchQuery.isNotEmpty) {
                                BlocProvider.of<WeatherCubit>(context)
                                    .getweather(searchQuery);
                              }
                            },
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${weather.temperature}°C',
                            style: const TextStyle(
                                color: AppColor.text, fontSize: 64),
                          ),
                          Text(
                            DateFormat.yMMMd().format(DateTime.now()),
                            style: const TextStyle(
                                color: AppColor.text, fontSize: 24),
                          ),
                          Text(
                            weather.description,
                            style: const TextStyle(
                                color: AppColor.text, fontSize: 24),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Precipitation:",
                                        style: TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                    Text("Humidity:",
                                        style: TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                    Text("Pressure:",
                                        style: TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                    Text('Wind Speed:',
                                        style: TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${weather.precipitation}%',
                                        style: const TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                    Text('${weather.humidity}%',
                                        style: const TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                    Text('${weather.pressure}hPa',
                                        style: const TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                    Text('${weather.windSpeed}m/s',
                                        style: const TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Image(
                                        image:
                                            AssetImage('images/sunrise.png')),
                                    const Text('Sunrise',
                                        style: TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                    Text(
                                      DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              weather.sunrise * 1000)),
                                      style: const TextStyle(
                                          color: AppColor.text, fontSize: 24),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  children: [
                                    const Image(
                                        image: AssetImage('images/sunset.png')),
                                    const Text('Sunset',
                                        style: TextStyle(
                                            color: AppColor.text,
                                            fontSize: 24)),
                                    Text(
                                      DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              weather.sunset * 1000)),
                                      style: const TextStyle(
                                          color: AppColor.text, fontSize: 24),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is WeatherError) {
              return Center(
                  child: Text('Error: ${state.message}',
                      style: const TextStyle(fontSize: 24, color: Colors.red)));
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
