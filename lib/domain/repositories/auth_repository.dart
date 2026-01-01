import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> signUp(UserEntity user);
  Future<bool> login(String email, String password);
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
