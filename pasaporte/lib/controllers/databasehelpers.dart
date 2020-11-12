import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DataBaseHelper {
  String serverUrl = "http://10.0.0.4:8000/api";
  var status;
  var token;
  var sessions;
  final StreamController countController = StreamController();

  Future<List> getSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.get('token') ?? 0;
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
      sessions = jsonResponse.length.toDouble();
      print('Completed sessions: ' + sessions.toString());
      countController.sink.add(sessions);
      return jsonResponse;
    } else {
      print("Could not retrieve session");
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
    Map param = {'clase_id': '$claseId', 'coach_nomina': '$coach_nomina'};
    String url = "$serverUrl/createSession";
    if (coach_nomina != (-1).toString()) {
      var response = await http.post(url, body: param, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        print("Successfully registered class");
        return 1;
      } else if (response.statusCode == 403) {
        print("Invalid coach id");
        return 2;
      } else if (response.statusCode == 405) {
        print("Cannot register more that one session a day");
        return 3;
      } else if (response.statusCode == 500) {
        print("The QR code is not valid");
        return 4;
      }
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
      _save(data["access_token"]);
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
