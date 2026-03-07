import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _adminKey = 'admin_logged_in';

/// Manages admin login state. Admin credentials: rajkarki123@gmail.com / 123456
class AdminProvider extends ChangeNotifier {
  AdminProvider._() {
    _load();
  }
  static final AdminProvider _instance = AdminProvider._();
  static AdminProvider get instance => _instance;

  bool _isAdminLoggedIn = false;
  bool get isAdminLoggedIn => _isAdminLoggedIn;

  static const String adminEmail = 'rajkarki123@gmail.com';
  static const String adminPassword = '123456';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAdminLoggedIn = prefs.getBool(_adminKey) ?? false;
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> login(String email, String password) async {
    final success = email.trim().toLowerCase() == adminEmail && password == adminPassword;
    if (success) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_adminKey, true);
        _isAdminLoggedIn = true;
        notifyListeners();
        return true;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adminKey, false);
      _isAdminLoggedIn = false;
      notifyListeners();
    } catch (_) {}
  }
}
