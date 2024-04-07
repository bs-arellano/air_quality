import 'dart:convert';

import 'package:flutter/material.dart';
import 'positionManager.dart';
import 'package:http/http.dart' as http;
import 'album.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});
  final positionManager = PositionManager();
  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  String _currPosition = '';
  String _currMeasurement = '';

  Future<String> fetchAlbum() async {
    try {
      var body = json.encode({
        "latitude": widget.positionManager.getPosition().latitude.toString(),
        "longitude": widget.positionManager.getPosition().longitude.toString()
      });
      print(body);
      final response =
          await http.post(Uri.parse('http://127.0.0.1:53692/coordinates'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: body);

      if (response.statusCode == 200) {
        print(response);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final album =
            Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        return '${album.name}: ${album.value} ${album.unit}';
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      return 'pm25: 0 ';
    }
  }

  Future updateCurrentPosition() async {
    print("called");
    await widget.positionManager.updatePosition();
    String serverResponse = await fetchAlbum();
    if (mounted) {
      setState(() {
        _currPosition = widget.positionManager.getPosition().toString();
        _currMeasurement = serverResponse;
      });
    }
  }

  @override
  void initState() {
    updateCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
          TextButton(
              onPressed: updateCurrentPosition,
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.headlineSmall,
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme?.primary ??
                          Colors.blueAccent,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              child: const Text("Update")),
        ],
      ),
    );
  }
}
