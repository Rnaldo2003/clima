import 'dart:async';
import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'model/weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _loading = false;
  String _city = 'Tegucigalpa';
  final TextEditingController _cityController = TextEditingController();
  Timer? _timer;

  Future<void> _loadWeather([String? city]) async {
    setState(() => _loading = true);
    try {
      final weather = await _weatherService.fetchWeather(city ?? _city);
      setState(() {
        _weather = weather;
        if (city != null) {
          _city = city;
          _cityController.text = city; // <-- Actualiza el TextField también
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener el clima')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _cityController.text = _city;
    _loadWeather();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _loadWeather());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadWeather(),
          ),
        ],
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _weather == null
                ? const Text('No hay datos')
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _cityController,
                                  decoration: const InputDecoration(
                                    labelText: 'Ciudad',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  final city = _cityController.text.trim();
                                  if (city.isNotEmpty) {
                                    _loadWeather(city);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Ciudad: $_city', style: TextStyle(fontSize: 20)),
                        Text('Temperatura: ${_weather!.temperature}°C', style: TextStyle(fontSize: 24)),
                        Text('Condición: ${_weather!.description}', style: TextStyle(fontSize: 20)),
                        Text('Viento: ${_weather!.windSpeed} m/s', style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _loadWeather(),
                          child: const Text('Actualizar'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
