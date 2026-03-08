import 'package:flutter/material.dart';
import 'package:handicraft_online_store/app.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/core/services/auto_brightness_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await InjectionContainer().init();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    AutoBrightnessService.instance.start();
  });

  runApp(const App());
}
