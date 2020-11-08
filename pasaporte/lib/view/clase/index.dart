import 'package:flutter/material.dart';
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:pasaporte/view/clase/show.dart';

class ClassIndex extends StatefulWidget {
  @override
  _ClassIndexState createState() => _ClassIndexState();
}

class _ClassIndexState extends State<ClassIndex> {
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
        title: new Text("Clases"),
      ),
      body: new FutureBuilder<List>(
        future: databaseHelper.getClass(),
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
                  builder: (BuildContext context) => new ClassShow(
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
