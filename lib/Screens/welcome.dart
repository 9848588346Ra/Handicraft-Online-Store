import 'package:flutter/material.dart';
import 'package:mitho_bakery/Screens/login_screens.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF5E35B1); 
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
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // The key change is here: Use Navigator.push to move to the new screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailLoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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