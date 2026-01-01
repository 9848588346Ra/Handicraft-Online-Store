import 'package:flutter/material.dart';
import 'package:mitho_bakery/app.dart';
import 'package:mitho_bakery/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection (includes Hive initialization)
  await InjectionContainer().init();
  
  // MaterialApp -> Parent container
  // Scaffold -> Screen structure
  runApp(const App());
}