import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Face Lock uses your device's built-in face unlock (camera + tablet face lock).
/// When you enable or login, the system opens the camera and verifies against
/// the face you enrolled on your device.
class BiometricAuthService {
  BiometricAuthService._();
  static final BiometricAuthService _instance = BiometricAuthService._();
  static BiometricAuthService get instance => _instance;

  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _faceLockEnabledKey = 'face_lock_enabled';
  static const String _sessionBackupKey = 'session_backup';
  static const String _pinKey = 'face_lock_pin';

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return false;
      final available = await _localAuth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isFaceLockEnabled() async {
    try {
      final value = await _secureStorage.read(key: _faceLockEnabledKey);
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  /// Triggers device camera + face unlock. Returns true if face matches tablet face lock.
  /// Uses biometricOnly: false for better compatibility with Huawei and other devices
  /// where face unlock may not be exposed as a standalone biometric.
  Future<bool> verifyWithDeviceFaceLock({required String reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          sensitiveTransaction: false,
          useErrorDialogs: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  /// Enable Face Lock: verify with device face lock, then store session.
  Future<bool> enableFaceLock({
    required String userEmail,
    required String userName,
  }) async {
    try {
      final authenticated = await verifyWithDeviceFaceLock(
        reason: 'Verify your face to enable Face Lock',
      );
      if (!authenticated) return false;

      await _secureStorage.write(key: _faceLockEnabledKey, value: 'true');
      await _secureStorage.write(key: _sessionBackupKey, value: '$userEmail|$userName');
      await _secureStorage.delete(key: _pinKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Enable Face Lock with PIN (fallback when device face unlock doesn't work).
  Future<bool> enableFaceLockWithPin({
    required String userEmail,
    required String userName,
    required String pin,
  }) async {
    if (pin.length < 4 || pin.length > 6) return false;
    try {
      await _secureStorage.write(key: _faceLockEnabledKey, value: 'true');
      await _secureStorage.write(key: _sessionBackupKey, value: '$userEmail|$userName');
      await _secureStorage.write(key: _pinKey, value: pin);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasPinFallback() async {
    try {
      final pin = await _secureStorage.read(key: _pinKey);
      return pin != null && pin.length >= 4;
    } catch (_) {
      return false;
    }
  }

  Future<void> disableFaceLock() async {
    try {
      await _secureStorage.delete(key: _faceLockEnabledKey);
      await _secureStorage.delete(key: _sessionBackupKey);
      await _secureStorage.delete(key: _pinKey);
    } catch (_) {}
  }

  /// Login: verify with device face lock or PIN, then return stored session.
  Future<({String email, String name})?> authenticateAndRestoreSession({String? pinInput}) async {
    try {
      final enabled = await isFaceLockEnabled();
      if (!enabled) return null;

      bool authenticated = false;
      if (pinInput != null && pinInput.length >= 4) {
        final storedPin = await _secureStorage.read(key: _pinKey);
        authenticated = storedPin == pinInput;
      }
      if (!authenticated) {
        authenticated = await verifyWithDeviceFaceLock(
          reason: 'Sign in with Face Lock',
        );
      }
      if (!authenticated) return null;

      final backup = await _secureStorage.read(key: _sessionBackupKey);
      if (backup == null || !backup.contains('|')) return null;

      final parts = backup.split('|');
      if (parts.length < 2) return null;

      return (email: parts[0], name: parts[1]);
    } catch (_) {
      return null;
    }
  }

  Future<String> getBiometricTypeLabel() async {
    try {
      final list = await _localAuth.getAvailableBiometrics();
      if (list.any((b) => b == BiometricType.face)) return 'Face';
      if (list.any((b) => b == BiometricType.fingerprint)) return 'Fingerprint';
      return 'Biometric';
    } catch (_) {
      return 'Biometric';
    }
  }
}
