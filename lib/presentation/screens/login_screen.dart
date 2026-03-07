import 'package:flutter/material.dart';
import 'package:handicraft_online_store/presentation/Screens/dashboard_screen.dart';
import '../../core/di/injection_container.dart';
import '../../theme/theme_data.dart';
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
  bool rememberMe = false;

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
        rememberMe: rememberMe,
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
                  // Title
                  const SizedBox(height: 20),
                  const Text(
                    "Continue with E-mail",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: HandicraftColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // EMAIL LABEL
                  const Text(
                    "E-MAIL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 13,
                      color: HandicraftColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // EMAIL INPUT
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
                      suffixIcon: emailController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () =>
                                  setState(() => emailController.clear()),
                              child: const Icon(
                                Icons.close,
                                color: HandicraftColors.textSecondary,
                                size: 20,
                              ),
                            )
                          : null,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: HandicraftColors.borderLight,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: HandicraftColors.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
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

                  const SizedBox(height: 32),

                  // PASSWORD LABEL
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

                  // PASSWORD INPUT
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
                        borderSide: BorderSide(
                          color: HandicraftColors.borderLight,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: HandicraftColors.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                      if (value == null || value.isEmpty) {
                        return "Enter Password";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

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
                        color: HandicraftColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // REMEMBER ME
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                          activeColor: HandicraftColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            rememberMe = !rememberMe;
                          });
                        },
                        child: const Text(
                          "Remember me",
                          style: TextStyle(
                            color: HandicraftColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // NEXT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _loginUser,
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
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // CREATE ACCOUNT TEXT BUTTON
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: HandicraftColors.textSecondary,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: HandicraftColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
