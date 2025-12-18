import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account Screen",
          style: TextStyle(
            fontFamily: "open sans bold",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 121, 136, 105),
      ),
      body: Center(
        child: Text(
          "Account Screen",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "open sans bold",
          ),
        ),
      ),
    );;
  }
}