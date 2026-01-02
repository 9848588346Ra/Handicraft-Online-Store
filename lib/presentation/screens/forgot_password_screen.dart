import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../theme/theme_data.dart';

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
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    isEmailVerified ? "Reset Password" : "Forgot Password",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: HandicraftColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEmailVerified
                        ? "Enter your new password below."
                        : "Enter your email address and we'll help you reset your password.",
                    style: TextStyle(
                      fontSize: 14,
                      color: HandicraftColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (!isEmailVerified) ...[
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
                      enabled: !isEmailVerified,
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
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _verifyEmail,
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
                                "Verify Email",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
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
                              letterSpacing: 1.2,
                              fontSize: 13,
                              color: HandicraftColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // NEW PASSWORD INPUT
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: !showPassword,
                            style: const TextStyle(
                              color: HandicraftColors.textPrimary,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter new password",
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
                                return "Enter new password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // CONFIRM PASSWORD LABEL
                          const Text(
                            "CONFIRM PASSWORD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontSize: 13,
                              color: HandicraftColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // CONFIRM PASSWORD INPUT
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: !showConfirmPassword,
                            style: const TextStyle(
                              color: HandicraftColors.textPrimary,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: "Confirm new password",
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
                                  showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: HandicraftColors.textSecondary,
                                  size: 22,
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
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLoading
                                    ? HandicraftColors.secondary.withOpacity(0.6)
                                    : HandicraftColors.secondary,
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
                                      "Reset Password",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
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
