import 'dart:convert';

import 'package:pasaporte/view/addProduct.dart';
import 'package:pasaporte/view/addUser.dart';
import 'package:pasaporte/view/listProducts.dart';
import 'package:pasaporte/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pasaporte/view/pasaporte.dart';
import 'package:pasaporte/view/anuncio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Pasaporte Deportivo",
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.indigo[600],
          accentColor: Colors.redAccent[100],

          // Define the default font family.
          fontFamily: 'Ubuntu',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme:
          TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ));
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title:
            Text("Pasaporte Deportivo", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new ListView(
          children: <Widget>[
            new ListTile(
                title: new Text(
                    'Bienvenido, participa en las clases o clínicas deportivas que desees.',
                    style:
                        new TextStyle(fontSize: 14.0, color: Colors.blueGrey))),
          ],
        ),
      ),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo[900],
              ),
              accountName: new Text('Pasaporte'),
              accountEmail: new Text('pasaporte@gmail.com'),
            ),
            new ListTile(
              title: new Text("Pasaporte"),
              leading: new Icon(Icons.directions_bike, color: Colors.blueGrey),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => Pasaporte(),
              )),
            ),
            new ListTile(
              title: new Text("Anuncios"),
              leading: new Icon(Icons.announcement, color: Colors.blueGrey),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => Anuncio(),
              )),
            ),
            new Divider(),
          ],
        ),
      ),
    );
  }
}
