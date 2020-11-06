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
  double _sessionsCount;
  String _sessionsCountString;

  @override
  void initState() {
    super.initState();
    getSessionsCount();
  }

  Future<void> getSessionsCount() async {
    var v = await databaseHelper.fetchSessionsCount();
    setState(() {
      _sessionsCount = v;
    });
  }

  void _updateSessionsCount(double v) {
    setState(() {
      _sessionsCount = v;
      _sessionsCountString = _sessionsCount.toString();
    });
    print(_sessionsCount);
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
        bottomNavigationBar:
        new Container(
          padding: const EdgeInsets.all(10.0),
          height: 100,
          child: new ListView(
            children: <Widget>[
              new ListTile(
                  title: new Text(
                      'Sesiones completadas.',
                      style:
                      new TextStyle(fontSize: 14.0, color: Colors.blueGrey))),
            new GFProgressBar(
                percentage: _sessionsCount == null ? 0 : _sessionsCount,
                lineHeight: 15,
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: const Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
                animation: true,
                backgroundColor: Colors.black26,
                progressBarColor: Colors.blueAccent[200])
            ],
          ),
        ),



    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    if (list.length == 0)
      return new ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new ListTile(
              title: new Text(
            'No hay sesiones registradas disponibles.',
          )),
        ],
      );

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
