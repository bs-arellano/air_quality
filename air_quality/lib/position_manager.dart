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
    print('serviceEnabled: $serviceEnabled');
    if (serviceEnabled) {
      //Gets location permission
      permission = await Geolocator.checkPermission();
      print('permission: $permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          currentPositon = await Geolocator.getCurrentPosition();
          active = true;
        }
      } else {
        currentPositon = await Geolocator.getCurrentPosition();
        active = true;
      }
    }
  }

  PositionManager() {
    print("position constructor called");
    startService();
  }
  Future updatePosition() async {
    if (active) {
      currentPositon = await Geolocator.getCurrentPosition();
    }
  }

  Position getPosition() {
    return currentPositon;
  }

  bool isActive() {
    return active;
  }
}
