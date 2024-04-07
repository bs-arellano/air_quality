import 'dart:async';

import 'package:geolocator/geolocator.dart';

class PositionManager {
  bool active = false;
  LocationPermission permission = LocationPermission.denied;
  bool serviceEnabled = false;
  Position currentPositon = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0);

  Future<void> startService() async {
    //Cheks if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      //Gets location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          active = true;
        }
      }
    }
  }

  PositionManager() {
    print("position constructor called");
    startService();
  }
  Future updatePosition() async {
    currentPositon = await Geolocator.getCurrentPosition();
  }

  Position getPosition() {
    return currentPositon;
  }
}
