import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:pasaporte/view/detailPasaporte.dart';
import 'package:pasaporte/view/clase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pasaporte extends StatefulWidget {
  @override
  _PasaporteState createState() => _PasaporteState();
}

class _PasaporteState extends State<Pasaporte> {
  List data;
  int sessions;
  DataBaseHelper databaseHelper = new DataBaseHelper();

  @override
  void initState() {
    super.initState();
    //databaseHelper.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Pasaporte"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Clase()),
              );
            },
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: new FutureBuilder<List>(
        future: databaseHelper.getSessions(),
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
      bottomNavigationBar: Container(
          height: 60,
          child: GFProgressBar(
              percentage: 0.9,
              backgroundColor: Colors.black26,
              progressBarColor: Colors.amber))
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double sessions;
  ProgressBar({this.sessions});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        child: GFProgressBar(
            percentage: sessions,
            backgroundColor: Colors.black26,
            progressBarColor: Colors.amber));
  }
}

class ItemList extends StatelessWidget {
  final List list;

  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailPasaporte(
                        list: list,
                        index: i,
                      )),
            ),
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
