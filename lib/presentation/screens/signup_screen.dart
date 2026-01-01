import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/user_entity.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _injectionContainer = InjectionContainer();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;

  Future<void> _signUpUser() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill in all fields correctly"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    print('Starting signup process...');
    print('Name: ${nameController.text.trim()}');
    print('Email: ${emailController.text.trim()}');
    print('Password length: ${passwordController.text.length}');
    
    setState(() {
      isLoading = true;
    });

    try {
      // Ensure container is initialized
      if (!_injectionContainer.isInitialized) {
        print('Container not initialized, initializing now...');
        await _injectionContainer.init();
      }

      final user = UserEntity(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      print('Creating user: ${user.email}');
      
      // Sign up the user
      await _injectionContainer.signUpUseCase(user);
      print('User created successfully');

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully! Please login to continue."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e, stackTrace) {
      print('SignUp Error: $e');
      print('Stack trace: $stackTrace');
      
      if (mounted) {
        String errorMessage = 'Failed to create account';
        String errorDetails = '';
        
        if (e is Exception) {
          final errorString = e.toString();
          if (errorString.contains('Exception: ')) {
            errorMessage = errorString.replaceAll('Exception: ', '');
          } else {
            errorMessage = errorString;
          }
          
          // Add more specific error details
          if (errorString.contains('already exists')) {
            errorMessage = 'This email is already registered. Please use a different email or try logging in.';
            errorDetails = 'Email: ${emailController.text.trim()}';
          } else if (errorString.contains('Hive')) {
            errorMessage = 'Storage error: Unable to save user data. Please try again.';
            errorDetails = 'Error: $errorString';
          } else {
            errorDetails = 'Error: $errorString';
          }
        } else {
          errorMessage = 'An unexpected error occurred';
          errorDetails = 'Error: ${e.toString()}';
        }
        
        // Show error message with details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (errorDetails.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      errorDetails,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Email";
                      }
                      if (!value.contains('@')) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),

                  // NEXT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              print('Next button clicked!');
                              _signUpUser();
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Next",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
