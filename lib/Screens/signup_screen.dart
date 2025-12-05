import 'package:flutter/material.dart';
import 'package:mitho_bakery/DatabaseHelper/Database_Helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = false;

  @override
  void dispose() {
    // Dispose controllers to free up memory
    nameController.dispose();
    surnameController.dispose();
    birthdateController.dispose();
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signUpUser() async {
    if (_formKey.currentState!.validate()) {
      
      // Data collection
      final name = nameController.text;
      final surname = surnameController.text;
      final birthdate = birthdateController.text;
      final userId = userIdController.text;
      final password = passwordController.text;

      final dbHelper = DatabaseHelper();
      
      try {
        int id = await dbHelper.insertUser(
          name,
          surname,
          birthdate,
          userId,
          password,
        );
        
        // Success feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created successfully for User ID: $userId (DB ID: $id)')),
          );

        }

      } catch (e) {
        print('Error registering user: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed. The User ID might already be taken.')),
          );
        }
      }
    } else {
      print('Form is invalid. Please fill all required fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back + Title
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                buildLabel("NAME"),
                buildFormField(nameController, "Enter your name"),

                SizedBox(height: 20),

                buildLabel("SURNAME"),
                buildFormField(surnameController, "Enter your surname"),

                SizedBox(height: 20),

                buildLabel("BIRTHDATE"),
                buildFormField(
                  birthdateController,
                  "mm/dd/yyy",
                  inputType: TextInputType.datetime,
                ),

                SizedBox(height: 20),


                buildLabel("USER ID"),
                buildFormField(
                  userIdController,
                  "Enter your user ID",
                  inputType: TextInputType.text,
                ),

                SizedBox(height: 20),

                buildLabel("PASSWORD"),
                TextFormField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                  // Validation for password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required.';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 40),

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
                    // Call the submission function
                    onPressed: _signUpUser, 
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


  Widget buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  // Reusable Form Field Widget with Validation
  Widget buildFormField(TextEditingController controller, String hint,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
      ),
      // Validation to ensure the field is not empty
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hint cannot be empty';
        }
        return null;
      },
    );
  }
}