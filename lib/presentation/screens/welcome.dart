import 'package:flutter/material.dart';
import 'package:handicraft_online_store/presentation/screens/Dashboard_screen.dart';
import '../../theme/theme_data.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color customRed = Color(0xFFE53935); 

    return Scaffold(
      body: Padding(
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
                color: Colors.black54, 
              ),
            ),
            const Text(
              'ONLINE STORE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: customRed, 
              ),
            ),
            
            const SizedBox(height: 50),

            // --- Welcome Heading & Subtitle ---
            const Text(
              'Welcome !!!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: customRed,
              ),
            ),
            
            const SizedBox(height: 8),

            const Text(
              'Get your favourites at your doorstep',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
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
                  backgroundColor: HandicraftColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
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
    );
  }
}