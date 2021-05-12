import 'dart:js';

import 'package:flutter/material.dart';
import 'package:terera_start_app/login.dart';
import 'package:terera_start_app/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black54,
        primaryColor: Colors.black54,
      ),
      initialRoute: Welcome.id,
      routes: {
        Welcome.id: (context) => Welcome(),
        LoginScreen.id: (context) => LoginScreen(),
      },
    );
  }
}
