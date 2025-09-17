import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hava Durumu',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Map<String, dynamic>? weatherData;
  String? currentCity;
  bool loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeatherByLocation();
  }

  Future<void> fetchWeatherByLocation() async {
    Position position = await _determinePosition();
    await fetchWeather(position.latitude, position.longitude);
    await fetchCityName(position.latitude, position.longitude);
  }

  Future<void> fetchWeather(double lat, double lon) async {
    try {
      String url =
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min,weathercode&current_weather=true&timezone=auto';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  Future<void> fetchCityName(double lat, double lon) async {
    final geoUrl =
        'https://geocoding-api.open-meteo.com/v1/reverse?latitude=$lat&longitude=$lon&language=tr';
    final response = await http.get(Uri.parse(geoUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        setState(() {
          currentCity = data['results'][0]['name'];
        });
      }
    }
  }

  Future<void> searchCity(String cityName) async {
    final geoUrl =
        'https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=1&language=tr';
    final response = await http.get(Uri.parse(geoUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        double lat = data['results'][0]['latitude'];
        double lon = data['results'][0]['longitude'];
        setState(() {
          currentCity = data['results'][0]['name'];
        });
        await fetchWeather(lat, lon);
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Lokasyon servisi kapalı.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Lokasyon izni reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Lokasyon izni kalıcı reddedildi.');
    }

    return await Geolocator.getCurrentPosition();
  }

  IconData _getWeatherIcon(int code) {
    if ([0].contains(code)) return Icons.wb_sunny;
    if ([1, 2].contains(code)) return Icons.wb_sunny_outlined;
    if ([3].contains(code)) return Icons.cloud;
    if ([45, 48].contains(code)) return Icons.foggy;
    if ([51, 61, 80].contains(code)) return Icons.grain;
    if ([71, 73, 75, 77, 85, 86].contains(code)) return Icons.ac_unit;
    if ([95, 96, 99].contains(code)) return Icons.thunderstorm;
    return Icons.wb_cloudy;
  }

  String _getBackgroundImage(int code) {
    final hour = DateTime.now().hour;
    bool isNight = hour < 6 || hour > 19;

    if ([0, 1, 2].contains(code)) {
      return isNight ? 'assets/night_clear.jpg' : 'assets/sunny.jpg';
    }
    if ([3, 45, 48].contains(code)) {
      return isNight ? 'assets/night_cloudy.jpg' : 'assets/cloudy.jpg';
    }
    if ([51, 61, 80].contains(code)) return 'assets/rainy.jpg';
    if ([71, 73, 75, 77, 85, 86].contains(code)) return 'assets/snow.jpg';
    if ([95, 96, 99].contains(code)) return 'assets/storm.jpg';
    return 'assets/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    _getBackgroundImage(
                      weatherData!["current_weather"]["weathercode"],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.4)),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _searchController,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) searchCity(value);
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Şehir ara...",
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.black45,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (currentCity != null)
                          Text(
                            currentCity!,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(height: 10),
                        Card(
                          color: Colors.white.withOpacity(0.85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Bugün",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${weatherData!["current_weather"]["temperature"]}°C",
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  _getWeatherIcon(
                                    weatherData!["current_weather"]["weathercode"],
                                  ),
                                  size: 64,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "7 Günlük Tahmin:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: weatherData!["daily"]["time"].length,
                          itemBuilder: (context, index) {
                            String day = weatherData!["daily"]["time"][index];
                            var minTemp =
                                weatherData!["daily"]["temperature_2m_min"][index];
                            var maxTemp =
                                weatherData!["daily"]["temperature_2m_max"][index];
                            int code =
                                weatherData!["daily"]["weathercode"][index] ??
                                0;

                            DateTime date = DateTime.parse(
                              day,
                            ).add(const Duration(days: 3));
                            String formattedDay = DateFormat(
                              'EEEE, d MMM',
                              'tr_TR',
                            ).format(date);

                            return Card(
                              color: Colors.white.withOpacity(0.85),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  _getWeatherIcon(code),
                                  color: Colors.blueAccent,
                                  size: 32,
                                ),
                                title: Text(formattedDay),
                                subtitle: Text(
                                  "En düşük: $minTemp°C, En yüksek: $maxTemp°C",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
