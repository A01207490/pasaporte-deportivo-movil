import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DataBaseHelper {
  String serverUrl = "http://10.0.0.4:8000/api";
  String serverUrlproducts = "http://pasaportedeportivoitesm.com//api/products";

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

  Future<void> createSession(String clase_id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var coach_nomina = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.QR);
    final key = 'token';
    final token = sharedPreferences.get(key) ?? 0;
    print(coach_nomina);
    print(clase_id);
    print(token);
    Map param = {
      'clase_id': '$clase_id',
      'coach_nomina': '$coach_nomina'
    };
    String url = "$serverUrl/createSession";
    var response = await http.post(url, body: param, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      print("Successfully registered class current");
      return 1;
    } else if (response.statusCode == 403) {
      print(response.statusCode);
      return 0;
    }
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

  //create function for register Users
  registerUserData(String name, String email, String password) async {
    String myUrl = "$serverUrl/register";
    final response = await http.post(myUrl,
        headers: {'Accept': 'application/json'},
        body: {"name": "$name", "email": "$email", "password": "$password"});
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

//function for register products
  void addDataProducto(String _nameController, String _priceController,
      String _stockController) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    // String myUrl = "$serverUrl/api";
    String myUrl = "http://192.168.1.55:8000/api/products";
    final response = await http.post(myUrl, headers: {
      'Accept': 'application/json'
    }, body: {
      "name": "$_nameController",
      "price": "$_priceController",
      "stock": "$_stockController"
    });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  //function for update or put
  void editarData(String id, String name, String price, String stock) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "http://192.168.1.55:8000/api/products/$id";
    http.put(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
      "price": "$price",
      "stock": "$stock"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //function for delete
  void removeRegister(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "http://192.168.1.55:8000/api/products/$id";
    http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //funciton getData
  Future<List> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrlproducts";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  //function save
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

//function read
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }
}
