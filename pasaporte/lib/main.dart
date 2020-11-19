import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:pasaporte/view/clase/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pasaporte/view/login.dart';
import 'package:pasaporte/view/session/index.dart';
import 'package:pasaporte/view/announcement/index.dart';

import 'controllers/databasehelpers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataBaseHelper(),
      child: MaterialApp(
          routes: {"/sessionIndex": (context) => SessionIndex()},
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
          )),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;
  String email;
  String name;
  @override
  void initState() {
    setUser();
    super.initState();
    checkLoginStatus();
  }
  setUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString('email') ?? "ak id";
      name = sharedPreferences.getString('name') ?? "ak id";
    });
  }


  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    final dataBaseHelper = Provider.of<DataBaseHelper>(context);

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
            MyCard('images/requisitos.png', 'Requisitos',
                'Cumplir 30 sesiones de mínimo 30 minutos y realizar las pruebas físicas al menos una vez .'),
            MyCard('images/consideraciones.jpg', 'Consideraciones',
                'Solo se puede registrar hasta un máximo de 15 sesiones de Pista.\n\nSolo se puede registrar una sesión por día.\n\nLas clases se pueden registrar hasta 20 minutos antes o después de que terminen. Gimnasio y Pista son excepciones.\n\nPara registrar una clase, es necesario escanear el código QR del coach. Pista es excepción.'),
          ],
        ),
      ),
      drawer: Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(name ?? ''),
              accountEmail: new Text(email ?? ''),
            ),
            ListTileTheme(
              iconColor: Color(0xFF0075BC),
              child: ListTile(
                title: new Text("Pasaporte",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0)),
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
                title: new Text("Anuncios",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0)),
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
                title: new Text("Clases",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0)),
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

class MyCard extends StatelessWidget {
  MyCard(this.image, this.title, this.body);

  final String image;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF071A2D),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 20.0, right: 30.0, left: 30.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 25.0, right: 30.0, left: 30.0),
              child: Text(body),
            ),
          ]),
    );
  }
}
