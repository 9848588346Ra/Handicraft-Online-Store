import 'package:flutter/material.dart';
import 'package:handicraft_online_store/app.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection (includes Hive initialization)
  await InjectionContainer().init();
  
  // MaterialApp -> Parent container
  // Scaffold -> Screen structure
  runApp(const App());
}