import 'package:flutter/material.dart';
import 'package:mitho_bakery/Screens/signup_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Create a GlobalKey for the Form
  final _formKey = GlobalKey<FormState>(); 

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Function to handle the validation when 'Next' is pressed
  void _submitForm() {
    // 2. Validate all fields in the form
    if (_formKey.currentState!.validate()) {
      // If validation passes, proceed with login logic
      print('Form is valid. Proceeding to login...');
      // *** Your actual login logic would go here ***
    } else {
      // If validation fails, show a snackbar or just rely on the error messages from TextFormField
      print('Form is invalid. Please fill in the required fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // 3. Wrap the content in a Form widget
        child: Form(
          key: _formKey, // Assign the GlobalKey
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back arrow (remains the same)
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

                // 4. Use TextFormField for email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
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
                  // 5. Add a validator function
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email/User ID';
                    }
                    return null; // Return null if the input is valid
                  },
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

                // 6. Use TextFormField for password
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                  ),
                  // 7. Add a validator function
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null; // Return null if the input is valid
                  },
                ),

                SizedBox(height: 10),

                // Forgot password (remains the same)
                Text(
                  "I forgot my password",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 35),

                // Don't have account (remains the same)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
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
                    // 8. Call the submit function on press
                    onPressed: _submitForm, 
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
      ),
    );
  }
}
