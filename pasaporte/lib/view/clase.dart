import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pasaporte/view/detailPasaporte.dart';
import 'package:pasaporte/view/pasaporte.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pasaporte/view/pasaporte.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Clase extends StatefulWidget {
  @override
  _ClaseState createState() => _ClaseState();
}

class _ClaseState extends State<Clase> {
  List data;


  Future<List> getData() async {
    final response = await http.get("http://10.0.0.4:8000/api/getCurrentClasses");
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    //data = this.getData();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo[900],
        title: new Text("Clases"),
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
            list: snapshot.data,
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  void _registerClass(String clase_id) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var coach_nomina = await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.QR);
    final key = 'token';
    final token = sharedPreferences.get(key) ?? 0;
    print(coach_nomina);
    print(clase_id);
    print(token);
    Map param = {
      'token': '$token',
      'clase_id': '$clase_id',
      'coach_nomina': '$coach_nomina'
    };
    var response = await http.post("http://10.0.0.4:8000/api/registerSession", body: param);
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new GestureDetector(
            onTap: () => _registerClass(list[i]['clase_id'].toString()),
            child: new Card(
              child: new ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check, color: Colors.blueGrey,),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Icon(Icons.add_circle_outline, color: Colors.blueGrey,),
                  ],
                ),
                title: new Text(
                  'Clase',
                  style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                ),
                subtitle: new Text(
                  list[i]['clase_nombre'].toString(),
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}