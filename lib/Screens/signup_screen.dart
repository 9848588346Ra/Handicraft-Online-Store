import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  Future<void> _signUpUser() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      // Save user ID & password locally
      await prefs.setString("userId", userIdController.text);
      await prefs.setString("password", passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );

      // Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                SizedBox(height: 20),
                Text("USER ID"),
                TextFormField(
                  controller: userIdController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter User ID" : null,
                ),

                SizedBox(height: 20),
                Text("PASSWORD"),
                TextFormField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  validator: (value) =>
                      value!.isEmpty ? "Enter Password" : null,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _signUpUser,
                  child: Text("Next"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
