//widget
// stless
import 'package:flutter/material.dart';
import 'package:handicraft_online_store/presentation/Screens/welcome.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen()
    );
   } // Material app
}