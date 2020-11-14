import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pasaporte/controllers/databasehelpers.dart';

import '../dialogs.dart';
import 'index.dart';

class SessionCreate extends StatefulWidget {
  @override
  _SessionCreateState createState() => _SessionCreateState();
}

class _SessionCreateState extends State<SessionCreate> {
  List data;
  DataBaseHelper databaseHelper = new DataBaseHelper();
  static bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Registrar sesión"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : new FutureBuilder<List>(
              future: databaseHelper.getClassCurrent(),
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

  Future<void> _acceptDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title,
              style: new TextStyle(
                fontSize: 18.0,
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  body,
                  style: new TextStyle(fontSize: 14.0, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (list.length == 0)
      return new ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new ListTile(
              title: new Text('Por el momento no hay clases disponibles.',
                  style:
                      new TextStyle(fontSize: 14.0, color: Colors.blueGrey))),
        ],
      );

    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new GestureDetector(
            onTap: () {

              final response =
                  databaseHelper.createSession(list[i]['clase_id'].toString());
              response.then((value) {
                print(value.toString());

                if (value == 1) {
                  Dialogs.acceptDialog(
                      context, "Excelente", "La sesión ha sido registrada");
                } else if (value == 2) {
                  Dialogs.acceptDialog(
                      context, "Oops", "El código QR del coach es incorrecto.");
                } else if (value == 3) {
                  Dialogs.acceptDialog(context, "Oops",
                      "Ya se ha registrado una sesión el día de hoy.");
                } else if (value == 4) {
                  Dialogs.acceptDialog(context, "Oops",
                      "El código QR no corresponde a ningun coach.");
                }
              });
            },
            child: new Card(
              child: new ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.class__rounded,
                      color: Color(0xFF0075BC),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF0075BC),
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
