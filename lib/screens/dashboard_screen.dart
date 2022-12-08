import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_final/screens/databaseuser_helper.dart';
import 'package:proyecto_final/screens/theme_screen.dart';
import 'package:proyecto_final/models/users_model.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DatabaseHelper? _database;
  String? emailU = "", imageU = "", nameU = "", gitU = "", phoneU = "";
  bool ban = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _database = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final User = ModalRoute.of(context)!.settings.arguments as Map;

      ban = true;
      emailU = User['usuarioEmail'];
      phoneU = User['phoneUser'];
      imageU = User['imageUser'];
      nameU = User['nameUser'];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 46, 95, 174),
        child: ListView(
          children: [
            ban == true
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://i0.wp.com/nayaritnoticias.com/wp-content/uploads/2022/11/62a53aaba796d.jpg?resize=696%2C392&ssl=1'),
                          fit: BoxFit.cover),
                    ),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile', arguments: {
                          'idUser': 1,
                          'imagen': imageU,
                          'nombre': nameU,
                          'correo': emailU,
                          'numero': phoneU,
                          'urlGit': '',
                        }).then((value) {
                          setState(() {});
                        });
                      },
                      child: Hero(
                        tag: 'profile',
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(imageU!)),
                      ),
                    ),
                    accountName: Text(
                      nameU!,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    accountEmail: Text(
                      emailU!,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : FutureBuilder(
                    future: _database!.getUser(),
                    builder: (context, AsyncSnapshot<List<UsersDAO>> snapshot) {
                      if (snapshot.hasData && snapshot.data?.length != 0) {
                        return UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://i0.wp.com/nayaritnoticias.com/wp-content/uploads/2022/11/62a53aaba796d.jpg?resize=696%2C392&ssl=1'),
                                fit: BoxFit.cover),
                          ),
                          currentAccountPicture: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile',
                                  arguments: {
                                    'idUser': snapshot.data![0].idUsuario,
                                    'imagen': snapshot.data![0].imagen,
                                    'nombre': snapshot.data![0].nombre,
                                    'correo': snapshot.data![0].correo,
                                    'numero': snapshot.data![0].numero,
                                    'urlGit': snapshot.data![0].urlGit,
                                  }).then((value) {
                                setState(() {});
                              });
                            },
                            child: Hero(
                              tag: 'profile',
                              child: CircleAvatar(
                                backgroundImage:
                                    FileImage(File(snapshot.data![0].imagen!)),
                              ),
                            ),
                          ),
                          accountName: Text(
                            snapshot.data![0].nombre!,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          accountEmail: Text(
                            snapshot.data![0].correo!,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://i0.wp.com/nayaritnoticias.com/wp-content/uploads/2022/11/62a53aaba796d.jpg?resize=696%2C392&ssl=1'),
                                fit: BoxFit.cover),
                          ),
                          currentAccountPicture: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile')
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Hero(
                              tag: 'profile',
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/default-user-image.jpg',
                                ),
                              ),
                            ),
                          ),
                          accountName: Text(
                            'No definido',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          accountEmail: Text(
                            'No definido',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    }),
            ListTile(
              leading: Image.asset('assets/balon.png'),
              trailing: Icon(Icons.chevron_right),
              title: Text('Equipos'),
              onTap: () async {
                Navigator.pushNamed(context, '/teams');
              },
            ),
            ListTile(
              leading: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/pmsn-mundial.appspot.com/o/MEXICO%2Fescudo-mexico.png?alt=media&token=29308f96-f933-4ac6-acc2-e40bf0046ce8"),
              trailing: Icon(Icons.chevron_right),
              title: Text('MÉXICO'),
              onTap: () async {
                Navigator.pushNamed(context, '/mxplayers');
                //await FirebaseMessaging.instance.subscribeToTopic("MX");
              },
            ),
            ListTile(
              leading: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/pmsn-mundial.appspot.com/o/ARGENTINA%2Fescudo-argentina.png?alt=media&token=945d12dd-fd28-4359-b24e-db23eb720042"),
              trailing: Icon(Icons.chevron_right),
              title: Text('ARGENTINA'),
              onTap: () async {
                Navigator.pushNamed(context, '/argplayers');
                //await FirebaseMessaging.instance.subscribeToTopic("ARG");
              },
            ),
            ListTile(
              leading: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/pmsn-mundial.appspot.com/o/FRANCIA%2Fescudo-francia.png?alt=media&token=960a0ba5-2d40-4da2-8f72-7591348c3490"),
              trailing: Icon(Icons.chevron_right),
              title: Text('FRANCIA'),
              onTap: () async {
                Navigator.pushNamed(context, '/frplayers');
                //await FirebaseMessaging.instance.subscribeToTopic("FR");
              },
            ),
            ListTile(
              leading: Image.asset('assets/balon.png'),
              trailing: Icon(Icons.chevron_right),
              title: Text('Cerrar Sesión'),
              onTap: () async {
                /*SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.setBool('login', true);*/
                FirebaseAuth.instance.signOut();
                FacebookAuth.instance.logOut();
                GoogleSignIn().signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
      body: ThemeScreen(),
    );
  }
}
