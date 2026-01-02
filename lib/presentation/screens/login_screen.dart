import 'package:flutter/material.dart';
import 'package:handicraft_online_store/presentation/Screens/Dashboard_screen.dart';
import '../../core/di/injection_container.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _injectionContainer = InjectionContainer();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;

  Future<void> _loginUser() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Ensure container is initialized
      if (!_injectionContainer.isInitialized) {
        print('Container not initialized, initializing now...');
        await _injectionContainer.init();
      }

      print('Attempting login for: ${emailController.text.trim()}');
      final success = await _injectionContainer.loginUseCase(
        emailController.text.trim(),
        passwordController.text,
      );
      print('Login result: $success');

      if (mounted) {
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email or password")),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Login Error: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        String errorMessage = 'Login failed';
        if (e is Exception) {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        } else {
          errorMessage = e.toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button + Title Row
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 22),
                        color: Colors.black87,
                        onPressed: () => Navigator.pop(context),
                      ),
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
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      suffixIcon: emailController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () => setState(() => emailController.clear()),
                              child: const Icon(Icons.close, color: Colors.grey),
                            )
                          : null,
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter email";
                      }
                      return null;
                    },
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
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Password";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // FORGOT PASSWORD
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "I forgot my password",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
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
                        "Don't have account? Let's create!",
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
                      onTap: isLoading ? null : _loginUser,
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: isLoading
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
