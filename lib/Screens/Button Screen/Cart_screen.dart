import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart Screen",
          style: TextStyle(
            fontFamily: "open sans bold",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 121, 136, 105),
      ),
      body: Center(
        child: Text(
          "Cart Screen",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "open sans bold",
          ),
        ),
      ),
    );;
  }
}