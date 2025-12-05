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

      await prefs.setString("userId", userIdController.text);
      await prefs.setString("password", passwordController.text);

      // Save login state
      await prefs.setBool("isLoggedIn", true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );

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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Create Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),
                const Text("USER ID"),
                TextFormField(
                  controller: userIdController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter User ID" : null,
                ),

                const SizedBox(height: 20),
                const Text("PASSWORD"),
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

                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _signUpUser,
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
