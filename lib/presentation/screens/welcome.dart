import 'package:flutter/material.dart';
import 'package:handicraft_online_store/presentation/screens/Dashboard_screen.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // --- Logo and Store Name ---
              Image.asset(
                'assets/images/image 8.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'HANDICRAFT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'open sans bold',
                  color: Colors.black87,
                ),
              ),
              const Text(
                'ONLINE STORE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'open sans bold',
                  color: _primaryPurple,
                ),
              ),
              const SizedBox(height: 50),
              // --- Welcome Heading & Subtitle ---
              const Text(
                'Welcome !!!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'open sans bold',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get your favourites at your doorstep',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 80),
              // --- Get Started Button with Navigation ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'open sans bold',
                      letterSpacing: 0.5,
                    ),
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