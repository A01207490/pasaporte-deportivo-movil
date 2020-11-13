import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pasaporte/view/clase/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pasaporte/view/login.dart';
import 'package:pasaporte/view/session/index.dart';
import 'package:pasaporte/view/announcement/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Pasaporte Deportivo",
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Color(0xFF071A2D),
          accentColor: Color(0xFF0033A0),

          // Define the default font family.
          fontFamily: 'Ubuntu',
          appBarTheme: AppBarTheme(
            color: Color(0xFF071A2D),
          ),
          iconTheme: new IconThemeData(
            color: Color(0xFF0033A0),
            opacity: 1.0,
          ),
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ));
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    IconThemeData iconThemeData = IconTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pasaporte Deportivo"),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
      ),
      body: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new ListView(
          children: <Widget>[
            new ListTile(
                title: new Text(
                    'Bienvenido, participa en las clases o clínicas deportivas que desees.',
                    style:
                        new TextStyle(fontSize: 16.0, color: Colors.blueGrey))),
            new ListTile(
              title: RichText(
                text: TextSpan(
                  text: '• ',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Cumplir 30 sesiones de 30 minutos como mínimo.',
                    ),
                  ],
                ),
              ),
            ),
            new ListTile(
              title: RichText(
                text: TextSpan(
                  text: '• ',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Realizar las pruebas físicas al menos una vez.',
                    ),
                  ],
                ),
              ),
            ),
          
          ],
        ),
      ),
      drawer: Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('Pasaporte Deportivo'),
              accountEmail: new Text(sharedPreferences.getString('email')),
            ),
            ListTileTheme(
              iconColor: Color(0xFF0075BC),
              child: ListTile(
                title:
                    new Text("Pasaporte", style: new TextStyle(fontSize: 16.0)),
                leading: FaIcon(FontAwesomeIcons.passport),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => SessionIndex(),
                )),
              ),
            ),
            new Divider(),
            ListTileTheme(
              iconColor: Color(0xFF0075BC),
              child: ListTile(
                title:
                    new Text("Anuncios", style: new TextStyle(fontSize: 16.0)),
                leading: new Icon(Icons.announcement),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => AnnouncementIndex(),
                )),
              ),
            ),
            new Divider(),
            ListTileTheme(
              iconColor: Color(0xFF0075BC),
              child: ListTile(
                title: new Text("Clases", style: new TextStyle(fontSize: 16.0)),
                leading: new Icon(Icons.class__rounded),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => ClassIndex(),
                )),
              ),
            ),
            new Divider(),
          ],
        ),
      ),
    );
  }
}
