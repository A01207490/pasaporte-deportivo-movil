import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'dart:async';
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:pasaporte/view/session/show.dart';
import 'package:pasaporte/view/session/create.dart';

class SessionIndex extends StatefulWidget {
  @override
  _SessionIndexState createState() => _SessionIndexState();
}

class _SessionIndexState extends State<SessionIndex> {
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
                  MaterialPageRoute(builder: (context) => SessionCreate()),
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
          future: databaseHelper.getSession(),
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
                progressBarColor: Color(0xFF0075BC))
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
                  builder: (BuildContext context) => new SessionShow(
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
                      color: Color(0xFF0075BC),
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
