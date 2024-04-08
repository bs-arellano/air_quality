import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dart:convert';

import 'package:air_quality/api_fetching.dart';
import 'package:air_quality/data/measurement_data.dart';

class DataView extends StatefulWidget {
  final String token;
  const DataView({super.key, required this.token});
  Future<List<Measurement>> fetchMeasurements() async {
    try {
      final response = await APIFetching.fetchMeasurements(token);
      if (response.statusCode == 200) {
        final data = MeasurementList.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        List<Measurement> measurements = data.measurements;
        return measurements;
      } else {
        throw Exception('Failed to load album ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  @override
  State<DataView> createState() => DataViewState();
}

class DataViewState extends State<DataView> with TickerProviderStateMixin {
  bool _loaded = false;
  List<Measurement> _measurements = [];
  late AnimationController controller;

  void updateMeasurements() async {
    final measurements = await widget.fetchMeasurements();
    if (measurements.isNotEmpty) {
      setState(() {
        _measurements = measurements;
      });
    }
  }

  @override
  void initState() {
    updateMeasurements();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {
          if (_measurements.isNotEmpty) {
            _loaded = true;
            controller.stop();
          }
        });
      });
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loaded
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Your Data",
                          style: Theme.of(context).textTheme.headlineMedium)),
                  Expanded(
                      child: SfCartesianChart(
                          primaryXAxis: const DateTimeAxis(),
                          series: <CartesianSeries>[
                        // Renders line chart
                        LineSeries<Measurement, DateTime>(
                            dataSource: _measurements,
                            xValueMapper: (Measurement msrm, _) => msrm.date,
                            yValueMapper: (Measurement msrm, _) => msrm.value)
                      ]))
                ],
              ),
            )
          : CircularProgressIndicator(
              value: controller.value,
            ),
    );
  }
}
