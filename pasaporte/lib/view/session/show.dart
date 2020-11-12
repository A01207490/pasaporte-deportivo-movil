import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionShow extends StatefulWidget {
  List list;
  int index;

  SessionShow({this.index, this.list});

  @override
  _SessionShowState createState() => _SessionShowState();
}

class _SessionShowState extends State<SessionShow> {
  @override
  Widget build(BuildContext context) {

    String created_at = DateFormat.MMMEd().format(DateTime.parse("${widget.list[widget.index]['fecha_registro']}"));

    return new Scaffold(
      appBar: new AppBar(
          title: new Text("${widget.list[widget.index]['clase_nombre']}")),
      body: new Container(
        height: 270.0,
        padding: const EdgeInsets.all(20.0),
        child: new ListView(
          children: <Widget>[
            new ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.verified_user, color: Color(0xFF0075BC)),
                ],
              ),
              title: new Text('Coach',
                  style: new TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
              subtitle: new Text("${widget.list[widget.index]['coach_nombre']}",
                  style: new TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
            new Divider(),
            new ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.calendar_today, color: Color(0xFF0075BC)),
                ],
              ),
              title: new Text('Día',
                  style: new TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
              subtitle: new Text(created_at,
                  style: new TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
            new Divider(),
            new ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: Color(0xFF0075BC),
                  ),
                ],
              ),
              title: new Text('Horario',
                  style: new TextStyle(fontSize: 12.0, color: Colors.blueGrey)),
              subtitle: new Text(
                  "${widget.list[widget.index]['clase_hora_inicio']}" +
                      " - " +
                      "${widget.list[widget.index]['clase_hora_fin']}",
                  style: new TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
            new Divider(),
          ],
        ),
      ),
    );
  }
}
