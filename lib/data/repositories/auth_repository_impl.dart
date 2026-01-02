import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<void> signUp(UserEntity user) async {
    // Check if user already exists
    final existingUser = await dataSource.getUserByEmail(user.email);
    if (existingUser != null) {
      throw Exception('User with this email already exists');
    }

    final userModel = UserModel.fromEntity(user);
    await dataSource.saveUser(userModel);
  }

  @override
  Future<bool> login(String email, String password) async {
    final user = await dataSource.getUserByEmail(email);
    
    if (user == null) {
      return false;
    }

    if (user.password != password) {
      return false;
    }

    // Set current user and logged in status
    await dataSource.setCurrentUser(user);
    await dataSource.setLoggedIn(true);
    
    return true;
  }

  @override
  Future<bool> isLoggedIn() async {
    return await dataSource.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await dataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    final userModel = await dataSource.getUserByEmail(email);
    return userModel?.toEntity();
  }

  @override
  Future<void> updatePassword(String email, String newPassword) async {
    final userModel = await dataSource.getUserByEmail(email);
    if (userModel == null) {
      throw Exception('User not found');
    }

    // Create updated user with new password
    final updatedUser = UserModel(
      name: userModel.name,
      email: userModel.email,
      password: newPassword,
    );

    // Save updated user
    await dataSource.saveUser(updatedUser);
  }
}
