import 'dart:async';

import 'package:ambient_light/ambient_light.dart';
import 'package:flutter/foundation.dart';
import 'package:screen_brightness/screen_brightness.dart';

// Only use on mobile - light sensor not available on web/desktop
bool get _isMobilePlatform =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// Adjusts screen brightness based on ambient light.
/// Dark place → lower brightness, bright place → full brightness.
class AutoBrightnessService {
  AutoBrightnessService._();
  static final AutoBrightnessService _instance = AutoBrightnessService._();
  static AutoBrightnessService get instance => _instance;

  StreamSubscription<double>? _lightSubscription;
  bool _isActive = false;
  DateTime? _lastUpdate;
  static const Duration _updateThrottle = Duration(milliseconds: 250);
  double _lastBrightness = -1;
  final bool _useSystemBrightness = true;

  /// Lux thresholds for brightness mapping.
  static const double _luxVeryDark = 20;
  static const double _luxDark = 80;
  static const double _luxMedium = 400;
  static const double _luxBright = 800;

  static const double _brightnessMin = 0.15;
  static const double _brightnessMax = 1.0;

  bool get isActive => _isActive;

  /// Start listening to ambient light and adjusting brightness.
  Future<void> start() async {
    if (_isActive) return;
    if (!_isMobilePlatform) return;
    _tryStartSensor();
    // Retry after delay - some devices need time for sensor to initialize
    Future.delayed(const Duration(seconds: 2), () {
      if (!_isActive) _tryStartSensor();
    });
  }

  Future<void> _tryStartSensor() async {
    if (_isActive) return;
    try {
      final ambientLight = AmbientLight();
      _lightSubscription = ambientLight.ambientLightStream.listen(
        _onLightLevelChanged,
        onError: (_) {},
        cancelOnError: false,
      );
      _isActive = true;
      final initial = await ambientLight.currentAmbientLight();
      if (initial != null) _onLightLevelChanged(initial);
    } catch (_) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AutoBrightness: Light sensor not available on this device');
      }
    }
  }

  void _onLightLevelChanged(double lux) {
    final now = DateTime.now();
    if (_lastUpdate != null && now.difference(_lastUpdate!) < _updateThrottle) {
      return;
    }
    _lastUpdate = now;

    final brightness = _luxToBrightness(lux);
    if ((brightness - _lastBrightness).abs() < 0.03) return;
    _lastBrightness = brightness;

    _setBrightness(brightness);
  }

  double _luxToBrightness(double lux) {
    if (lux <= _luxVeryDark) return _brightnessMin;
    if (lux >= _luxBright) return _brightnessMax;
    if (lux <= _luxDark) {
      return _brightnessMin +
          (lux - _luxVeryDark) / (_luxDark - _luxVeryDark) * 0.25;
    }
    if (lux <= _luxMedium) {
      return 0.4 + (lux - _luxDark) / (_luxMedium - _luxDark) * 0.35;
    }
    return 0.75 + (lux - _luxMedium) / (_luxBright - _luxMedium) * 0.25;
  }

  Future<void> _setBrightness(double brightness) async {
    final b = brightness.clamp(0.0, 1.0);
    try {
      if (_useSystemBrightness) {
        final canChange =
            await ScreenBrightness.instance.canChangeSystemBrightness;
        if (canChange) {
          await ScreenBrightness.instance.setSystemScreenBrightness(b);
          return;
        }
      }
      await ScreenBrightness.instance.setApplicationScreenBrightness(b);
    } catch (_) {}
  }

  /// Manual: set low brightness (for dark environments).
  Future<void> setLowBrightness() async {
    await _setBrightness(_brightnessMin);
  }

  /// Manual: set full brightness.
  Future<void> setFullBrightness() async {
    await _setBrightness(_brightnessMax);
  }

  /// Reset to system default.
  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness.instance.resetApplicationScreenBrightness();
    } catch (_) {}
  }

  /// Stop auto brightness and restore default.
  Future<void> stop() async {
    if (!_isActive) return;
    await _lightSubscription?.cancel();
    _lightSubscription = null;
    _isActive = false;
    try {
      await ScreenBrightness.instance.resetApplicationScreenBrightness();
    } catch (_) {}
  }
}
