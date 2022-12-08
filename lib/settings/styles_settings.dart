import 'package:flutter/material.dart';

ThemeData temaDia(){
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: Colors.blue,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Raleway'
    ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Raleway'
    ),
  );
}

ThemeData temaNoche(){
  final ThemeData base = ThemeData.dark();
  
  return base.copyWith(
    backgroundColor: Color.fromARGB(255, 75, 17, 5),

    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Raleway'
    ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Raleway'
    ),
  );
}

ThemeData temaCalido(){
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: Color.fromARGB(255, 231, 146, 26)
  );
}