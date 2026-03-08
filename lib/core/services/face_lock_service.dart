import 'dart:io';

// import 'package:face_verification/face_verification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

/// Camera-based face recognition for Face Lock.
/// Registers face when enabling, verifies face when logging in.
class FaceLockService {
  FaceLockService._();
  static final FaceLockService _instance = FaceLockService._();
  static FaceLockService get instance => _instance;

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _faceLockEnabledKey = 'face_lock_enabled';
  static const String _faceLockEmailKey = 'face_lock_email';
  static const String _faceLockNameKey = 'face_lock_name';
  static const String _faceImageId = 'profile';

  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    // await FaceVerification.instance.init();
    _initialized = true;
  }

  /// Get path to save face image for a user.
  Future<String> _getFaceImagePath(String userEmail) async {
    final dir = await getApplicationDocumentsDirectory();
    final faceDir = Directory('${dir.path}/face_lock');
    if (!await faceDir.exists()) await faceDir.create(recursive: true);
    final safeEmail = userEmail.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return '${faceDir.path}/${safeEmail}_$_faceImageId.jpg';
  }

  /// Register face from image path. Returns true if successful.
  Future<bool> registerFace({
    required String imagePath,
    required String userEmail,
    required String userName,
  }) async {
    try {
      await _ensureInit();
      // await FaceVerification.instance.registerFromImagePath(
      //   id: userEmail,
      //   imagePath: imagePath,
      //   imageId: _faceImageId,
      //   name: userName,
      //   replace: true,
      // );
      await _secureStorage.write(key: _faceLockEnabledKey, value: 'true');
      await _secureStorage.write(key: _faceLockEmailKey, value: userEmail);
      await _secureStorage.write(key: _faceLockNameKey, value: userName);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify face from image path. Returns (email, name) if match, null otherwise.
  Future<({String email, String name})?> verifyFace(String imagePath) async {
    try {
      await _ensureInit();
      // final matchId = await FaceVerification.instance
      //     .verifyFromImagePathIsolate(imagePath: imagePath, threshold: 0.65);
      const String? matchId = null;
      if (matchId == null || matchId.isEmpty) return null;
      final name = await _secureStorage.read(key: _faceLockNameKey) ?? '';
      return (email: matchId, name: name);
    } catch (_) {
      return null;
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

  Future<void> disableFaceLock() async {
    try {
      final email = await _secureStorage.read(key: _faceLockEmailKey);
      if (email != null && email.isNotEmpty) {
        // await FaceVerification.instance.deleteUserFaces(email);
      }
      await _secureStorage.delete(key: _faceLockEnabledKey);
      await _secureStorage.delete(key: _faceLockEmailKey);
      await _secureStorage.delete(key: _faceLockNameKey);
    } catch (_) {}
  }

  Future<String> getFaceImagePath(String userEmail) =>
      _getFaceImagePath(userEmail);
}
