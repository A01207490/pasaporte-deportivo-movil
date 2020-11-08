import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:pasaporte/view/announcement/show.dart';

class AnnouncementIndex extends StatefulWidget {
  @override
  _AnnouncementIndexState createState() => _AnnouncementIndexState();
}

class _AnnouncementIndexState extends State<AnnouncementIndex> {
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
        title: new Text("Anuncios"),
      ),
      body: new FutureBuilder<List>(
        future: databaseHelper.getAnnouncement(),
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
                  builder: (BuildContext context) => new AnnouncementShow(
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
                      Icons.announcement,
                      color: Color(0xFF0075BC),
                    ),
                  ],
                ),
                title: new Text(
                  'Anuncio',
                  style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                ),
                subtitle: new Text(
                  list[i]['anuncio_titulo'].toString(),
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
