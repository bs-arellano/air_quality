import 'package:http/http.dart' as http;
import 'dart:convert';

class APIFetching {
  static Future<http.Response> fetchSession(
      String email, String password) async {
    var body = json.encode({"email": email, "password": password});
    final response =
        await http.post(Uri.parse('http://192.168.1.17:53692/signin'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: body);
    return response;
  }

  static Future<http.Response> fetchMeasure(
      String token, String latitude, String longitude) async {
    var body = json.encode({"latitude": latitude, "longitude": longitude});
    final response = await http.post(
        Uri.parse('http://192.168.1.17:53692/coordinates'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization-Token': token
        },
        body: body);
    return response;
  }

  static Future<http.Response> fetchMeasurements(String token) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.17:53692/measurements'), headers: {
      'Content-Type': 'application/json',
      'Authorization-Token': token
    });
    return response;
  }
}
