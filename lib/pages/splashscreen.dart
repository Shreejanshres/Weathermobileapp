import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weatherapp/core/colors.dart';
import 'package:weatherapp/cubit/weather_cubit.dart';
import 'package:weatherapp/cubit/weather_state.dart';
import 'package:weatherapp/pages/weatherscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String userLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      _getUserLocation();
    } else if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      userLocation = placemarks[0].locality ?? 'Unknown location';

      // Pass the location to WeatherCubit and fetch weather data
      context.read<WeatherCubit>().getweather(userLocation);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial || state is WeatherLoading) {
          return const Scaffold(
            backgroundColor: AppColor.blue,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/Logo.png'),
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fetching Weather...',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        } else if (state is WeatherLoaded) {

          Future.microtask(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              ));
        } else if (state is WeatherError) {
          // Display error message
          return Scaffold(
            backgroundColor: AppColor.blue,
            body: Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(fontSize: 24, color: Colors.red),
              ),
            ),
          );
        }

        return Container(); // Fallback widget
      },
    );
  }
}
