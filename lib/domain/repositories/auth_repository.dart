import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> signUp(UserEntity user);
  Future<bool> login(String email, String password, {bool rememberMe = true});
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity?> getUserByEmail(String email);
  Future<void> updatePassword(String email, String newPassword);
}
