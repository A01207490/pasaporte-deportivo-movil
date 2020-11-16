import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pasaporte/view/session/index.dart';

class Dialogs {
  static Future<void> successDialog(
    BuildContext context,
    String body,
  ) async {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'Éxito',
        desc: body,
        btnOkOnPress: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => SessionIndex()));
        },
        dismissOnTouchOutside: false,
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        })
      ..show();
  }

  static Future<void> errorDialog(
    BuildContext context,
    String body,
  ) async {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        title: 'Error',
        desc: body,
        btnOkOnPress: () {

        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }


}
