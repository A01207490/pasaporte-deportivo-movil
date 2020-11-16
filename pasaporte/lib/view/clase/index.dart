import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordian/gf_accordian.dart';
import 'package:grouped_list/grouped_list.dart';
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
    return GroupedListView<dynamic, String>(
      elements: list,
      groupBy: (element) => element['clase_nombre'],
      groupComparator: (value1, value2) => value2.compareTo(value1),
      itemComparator: (item1, item2) =>
          item1['clase_nombre'].compareTo(item2['clase_nombre']),
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: true,
      groupSeparatorBuilder: (String value) => Padding(
        padding: const EdgeInsets.all(10.0),

        child: Text(
          value,
          textAlign: TextAlign.center,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)
        ),
      ),
      itemBuilder: (c, element) {
        return ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Padding(
                        padding: EdgeInsets.all(0),
                        child: new ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.verified_user,
                                  color: Color(0xFF0075BC)),
                            ],
                          ),
                          title: new Text('Coach',
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.blueGrey)),
                          subtitle: new Text(element['coach_nombre'],
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.black)),
                        ),
                      ),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Divider(),
                          new ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.calendar_today,
                                    color: Color(0xFF0075BC)),
                              ],
                            ),
                            title: new Text('Día',
                                style: new TextStyle(
                                    fontSize: 12.0, color: Colors.blueGrey)),
                            subtitle: new Text(element['dias'],
                                style: new TextStyle(
                                    fontSize: 14.0, color: Colors.black)),
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
                                style: new TextStyle(
                                    fontSize: 12.0, color: Colors.blueGrey)),
                            subtitle: new Text(
                                element['clase_hora_inicio'] +
                                    " - " +
                                    element['clase_hora_fin'],
                                style: new TextStyle(
                                    fontSize: 14.0, color: Colors.black)),
                          ),
                        ],
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding:
                              EdgeInsets.only(left: 0, right: 0, bottom: 0),
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
          ),
          /*
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Icon(Icons.class__rounded),
              title: Text(element['clase_nombre']),
              subtitle: Text(element['clase_nombre']),
              trailing: Icon(Icons.arrow_forward),
            ), */
        );
      },
    );
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
                      Icons.class__rounded,
                      color: Color(0xFF0075BC),
                    ),
                  ],
                ),
                title: new Text(
                  list[i]['clase_nombre'].toString(),
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                ),
                subtitle: new Text(
                  list[i]['clase_hora_inicio'].toString() +
                      ' - ' +
                      list[i]['clase_hora_inicio'].toString(),
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
