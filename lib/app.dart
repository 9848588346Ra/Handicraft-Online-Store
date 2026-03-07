import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/presentation/Screens/dashboard_screen.dart';
import 'package:handicraft_online_store/presentation/Screens/welcome.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: InjectionContainer().isLoggedInUseCase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const DashboardScreen() : const WelcomeScreen();
        },
      ),
    );
  }
}
