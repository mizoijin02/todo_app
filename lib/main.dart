import 'package:flutter/material.dart';
import 'todo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
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
  // プッシュ遷移の関数
  void _pushPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ToDoPage();
        },
      ),
    );
  }

  // 変数の定義と初期化
  TextEditingController controller = TextEditingController();
  // APIの情報
  String areaName = '';
  String weather = '';
  double temperature = 0;
  int humidity = 0;
  double temperatureMax = 0;
  double temperatureMin = 0;

  Future<void> loadwWeather(String query) async {
    //APIの応答内容を入れる
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?appid=4cc08e5784a5862ce9630b7461a1791f&lang=ja&units=metric&q=$query'));

    if (response.statusCode != 200) {
      return;
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final main = (body['main'] ?? {}) as Map<String, dynamic>;

    setState(() {
      areaName = body['name'];
      weather = (body['weather']?[0]?['description'] ?? '') as String;
      humidity = (main['humidity'] ?? 0) as int;
      temperature = (main['temp'] ?? 0) as double;
      temperatureMax = (main['temp_max'] ?? 0) as double;
      temperatureMin = (main['temp_min'] ?? 0) as double;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          controller: controller,
          onChanged: (value) {
            loadwWeather(value);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pushPage();
                    },
                    child: const Text('プッシュ遷移'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('地域'),
                  subtitle: Text(areaName),
                ),
                ListTile(
                  title: Text('天気'),
                  subtitle: Text(weather),
                ),
                ListTile(
                  title: const Text('温度'),
                  subtitle: Text('${temperature.toStringAsFixed(1)}°C'),
                ),
                ListTile(
                  title: const Text('最高温度'),
                  subtitle: Text('${temperatureMax.toStringAsFixed(1)}°C'),
                ),
                ListTile(
                  title: const Text('最低温度'),
                  subtitle: Text('${temperatureMin.toStringAsFixed(1)}°C'),
                ),
                ListTile(
                  title: const Text('湿度'),
                  subtitle: Text('$humidity%'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
