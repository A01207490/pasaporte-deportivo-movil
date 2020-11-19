import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'dialogs.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  DataBaseHelper databaseHelper = new DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    final dataBaseHelper = Provider.of<DataBaseHelper>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Color(0xFF0033A0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(),
                  textSection(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45.0,
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    margin: EdgeInsets.only(top: 25.0),
                    child: RaisedButton(
                      onPressed: emailController.text == "" ||
                              passwordController.text == ""
                          ? null
                          : () {
                              setState(() {
                                _isLoading = true;
                              });
                              signIn(emailController.text,
                                      passwordController.text)
                                  .then((value) {
                                if (value == 0) {
                                  Dialogs.errorDialog(context,
                                      "La credenciales son incorrrectas");
                                }
                                dataBaseHelper.email = emailController.text;
                              });
                            },
                      elevation: 0.0,
                      color: Colors.blue,
                      child: Text("Ingresar",
                          style: TextStyle(color: Colors.white70)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Future<int> signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass};
    var jsonResponse = null;
    String url = databaseHelper.serverUrl.toString() + "/login";
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        url = databaseHelper.serverUrl.toString() + "/me";
        var token = jsonResponse['access_token'];
        sharedPreferences.setString("token", jsonResponse['access_token']);
        var response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
        jsonResponse = json.decode(response.body);
        sharedPreferences.setString("email", email);
        sharedPreferences.setString("pass", pass);
        sharedPreferences.setString("name", jsonResponse['name']);
        sharedPreferences.setString("semester", jsonResponse['semestre']);
        //databaseHelper.email = email;
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()),
            (Route<dynamic> route) => false);
        return 1;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
    return 0;
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Correo",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Contraseña",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 100.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      child: Text("Pasaporte Deportivo",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white70,
              fontSize: 30.0,
              fontWeight: FontWeight.bold)),
    );
  }
}
