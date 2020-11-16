import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasaporte/controllers/databasehelpers.dart';
import 'package:photo_view/photo_view.dart';
class AnnouncementShow extends StatefulWidget {

  List list;
  int index;
  AnnouncementShow({this.index,this.list});

  @override
  _AnnouncementShowState createState() => _AnnouncementShowState();
}

class _AnnouncementShowState extends State<AnnouncementShow> {
  DataBaseHelper databaseHelper = new DataBaseHelper();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("${widget.list[widget.index]['anuncio_titulo']}")
      ),
      body: new Container(
        child: PhotoView(
          imageProvider: NetworkImage(
              databaseHelper.announcementImagesUrl +
                  "${widget.list[widget.index]['id']}" +
                  '.png'),
        )
        ),
      );
  }
}