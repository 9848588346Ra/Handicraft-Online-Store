import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

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

      await prefs.setBool("isLoggedIn", true);

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button + Title Row
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.arrow_back_ios, size: 22, color: Colors.black87),
                  const SizedBox(width: 8),
                  const Text(
                    "Continue with E-mail",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 35),

              // EMAIL LABEL
              const Text(
                "E-MAIL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),

              // EMAIL INPUT
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  suffixIcon: idController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () => setState(() => idController.clear()),
                          child: const Icon(Icons.close, color: Colors.grey),
                        )
                      : null,
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                ),
                onChanged: (v) => setState(() {}),
              ),

              const SizedBox(height: 30),

              // PASSWORD LABEL
              const Text(
                "PASSWORD",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),

              // PASSWORD INPUT
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter your password",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                ),
              ),

              const SizedBox(height: 12),

              // FORGOT PASSWORD
              const Text(
                "I forgot my password",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // CREATE ACCOUNT TEXT BUTTON
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "Don’t have account? Let’s create!",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // NEXT BUTTON
              Center(
                child: GestureDetector(
                  onTap: _loginUser,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
