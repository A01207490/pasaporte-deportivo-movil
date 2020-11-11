import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pasaporte/controllers/databasehelpers.dart';

import 'index.dart';

class SessionCreate extends StatefulWidget {
  @override
  _SessionCreateState createState() => _SessionCreateState();
}

class _SessionCreateState extends State<SessionCreate> {
  List data;
  DataBaseHelper databaseHelper = new DataBaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Registrar sesión"),
      ),
      body: new FutureBuilder<List>(
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

  Future<void> _successDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Éxito'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('La sesión ha sido registrada.', style: new TextStyle(fontSize: 14.0, color: Colors.blueGrey),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Continuar'),
              onPressed: () => Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => SessionIndex(),
              )),
            ),
          ],
        );
      },
    );
  }

  Future<void> _failureDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('La sesión no pudo ser registrada.', style: new TextStyle(fontSize: 14.0, color: Colors.blueGrey),),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Continuar'),
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
              final response = databaseHelper.createSession(list[i]['clase_id'].toString());
              response.then((value){
                print("Fuck");
                print(value.toString());

                if(value == 1){
                  print("Success");
                  _successDialog(context);
                }else if(value == 2){
                  print("Failure");
                  _failureDialog(context);
                }else if(value == 0){
                  print("Regreso otra cosa");
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
