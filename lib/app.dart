//widget
// stless
import 'package:flutter/material.dart';
import 'package:mitho_bakery/Screens/Home_Screen.dart';
import 'package:mitho_bakery/Screens/login_screens.dart';
import 'package:mitho_bakery/Screens/signup_screen.dart';
import 'package:mitho_bakery/Screens/welcome.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen()
    );
   } // Material app
}