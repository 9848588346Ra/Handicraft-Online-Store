import 'package:flutter/material.dart';
import 'package:mitho_bakery/Screens/Button%20Screen/Shop_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  Future<void> _signUpUser() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("name", nameController.text);
      await prefs.setString("email", emailController.text);
      await prefs.setString("password", passwordController.text);

      await prefs.setBool("isLoggedIn", true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ShopScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // NAME
              const Text(
                "NAME",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  border: UnderlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Name" : null,
              ),
              const SizedBox(height: 20),

              // EMAIL
              const Text(
                "EMAIL",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Enter your email",
                  border: UnderlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Email" : null,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),

              // PASSWORD
              const Text(
                "PASSWORD",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Password" : null,
              ),
              const SizedBox(height: 50),

              // NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _signUpUser,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 18),
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
