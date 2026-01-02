import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _injectionContainer = InjectionContainer();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool isEmailVerified = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String? userEmail;

  Future<void> _verifyEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Ensure container is initialized
      if (!_injectionContainer.isInitialized) {
        await _injectionContainer.init();
      }

      final email = emailController.text.trim();
      final user = await _injectionContainer.getUserByEmailUseCase(email);

      if (mounted) {
        if (user != null) {
          setState(() {
            isEmailVerified = true;
            userEmail = email;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No account found with this email address."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _resetPassword() async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _injectionContainer.updatePasswordUseCase(
        userEmail!,
        newPasswordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password updated successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back to login
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
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
                      if (isEmailVerified) {
                        // Go back to email entry step
                        setState(() {
                          isEmailVerified = false;
                          newPasswordController.clear();
                          confirmPasswordController.clear();
                        });
                      } else {
                        // Go back to login screen
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    isEmailVerified ? "Reset Password" : "Forgot Password",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEmailVerified
                        ? "Enter your new password below."
                        : "Enter your email address and we'll help you reset your password.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (!isEmailVerified) ...[
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
                      enabled: !isEmailVerified,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter email";
                        }
                        if (!value.contains('@')) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    // VERIFY EMAIL BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _verifyEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Verify Email",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],

                  // Password Reset Section
                  if (isEmailVerified) ...[
                    Form(
                      key: _passwordFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // NEW PASSWORD LABEL
                          const Text(
                            "NEW PASSWORD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // NEW PASSWORD INPUT
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              hintText: "Enter new password",
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                                return "Enter new password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          // CONFIRM PASSWORD LABEL
                          const Text(
                            "CONFIRM PASSWORD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // CONFIRM PASSWORD INPUT
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: !showConfirmPassword,
                            decoration: InputDecoration(
                              hintText: "Confirm new password",
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showConfirmPassword = !showConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm password";
                              }
                              if (value != newPasswordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 40),

                          // RESET PASSWORD BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Reset Password",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
