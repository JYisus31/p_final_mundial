import 'package:flutter/material.dart';
import 'package:proyecto_final/firebase/email_authentication.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController txtConName = TextEditingController();
  TextEditingController txtConEmail = TextEditingController();
  TextEditingController txtConPass = TextEditingController();
  EmailAuthentication? _emailAuth;

  static const String _title = 'Sign Up';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailAuth = EmailAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
          appBar: AppBar(title: const Text(_title)),
          body: Container(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Mundial Qatar 2022',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Raleway',
                          ),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: txtConName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: txtConEmail,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: txtConPass,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                        height: 100,
                        padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Login'),
                          onPressed: () async {
                            showLoaderDialog(context);
                            _emailAuth!
                                .createUserWithEmailAndPassword(
                                    email: txtConEmail.text,
                                    password: txtConPass.text)
                                .then((value) {});

                            new Future.delayed(new Duration(seconds: 3), () {
                              Navigator.pushNamed(context, '/login');
                            });
                          },
                        )),
                  ],
                )),
          )),
    );
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
