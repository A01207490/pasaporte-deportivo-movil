import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:provider/provider.dart';
import '../dialogs.dart';

class SessionCreate extends StatefulWidget {
  @override
  _SessionCreateState createState() => _SessionCreateState();
}

class _SessionCreateState extends State<SessionCreate> {
  DataBaseHelper databaseHelper = new DataBaseHelper();
  List list;
  bool _isLoading = false;

  get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
  }
  void _updateIsLoading(bool v){
    setState(() {
      _isLoading = v;
    });
    print(_isLoading);
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataBaseHelper = Provider.of<DataBaseHelper>(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Registrar sesión"),
      ),
      body: new FutureBuilder<List>(
        future: databaseHelper.getClassCurrent(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            list = snapshot.data;
            if (list.length == 0)
              return new ListView(
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  new ListTile(
                      title: new Text(
                          'Por el momento no hay clases disponibles.',
                          style: new TextStyle(
                              fontSize: 14.0, color: Colors.blueGrey))),
                ],
              );

            return new ListView.builder(
              itemCount: list == null ? 0 : list.length,
              itemBuilder: (context, i) {
                return new Container(
                  child: new GestureDetector(
                    onTap: () {
                      if(list[i]['clase_nombre'].toString() == 'Pista'){
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.RIGHSLIDE,
                            headerAnimationLoop: false,
                            title: 'Advertencia',
                            desc: '¿Esta seguro de registrar una sesión de Pista?',
                            btnOkOnPress: () {
                              _updateIsLoading(true);
                              final response = databaseHelper
                                  .createSession(list[i]['clase_id'].toString(), list[i]['clase_nombre'].toString());
                              response.then((value) {
                                _updateIsLoading(false);
                                if (value == 1) {
                                  Dialogs.successDialog(
                                      context, "La sesión ha sido registrada");
                                } else if (value == 2) {
                                  Dialogs.errorDialog(
                                      context, "El código QR del coach es incorrecto.");
                                } else if (value == 3) {
                                  Dialogs.errorDialog(context,
                                      "Ya se ha registrado una sesión el día de hoy.");
                                } else if (value == 4) {
                                  Dialogs.errorDialog(context,
                                      "El código QR no corresponde a ningun coach.");
                                }
                              });
                            },
                            btnOkIcon: Icons.check_circle,
                            btnOkColor: Colors.green)
                          ..show();

                      }else{
                        _updateIsLoading(true);
                        final response = databaseHelper
                            .createSession(list[i]['clase_id'].toString(), list[i]['clase_nombre'].toString());
                        response.then((value) {
                          print(value.toString());
                          _updateIsLoading(false);
                          if (value == 1) {
                            Dialogs.successDialog(
                                context, "La sesión ha sido registrada");
                          } else if (value == 2) {
                            Dialogs.errorDialog(
                                context, "El código QR del coach es incorrecto.");
                          } else if (value == 3) {
                            Dialogs.errorDialog(context,
                                "Ya se ha registrado una sesión el día de hoy.");
                          } else if (value == 4) {
                            Dialogs.errorDialog(context,
                                "El código QR no corresponde a ningun coach.");
                          }
                        });
                      }


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
                            _isLoading
                                ? SizedBox(
                                    child: CircularProgressIndicator(),
                                    height: 15.0,
                                    width: 15.0,
                                  )
                                : Icon(
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
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
            return new ItemList(
              list: list,
            );
          }
          return new Center(
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

  bool _isLoading = false;

  get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
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
              isLoading = true;
              final response =
                  databaseHelper.createSession(list[i]['clase_id'].toString(), list[i]['clase_nombre'].toString());
              response.then((value) {
                print(value.toString());
                isLoading = false;
                if (value == 1) {
                  Dialogs.successDialog(
                      context, "La sesión ha sido registrada");
                } else if (value == 2) {
                  Dialogs.errorDialog(
                      context, "El código QR del coach es incorrecto.");
                } else if (value == 3) {
                  Dialogs.errorDialog(
                      context, "Ya se ha registrado una sesión el día de hoy.");
                } else if (value == 4) {
                  Dialogs.errorDialog(
                      context, "El código QR no corresponde a ningun coach.");
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
                    isLoading
                        ? SizedBox(
                            child: CircularProgressIndicator(),
                            height: 10.0,
                            width: 10.0,
                          )
                        : Icon(
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
