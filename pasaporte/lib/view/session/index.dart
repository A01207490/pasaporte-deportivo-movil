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
  double _sessionsCount = 0.0;

  @override
  void initState() {
    super.initState();
    _sessionsCount = 0.0;
  }

  sessionProgress() {
    return new Container(
        color: Color(0xFF071A2D),
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        height: 90,
        child: ListView(
          children: <Widget>[
            new ListTile(
                trailing: _sessionsCount / 30 >= 1
                    ? Icon(
                        Icons.verified_rounded,
                        color: Colors.greenAccent,
                      )
                    : Icon(
                        Icons.verified_rounded,
                        color: Colors.grey,
                      ),
                title: new Text(
                    'Sesiones completadas: ' +
                        (_sessionsCount).round().toString() +
                        '/30',
                    style: new TextStyle(fontSize: 14.0, color: Colors.white))),
            new GFProgressBar(
              //percentage: _sessionsCount == null ? 0.0 : _sessionsCount,
              percentage: _sessionsCount / 30 > 1 ? 1 : _sessionsCount / 30,
              lineHeight: 15,
              padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
              animation: true,
              backgroundColor: Colors.lightBlue[50],
              progressBarColor: _sessionsCount / 30 >= 1
                  ? Colors.greenAccent
                  : Colors.greenAccent,
            ),
          ],
        ));
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
      bottomNavigationBar: StreamBuilder(
          stream: databaseHelper.countController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            _sessionsCount = double.parse("${snapshot.data}");
            return sessionProgress();
          }),
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
                      Icons.verified_rounded,
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
                title: new Text(
                  list[i]['clase_nombre'].toString(),
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                ),
                subtitle: new Text(
                  list[i]['coach_nombre'].toString(),
                  style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
