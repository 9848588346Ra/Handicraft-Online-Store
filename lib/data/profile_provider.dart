import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyPrefix = 'user_profile_';

/// Extended profile data (phone, address, profile image) stored per user email.
/// Merged with auth UserEntity (name, email) for display.
class ProfileProvider extends ChangeNotifier {
  ProfileProvider._();
  static final ProfileProvider _instance = ProfileProvider._();
  static ProfileProvider get instance => _instance;

  String? _name;
  String? _phone;
  String? _address;
  String? _profileImagePath;

  String? get name => _name;
  String? get phone => _phone;
  String? get address => _address;
  String? get profileImagePath => _profileImagePath;

  String _storageKey(String email) => '$_keyPrefix${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';

  Future<void> loadForUser(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey(email));
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>?;
        if (map != null) {
          _name = map['name'] as String?;
          _phone = map['phone'] as String?;
          _address = map['address'] as String?;
          _profileImagePath = map['profileImagePath'] as String?;
        }
      } else {
        _name = _phone = _address = _profileImagePath = null;
      }
      notifyListeners();
    } catch (_) {
      _name = _phone = _address = _profileImagePath = null;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String email,
    String? name,
    String? phone,
    String? address,
    String? profileImagePath,
  }) async {
    _name = name ?? _name;
    _phone = phone ?? _phone;
    _address = address ?? _address;
    if (profileImagePath != null) _profileImagePath = profileImagePath;
    notifyListeners();
    await _save(email);
  }

  Future<void> _save(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey(email),
        jsonEncode({
          'name': _name,
          'phone': _phone,
          'address': _address,
          'profileImagePath': _profileImagePath,
        }),
      );
    } catch (_) {}
  }

  void clear() {
    _name = _phone = _address = _profileImagePath = null;
    notifyListeners();
  }
}
