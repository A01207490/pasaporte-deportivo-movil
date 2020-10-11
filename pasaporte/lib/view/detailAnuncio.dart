import 'package:flutter/material.dart';

class DetailAnuncio extends StatefulWidget {

  List list;
  int index;
  DetailAnuncio({this.index,this.list});

  @override
  _DetailAnuncioState createState() => _DetailAnuncioState();
}

class _DetailAnuncioState extends State<DetailAnuncio> {

  //https://medium.com/flutter-community/working-with-dates-in-dart-e81c70911811
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.indigo[900],
          title: new Text("${widget.list[widget.index]['anuncio_titulo']}")
      ),
      body: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Card(
          child: new ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            title: new Text('Anuncio', style: new TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
            subtitle: new Text("${widget.list[widget.index]['anuncio_cuerpo']}", style: new TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
          ),
        ),
      );
  }
}