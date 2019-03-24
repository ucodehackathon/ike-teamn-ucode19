import 'package:flutter/material.dart';
import 'package:ucode_app/screens/menu.dart';
import 'package:ucode_app/screens/select_training.dart';
import 'package:ucode_app/screens/ranking.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/select-training': (BuildContext context) => new SelectTraining(),
    '/ranking': (BuildContext context) => new Ranking(),
    //'/training' : (BuildContext context) => new Training(), // lanzado sin pushnamed
  };

  Routes() {
    runApp(new MaterialApp(
      title: 'uCode Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF407520)),
      routes: routes,
      home: Menu(),
    ));
  }
}
