import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DataBaseHelper extends ChangeNotifier {
  String serverUrl = "http://10.0.0.4:8000/api";
  String announcementImagesUrl = "http://10.0.0.4:8000/storage/anuncios/";

  String _email;

  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  //String announcementImagesUrl = "http://10.0.0.4:8000/storage/app/public/anuncios/";

  var status;
  var token;
  var sessions;
  final StreamController countController = StreamController();
  final StreamController registerController = StreamController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
      print("successfully retrieved session");
      sessions = jsonResponse.length.toDouble();
      countController.sink.add(sessions);
      return jsonResponse;
    } else {
      print("could not retrieve session");
      print(response.statusCode);
      return [];
    }
  }

  Future<List> getClass() async {
    String url = "$serverUrl/getClass";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("successfully retrieved class");
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      print("could not retrieve class");
      print(response.statusCode);
      return [];
    }
  }

  Future<List> getAnnouncement() async {
    String url = "$serverUrl/getAnnouncement";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("successfully retrieved announcement");
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      print("could not retrieve announcement");
      print(response.statusCode);
      return [];
    }
  }

  Future<List> getClassCurrent() async {
    String url = "$serverUrl/getClassCurrent";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("successfully retrieved class current");
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      print("could not retrieve class current");
      print(response.statusCode);
      return [];
    }
  }

  Future<int> createSession(String clase_id, String clase_nombre) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.get('token') ?? 0;
    String url = "$serverUrl/createSession";
    var coach_nomina = '1';
    if (clase_nombre != 'Pista') {
      coach_nomina = await FlutterBarcodeScanner.scanBarcode(
          "#000000", "Cancel", true, ScanMode.QR);
    }
    Map param = {'clase_id': '$clase_id', 'coach_nomina': '$coach_nomina'};
    if (coach_nomina != (-1).toString()) {
      var response = await http.post(url, body: param, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print(response.body);
      if (response.statusCode == 200) {
        return 1;
      } else if (response.statusCode == 403) {
        return 2;
      } else if (response.statusCode == 405) {
        return 3;
      } else if (response.statusCode == 500) {
        return 4;
      } else if (response.statusCode == 406) {
        return 5;
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
