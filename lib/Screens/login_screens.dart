import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Future<void> _loginUser() async {
    final prefs = await SharedPreferences.getInstance();

    final savedId = prefs.getString("userId");
    final savedPass = prefs.getString("password");

    if (idController.text == savedId &&
        passController.text == savedPass) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid ID or Password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text("Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: "User ID"),
              ),

              SizedBox(height: 20),

              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: _loginUser,
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
