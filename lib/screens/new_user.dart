import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:ndialog/ndialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final/screens/databaseuser_helper.dart';
import '../models/users_model.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PickedFile? imageFile;
  DatabaseHelper? _database;
  bool ban = false;
  String imagePath = "";

  TextEditingController txtConName = TextEditingController();
  TextEditingController txtConEmail = TextEditingController();
  TextEditingController txtConPhone = TextEditingController();
  TextEditingController txtConGit = TextEditingController();

  @override
  void initState() {
    super.initState();
    _database = DatabaseHelper();
  }

  void _openGallery(BuildContext context) async {
    var picture =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture as PickedFile?;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    var picture =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture as PickedFile?;
    });
    Navigator.of(context).pop();
  }

  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(File(imageFile!.path), width: 500, height: 500);
    } else {
      return Image.asset('assets/');
    }
  }

  bool _val() {
    if (imageFile != null) {
      return true;
    } else {
      return false;
    }
  }

  bool _valPR() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final User = ModalRoute.of(context)!.settings.arguments as Map;
      imagePath = User['imagen'];
    }
    if ("".compareTo(imagePath) != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _facebookLogged() async {
    FacebookAuth facebookAuth = FacebookAuth.getInstance();
    bool isLogged = await facebookAuth.accessToken != null;
    if (isLogged == null) {
      GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;
      bool isLogged = await googleuser?.authentication != null;
    }
    return Future.value(isLogged);
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Donde buscar la imagen?"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FloatingActionButton(
                    child: const Icon(Icons.image),
                    onPressed: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  FloatingActionButton(
                    child: const Icon(Icons.camera_alt),
                    onPressed: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ));
      },
    );
  }

  Widget _botones() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          child: const Text(
            'Delete',
            style: TextStyle(fontSize: 15),
          ),
          onPressed: () async {
            if (_valPR()) {
              NDialog(
                dialogStyle: DialogStyle(titleDivider: true),
                title: Text("Advertencia!!"),
                content: Text("¿Realmente quieres borrar tus datos? "),
                actions: <Widget>[
                  TextButton(
                      child: Text("Aceptar"),
                      onPressed: () {
                        _database!.eliminarUser(1, 'tblUser').then((value) {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/dash'));
                          final snackBar = SnackBar(
                              content: Text(
                                  'Información eliminada correctamente!!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }),
                  TextButton(
                      child: Text("Cerrar"),
                      onPressed: () => Navigator.pop(context)),
                ],
              ).show(context);
            } else {
              await DialogBackground(
                  dialog: AlertDialog(
                title: Text("Alert Dialog"),
                content: Text("No hay datos guardados"),
                backgroundColor: Colors.red,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
                contentTextStyle: TextStyle(color: Colors.white),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(70, 70),
            shape: const CircleBorder(),
          ),
        ),
      ),
      Container(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 15),
          ),
          onPressed: () async {
            if (txtConName.text.isEmpty ||
                txtConEmail.text.isEmpty ||
                txtConPhone.text.isEmpty ||
                txtConGit.text.isEmpty ||
                !(_val() || _valPR())) {
              await DialogBackground(
                dialog: AlertDialog(
                  title: Text("Alert Dialog"),
                  content: Text(
                      "Necesitas completar todos los campos y revisar que se añadio una imagen"),
                  backgroundColor: Colors.red,
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
                  contentTextStyle: TextStyle(color: Colors.white),
                ),
              ).show(context);
            } else {
              if (!ban) {
                final File image = File(imageFile!.path);
                Directory carpeta = await getApplicationDocumentsDirectory();
                final String path = carpeta.path;
                final File localImage = await image.copy('$path/image.jpg');
                _database?.insertar({
                  'imagen': localImage.path,
                  'nombre': txtConName.text,
                  'correo': txtConEmail.text,
                  'numero': txtConPhone.text,
                  'urlGit': txtConGit.text
                }, 'tblUser').then((value) {
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                      content:
                          Text('Datos de Usuario Registrados Correctamente!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              } else {
                if (_val()) {
                  final File image = File(imageFile!.path);
                  Directory carpeta = await getApplicationDocumentsDirectory();
                  final String path = carpeta.path;
                  final File localImage = await image.copy('$path/image.jpg');
                  _database?.actualizarUsers({
                    'id_Usuario': 1,
                    'imagen': localImage.path,
                    'nombre': txtConName.text,
                    'correo': txtConEmail.text,
                    'numero': txtConPhone.text,
                    'urlGit': txtConGit.text
                  }, 'tblUser').then((value) {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                        content: Text(
                            'Datos de Usuario Actualizados Correctamente!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                } else {
                  _database?.actualizarUsers({
                    'id_Usuario': 1,
                    'imagen': imagePath,
                    'nombre': txtConName.text,
                    'correo': txtConEmail.text,
                    'numero': txtConPhone.text,
                    'urlGit': txtConGit.text
                  }, 'tblUser').then((value) {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                        content: Text(
                            'Datos de Usuario Actualizados Correctamente!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(70, 70),
            shape: const CircleBorder(),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final User = ModalRoute.of(context)!.settings.arguments as Map;
      ban = true;
      imagePath = User['imagen'];
      txtConName.text = User['nombre'];
      txtConEmail.text = User['correo'];
      txtConPhone.text = User['numero'];
      txtConGit.text = User['urlGit'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Información de perfil'),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 5),
            height: MediaQuery.of(context).size.height / 4,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                FutureBuilder(
                    future: _database!.getUser(),
                    builder: (context, AsyncSnapshot<List<UsersDAO>> snapshot) {
                      if (_val()) {
                        return Hero(
                            tag: 'profile',
                            child: CircleAvatar(
                              radius: 200,
                              backgroundImage: FileImage(File(imageFile!.path)),
                            ));
                      } else {
                        if (snapshot.hasData && snapshot.data?.length != 0) {
                          return Hero(
                              tag: 'profile',
                              child: CircleAvatar(
                                radius: 200,
                                backgroundImage: FileImage(File(imagePath)),
                              ));
                        } else {
                          return FutureBuilder(
                            future: _facebookLogged(),
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshotFace) {
                              if (snapshotFace.hasData) {
                                if (snapshotFace.data!) {
                                  return Hero(
                                    tag: 'profile',
                                    child: CircleAvatar(
                                      radius: 100,
                                      backgroundImage: NetworkImage(imagePath),
                                    ),
                                  );
                                } else {
                                  return Hero(
                                    tag: 'profile',
                                    child: CircleAvatar(
                                      radius: 100,
                                      backgroundImage: AssetImage(
                                        'assets/default-user-image.jpg',
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Hero(
                                  tag: 'profile',
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundImage: AssetImage(
                                      'assets/default-user-image.jpg',
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      }
                    }),
                FutureBuilder(
                    future: _facebookLogged(),
                    builder: ((context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!) {
                          return InkWell(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(
                                  Icons.facebook,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {});
                        } else {
                          return InkWell(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () => _showSelectionDialog(context),
                          );
                        }
                      } else {
                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () => _showSelectionDialog(context),
                        );
                      }
                    })),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          TextField(
            controller: txtConName,
            decoration: InputDecoration(
                labelText: 'Nombre Completo',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                hintText: 'Nombre Completo'),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          TextField(
            controller: txtConEmail,
            decoration: InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                hintText: 'ejemplo@correo.com'),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          IntlPhoneField(
            controller: txtConPhone,
            initialCountryCode: 'MX',
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            /*onChanged: (phone) {
              print(phone.completeNumber);
            },*/
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          TextField(
            controller: txtConGit,
            decoration: InputDecoration(
                labelText: 'Pagina de GitHub',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                hintText: 'https://github.com/user/Proyect'),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 15)),
          FutureBuilder(
              future: _facebookLogged(),
              builder: ((context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return Center(
                      child: Text(
                        'Usted esta Loggeado con facebook',
                        style: GoogleFonts.anton(fontSize: 20),
                      ),
                    );
                  } else {
                    return _botones();
                  }
                } else {
                  return _botones();
                }
              })),
        ],
      ),
    );
  }
}
