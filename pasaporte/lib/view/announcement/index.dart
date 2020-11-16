import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:pasaporte/view/announcement/show.dart';
import 'package:intl/date_symbol_data_local.dart';

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
    initializeDateFormatting('es_ES', null);
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
  DataBaseHelper databaseHelper = new DataBaseHelper();

  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
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
          child: ExpandableNotifier(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF071A2D),
                        image: DecorationImage(
                          image: NetworkImage(
                              databaseHelper.announcementImagesUrl +
                                  list[i]['id'].toString() +
                                  '.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15.0, right: 0.0, left: 25.0),
                          child: Text(
                            list[i]['anuncio_titulo'].toString() +
                                '\n' +
                                DateFormat.yMMMMd('es').format(DateTime.parse(
                                  list[i]['fecha_registro'].toString(),
                                )),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          )),
                      collapsed: Text(
                        list[i]['anuncio_cuerpo'].toString(),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 0, bottom: 0.0, right: 0.0, left: 0.0),
                              child: Text(
                                list[i]['anuncio_cuerpo'].toString(),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )),
                        ],
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding:
                          EdgeInsets.only(
                              top: 0, bottom: 20.0, right: 25.0, left: 25.0),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme: const ExpandableThemeData(crossFadePoint: 0),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
        ));
      },
    );
  }
}
