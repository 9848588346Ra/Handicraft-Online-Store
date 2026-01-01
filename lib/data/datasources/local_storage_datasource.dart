import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class LocalStorageDataSource {
  static const String _usersBoxName = 'users';
  static const String _authBoxName = 'auth';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapter only if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    
    // Open boxes only if not already open
    if (!Hive.isBoxOpen(_usersBoxName)) {
      await Hive.openBox<UserModel>(_usersBoxName);
    }
    
    if (!Hive.isBoxOpen(_authBoxName)) {
      await Hive.openBox(_authBoxName);
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      if (!Hive.isBoxOpen(_usersBoxName)) {
        await Hive.openBox<UserModel>(_usersBoxName);
      }
      final usersBox = Hive.box<UserModel>(_usersBoxName);
      await usersBox.put(user.email, user);
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      if (!Hive.isBoxOpen(_usersBoxName)) {
        await Hive.openBox<UserModel>(_usersBoxName);
      }
      final usersBox = Hive.box<UserModel>(_usersBoxName);
      return usersBox.get(email);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> setCurrentUser(UserModel user) async {
    try {
      if (!Hive.isBoxOpen(_authBoxName)) {
        await Hive.openBox(_authBoxName);
      }
      final authBox = Hive.box(_authBoxName);
      await authBox.put(_currentUserKey, user.toJson());
    } catch (e) {
      print('Error setting current user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      if (!Hive.isBoxOpen(_authBoxName)) {
        await Hive.openBox(_authBoxName);
      }
      final authBox = Hive.box(_authBoxName);
      final userJson = authBox.get(_currentUserKey);
      if (userJson != null) {
        if (userJson is Map) {
          return UserModel.fromJson(Map<String, dynamic>.from(userJson));
        }
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      if (!Hive.isBoxOpen(_authBoxName)) {
        await Hive.openBox(_authBoxName);
      }
      final authBox = Hive.box(_authBoxName);
      await authBox.put(_isLoggedInKey, isLoggedIn);
    } catch (e) {
      print('Error setting logged in: $e');
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      if (!Hive.isBoxOpen(_authBoxName)) {
        await Hive.openBox(_authBoxName);
      }
      final authBox = Hive.box(_authBoxName);
      return authBox.get(_isLoggedInKey, defaultValue: false) as bool;
    } catch (e) {
      print('Error checking logged in: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      if (!Hive.isBoxOpen(_authBoxName)) {
        await Hive.openBox(_authBoxName);
      }
      final authBox = Hive.box(_authBoxName);
      await authBox.delete(_currentUserKey);
      await authBox.put(_isLoggedInKey, false);
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }
}
