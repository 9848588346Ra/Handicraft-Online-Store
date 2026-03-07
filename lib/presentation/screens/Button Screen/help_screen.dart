import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/presentation/screens/login_screen.dart';
import 'package:handicraft_online_store/presentation/screens/signup_screen.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<dynamic> _loadCurrentUser() async {
    try {
      final container = InjectionContainer();
      if (!container.isInitialized) await container.init();
      return await container.getCurrentUserUseCase.call();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final isLoggedIn = user != null && user.email.isNotEmpty;

        if (!isLoggedIn) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F6F8),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  Expanded(child: _buildLoginPrompt(context)),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6F8),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: _primaryPurple.withOpacity(0.1),
              foregroundColor: _primaryPurple,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Help', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87)),
                Text('FAQs & support', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.login, size: 64, color: _primaryPurple.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),
            Text(
              'Login or Sign up',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'Please login or sign up first to access help and support',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryPurple,
                  side: BorderSide(color: _primaryPurple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('How do I place an order?', 'Browse our products, add items to cart, and proceed to checkout. You can sign in for faster checkout and order tracking.'),
          const SizedBox(height: 20),
          _buildSection('How can I track my order?', 'Go to Account > My Orders to view your ongoing and completed orders.'),
          const SizedBox(height: 20),
          _buildSection('How do I update my profile?', 'Go to Account > My Details to update your name, phone, address, and profile picture.'),
          const SizedBox(height: 20),
          _buildSection('Need more help?', 'Contact us at support@handicraftstore.com'),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold', color: Colors.black87)),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4)),
        ],
      ),
    );
  }
}
