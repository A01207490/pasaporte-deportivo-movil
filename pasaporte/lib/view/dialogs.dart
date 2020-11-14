import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> acceptDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title,
              style: new TextStyle(
                fontSize: 18.0,
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  body,
                  style: new TextStyle(fontSize: 14.0, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
