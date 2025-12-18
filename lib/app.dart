//widget
// stless
import 'package:flutter/material.dart';
import 'package:mitho_bakery/Screens/Dashboard_screen.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen()
    );
   } // Material app
}