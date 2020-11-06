import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Clase extends StatefulWidget {
  @override
  _ClaseState createState() => _ClaseState();
}

class _ClaseState extends State<Clase> {
  List data;

  Future<List> getData() async {
    final response = await http
        .get("http://pasaportedeportivoitesm.com/api/getCurrentClasses");
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
  DataBaseHelper databaseHelper = new DataBaseHelper();
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    if (list.length == 0)
      return new ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new ListTile(
              title: new Text(
            'No hay clases disponibles.',
          )),
          GFProgressBar(
              percentage: 0.9,
              backgroundColor : Colors.black26,
              progressBarColor: GFColors.DANGER
          )
        ],
      );

    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new GestureDetector(
            onTap: () => databaseHelper.registerSession(list[i]['clase_id'].toString()),
            child: new Card(
              child: new ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.blueGrey,
                    ),
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
