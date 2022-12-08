// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_final/firebase/email_authentication.dart';
import 'package:proyecto_final/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:proyecto_final/screens/theme_screen.dart';
import 'package:proyecto_final/provider/theme_provider.dart';
import 'package:proyecto_final/settings/styles_settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StreamSubscription? _subs;
  TextEditingController txtConUser = TextEditingController();
  TextEditingController txtConPwd = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailAuthentication _emailAuth = EmailAuthentication();

  bool? isChecked = false;

  late SharedPreferences _prefs;
  late bool newuser;
  late String t;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final txtUser = TextField(
      controller: txtConUser,
      decoration: InputDecoration(
        hintText: 'Introduce el usuario ',
        label: Text('Correo Electronico'),
      ),
      //onChanged: (value){},
    );
    final txtPwd = TextField(
      controller: txtConPwd,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Introduce el password ', label: Text('Contraseña')),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/estadio.jpg'), fit: BoxFit.cover),
        ),
        child: Stack(
          alignment: Alignment(0, -0.15),
          children: [
            Positioned(
              top: MediaQuery.of(context).size.width / 6,
              child: Image.asset(
                'assets/logo.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 20,
                right: MediaQuery.of(context).size.width / 20,
                bottom: MediaQuery.of(context).size.width / 20,
              ),
              color: Color.fromARGB(255, 255, 253, 253),
              child: ListView(
                shrinkWrap: true,
                children: [
                  txtUser,
                  SizedBox(
                    height: 10,
                  ),
                  txtPwd
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width / 1,
              bottom: MediaQuery.of(context).size.width / 2,
              width: 135,
              child: GestureDetector(
                onTap: () async {
                  var ban = await _emailAuth.signInWithEmailAndPassword(
                      email: txtConUser.text, password: txtConPwd.text);
                  if (ban == true) {
                    if (_auth.currentUser!.emailVerified) {
                      Navigator.pushNamed(context, '/dash');
                    } else {
                      print('Usuario no válido');
                    }
                  } else {
                    print('Credenciales inválidas');
                  }
                },
                child: Image.asset(
                  'assets/balon.png',
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.width / 15,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 20),
                //color: Colors.black,
                width: MediaQuery.of(context).size.width / 1.0,
                child: Column(
                  //shrinkWrap: true,
                  children: [
                    SocialLoginButton(
                      buttonType: SocialLoginButtonType.facebook,
                      onPressed: () async {
                        FacebookAuth facebookAuth = FacebookAuth.instance;
                        bool isLogged = await facebookAuth.accessToken != null;
                        if (!isLogged) {
                          LoginResult result = await facebookAuth
                              .login(); // by default we request the email and the public profile
                          if (result.status == LoginStatus.success) {
                            // you are logged
                            AccessToken? token = await facebookAuth.accessToken;
                            final _userData = await facebookAuth.getUserData();
                            Navigator.pushNamed(context, '/dash', arguments: {
                              'idUser': _userData['id'],
                              'imageUser': _userData['picture']['data']['url'],
                              'nameUser': _userData['name'],
                              'usuarioEmail': _userData['email'],
                              'phoneUser': '',
                              'urlGit': '',
                            });
                          }
                        } else {
                          FacebookAuth.instance.logOut();
                          LoginResult result = await facebookAuth
                              .login(); // by default we request the email and the public profile
                          if (result.status == LoginStatus.success) {
                            // you are logged
                            AccessToken? token = await facebookAuth.accessToken;
                            final _userData = await facebookAuth.getUserData();
                            Navigator.pushNamed(context, '/dash', arguments: {
                              'idUser': _userData['id'],
                              'imageUser': _userData['picture']['data']['url'],
                              'nameUser': _userData['name'],
                              'usuarioEmail': _userData['email'],
                              'phoneUser': '',
                              'urlGit': '',
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    SocialLoginButton(
                        buttonType: SocialLoginButtonType.google,
                        onPressed: () async {
                          singInWithGoogle();
                        }),
                  ],
                ),
              ),
            ),
            Positioned(
                //   top: MediaQuery.of(context).size.width/4 ,
                bottom: MediaQuery.of(context).size.width / 2,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  singInWithGoogle() async {
    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushNamed(context, '/dash', arguments: {
      'idUser': userCredential.user?.uid,
      'imageUser': userCredential.user?.photoURL,
      'nameUser': userCredential.user?.displayName,
      'usuarioEmail': userCredential.user?.email,
      'phoneUser': '----------',
      'urlGit': '',
    });
  }
}
