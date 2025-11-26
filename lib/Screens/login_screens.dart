import 'package:flutter/material.dart';
import 'package:mitho_bakery/Screens/signup_screen.dart';


class EmailLoginScreen extends StatefulWidget {
  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              // Back arrow
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Continue with ID and Password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              SizedBox(height: 30),

              // Email label
              Text(
                "User ID",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),

              // Email textfield
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  suffixIcon: emailController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              emailController.clear();
                            });
                          },
                        ),
                ),
                onChanged: (_) => setState(() {}),
              ),

              SizedBox(height: 25),

              // Password label
              Text(
                "PASSWORD",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),

              // Password field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                ),
              ),

              SizedBox(height: 10),

              // Forgot password
              Text(
                "I forgot my password",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 35),

              // Don't have account
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                     context,
                      MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                     );
                  },

                  child: Text(
                    "Don't have account? Let's create!",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              Spacer(),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
