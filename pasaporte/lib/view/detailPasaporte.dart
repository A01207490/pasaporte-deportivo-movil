import 'package:flutter/material.dart';

class Detail extends StatefulWidget {

  List list;
  int index;
  Detail({this.index,this.list});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  //https://medium.com/flutter-community/working-with-dates-in-dart-e81c70911811
  @override
  Widget build(BuildContext context) {
     return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.indigo[900],
          title: new Text("${widget.list[widget.index]['clase_nombre']}")
      ),
      body: new Container(
        height: 270.0, 
        padding: const EdgeInsets.all(20.0),
        child: new ListView(
          children: <Widget>[
            new ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.verified_user, color: Colors.blueGrey,),
                ],
              ),
              title: new Text('Coach', style: new TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
              subtitle: new Text("${widget.list[widget.index]['coach_nombre']}", style: new TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
            new Divider(),
            new ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.calendar_today, color: Colors.blueGrey,),
                ],
              ),
              title: new Text('Día', style: new TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
              subtitle: new Text("${widget.list[widget.index]['created_at']}", style: new TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
            new Divider(),
            new ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.access_time, color: Colors.blueGrey,),
                ],
              ),
              title: new Text('Horario', style: new TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
              subtitle: new Text("${widget.list[widget.index]['clase_hora_inicio']}" + " - " + " ${widget.list[widget.index]['clase_hora_fin']}", style: new TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
            new Divider(),
          ],
        ),
      ),
     );
  }
}