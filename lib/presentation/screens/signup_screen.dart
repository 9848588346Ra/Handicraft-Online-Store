import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/user_entity.dart';
import '../../theme/theme_data.dart';
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
      backgroundColor: HandicraftColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 22),
                    color: HandicraftColors.textPrimary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: HandicraftColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Join us and start shopping for unique handicrafts",
                    style: TextStyle(
                      fontSize: 14,
                      color: HandicraftColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // NAME
                  const Text(
                    "NAME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 13,
                      color: HandicraftColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(
                      color: HandicraftColors.textPrimary,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(
                        color: HandicraftColors.textSecondary.withOpacity(0.6),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: HandicraftColors.borderLight, width: 1.5)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: HandicraftColors.primary, width: 2)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.5)),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter Name" : null,
                  ),
                  const SizedBox(height: 32),

                  // EMAIL
                  const Text(
                    "EMAIL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 13,
                      color: HandicraftColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(
                      color: HandicraftColors.textPrimary,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                        color: HandicraftColors.textSecondary.withOpacity(0.6),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: HandicraftColors.borderLight, width: 1.5)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: HandicraftColors.primary, width: 2)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.5)),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
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
                  const SizedBox(height: 32),

                  // PASSWORD
                  const Text(
                    "PASSWORD",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 13,
                      color: HandicraftColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    style: const TextStyle(
                      color: HandicraftColors.textPrimary,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      hintStyle: TextStyle(
                        color: HandicraftColors.textSecondary.withOpacity(0.6),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: HandicraftColors.borderLight, width: 1.5)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: HandicraftColors.primary, width: 2)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.5)),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility : Icons.visibility_off,
                          color: HandicraftColors.textSecondary,
                          size: 22,
                        ),
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
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              print('Next button clicked!');
                              _signUpUser();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoading
                            ? HandicraftColors.primary.withOpacity(0.6)
                            : HandicraftColors.primary,
                        elevation: isLoading ? 0 : 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),
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
