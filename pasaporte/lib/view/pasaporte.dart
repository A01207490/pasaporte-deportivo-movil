import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pasaporte/view/detailProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pasaporte extends StatefulWidget {
  @override
  _PasaporteState createState() => _PasaporteState();
}

class _PasaporteState extends State<Pasaporte> {
  List data;

  Future<List> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final token = prefs.get(key) ?? 0;
    Map param = {'token': '$token'};
    var response = await http.post("http://10.0.0.4:8000/api/getSessions", body: param);
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
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo[900],
        title: new Text("Pasaporte"),
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
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(

          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new Detail(
                    list: list,
                    index: i,
                  )),
            ),
            child: new Card(
              child: new ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check, color: Colors.blueGrey,),
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