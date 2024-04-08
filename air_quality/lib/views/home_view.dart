import 'package:air_quality/api_fetching.dart';
import 'package:flutter/material.dart';
import '../position_manager.dart';
import '../data/air_quality_data.dart';
import 'dart:convert';

class HomeView extends StatefulWidget {
  final PositionManager positionManager;
  final String token;

  const HomeView(
      {super.key, required this.positionManager, required this.token});

  Future<String> fetchAirQuality() async {
    try {
      final response = await APIFetching.fetchMeasure(
          token,
          positionManager.getPosition().latitude.toString(),
          positionManager.getPosition().longitude.toString());
      if (response.statusCode == 200) {
        final data = AirQualityData.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        return '${data.name}: ${data.value} ${data.unit}';
      } else {
        throw Exception('Failed to load album ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      return 'Error';
    }
  }

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  String _currPosition = '';
  String _currMeasurement = '';
  bool _loaded = false;
  late AnimationController controller;

  void updateMeasurement() async {
    String measurement = await widget.fetchAirQuality();
    if (mounted) {
      setState(() {
        _currMeasurement = measurement;
      });
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {
          if (widget.positionManager.isActive()) {
            _currPosition = widget.positionManager.getPosition().toString();
            updateMeasurement();
            _loaded = true;
            controller.stop();
          }
        });
      });
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _loaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Current Location'),
                  Text(
                    _currPosition,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const Text("Air Quality"),
                  Text(
                    _currMeasurement,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : CircularProgressIndicator(
                value: controller.value,
              ));
  }
}
