import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DataBaseHelper {
  String serverUrl = "http://pasaportedeportivoitesm.com/api";
  var status;
  var token;
  var sessions;

  Future<double> fetchSessionsCount() {
    return Future.delayed(Duration(seconds: 1), () => sessions);
  }

  Future<List> getSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final token = sharedPreferences.get(key) ?? 0;
    print('Refreshing old token: ' + token.toString());
    String url = "$serverUrl/refresh";
    var response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        print("Successfully returned token.");
        print(jsonResponse['access_token']);
        sharedPreferences.setString("token", jsonResponse['access_token']);
        final token = sharedPreferences.get(key) ?? 0;
        String url = "$serverUrl/getSession";
        var response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          print("Successfully retrieved sessions");
          print(jsonResponse);
          sessions = jsonResponse.length.toDouble() / 30;
          print('Percentage of completed sessions: ' + sessions.toString());
          return jsonResponse;
        } else {
          print("Could not retrieve session");
          print(response.statusCode);
          return [];
        }
      }
      print("API returned an empty response");
      print(response.statusCode);
      return [];
    } else {
      print("Could not refresh token");
      print(response.statusCode);
      return [];
    }
  }

  Future<List> getClass() async {
    String url = "$serverUrl/getClass";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Successfully retrieved class");
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      print("Could not retrieve class");
      print(response.statusCode);
      return [];
    }
  }

  Future<List> getAnnouncement() async {
    String url = "$serverUrl/getAnnouncement";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Successfully retrieved announcement");
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      print("Could not retrieve announcement");
      print(response.statusCode);
      return [];
    }
  }

  Future<List> getClassCurrent() async {
    String url = "$serverUrl/getClassCurrent";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Successfully retrieved class current");
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      print("Could not retrieve class current");
      print(response.statusCode);
      return [];
    }
  }

  Future<int> createSession(String claseId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var coach_nomina = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.QR);
    final key = 'token';
    final token = sharedPreferences.get(key) ?? 0;
    print(coach_nomina);
    print(claseId);
    print(token);
    Map param = {
      'clase_id': '$claseId',
      'coach_nomina': '$coach_nomina'
    };
    String url = "$serverUrl/createSession";
    var response = await http.post(url, body: param, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      print("Successfully registered class");
      return 1;
    } else if (response.statusCode == 401) {
      print(response.statusCode);
      return 2;
    }
    return 0;
  }

  //create function for login
  loginData(String email, String password) async {
    String myUrl = "$serverUrl/login";
    final response = await http.post(myUrl,
        headers: {'Accept': 'application/json'},
        body: {"email": "$email", "password": "$password"});
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }
}
