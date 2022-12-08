import 'package:flutter/material.dart';
import 'package:proyecto_final/screens/ArgPlayers_screen.dart';
import 'package:proyecto_final/screens/FrPlayers_screen.dart';
import 'package:proyecto_final/screens/login_screen.dart';
import 'package:proyecto_final/screens/new_user.dart';
import 'package:proyecto_final/screens/sign_up_screen.dart';
import 'package:proyecto_final/screens/splash_screen.dart';
import 'package:proyecto_final/screens/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_final/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final/screens/teams_screen.dart';
import 'package:proyecto_final/screens/MxPlayers_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: PMSNApp()
    
    );
  }
}
 
class PMSNApp extends StatelessWidget {
const PMSNApp({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Practica 7',
      
      theme: tema.getthemeData(),
      home: const SplashScreen(),
      routes: {
          '/login' : (BuildContext context) => LoginScreen(),
          '/signup' : (BuildContext context) => SignUpScreen(),
          '/dash' : (BuildContext context) => DashboardScreen(),
          '/addUser' : (BuildContext context) => SignUpScreen(),
          '/profile' : (BuildContext context) => ProfileScreen(),
          '/teams' : (BuildContext context) => TeamsScreen(),
          '/mxplayers' :(BuildContext context) => MxPlayersScreen(),
          '/argplayers' :(BuildContext context) => ArgPlayersScreen(),
          '/frplayers' :(BuildContext context) => FrPlayersScreen()
        },
    );
  }
}

