import 'package:flutter/material.dart';
import 'package:proyecto_final/provider/theme_provider.dart';
import 'package:proyecto_final/settings/styles_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switcher/switcher.dart';
import 'package:switcher/core/switcher_size.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider tema = Provider.of<ThemeProvider>(context);
    late SharedPreferences _prefs;

    return Scaffold(
      body: Center(
        child: Column(children: [

          TextButton.icon(
            onPressed: () async {
              
            },
            icon: Icon(Icons.brightness_1),
            label: Text('Cambiar Tema'),
          ),

          Switcher(
            value: false,
            size: SwitcherSize.large,
            switcherButtonRadius: 50,
            enabledSwitcherButtonRotate: false,
            colorOff: Colors.blueGrey.withOpacity(0.3),
            colorOn: Colors.blue,
            onChanged: (bool state) async {

              if(state ==  true){
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              _prefs.setString('theme', 'noche');
              tema.setthemeData(temaNoche());

              }else if(state == false){
               SharedPreferences _prefs = await SharedPreferences.getInstance();
              _prefs.setString('theme', 'dia');
              tema.setthemeData(temaDia());

              }
            },
          ),
          
          
        ]),
      ),
    );
  }
}
