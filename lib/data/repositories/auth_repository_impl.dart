import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<void> signUp(UserEntity user) async {
    // API Call
    await remoteDataSource.signUp(user);
    
    // Optional: Save user details locally if needed
    // final userModel = UserModel.fromEntity(user);
    // await localDataSource.saveUser(userModel);
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      final token = result['token'] as String? ?? '';
      
      if (token.isNotEmpty) {
        await localDataSource.setLoggedIn(true);
        // Use user from API if available, else create from email
        final userData = result['user'] as Map<String, dynamic>?;
        final name = userData?['name'] as String? ?? email.split('@').first;
        final userModel = UserModel(name: name, email: email, password: '');
        await localDataSource.saveUser(userModel);
        await localDataSource.setCurrentUser(userModel);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await localDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    // Fetch from Local Storage for now since API might not support get by email without token
    // Or implement remoteDataSource.getUserByEmail if API supports
    final userModel = await localDataSource.getUserByEmail(email);
    return userModel?.toEntity();
  }

  @override
  Future<void> updatePassword(String email, String newPassword) async {
    // This typically requires an authenticated API endpoint
    // For now throwing UnimplementedError specifically for API mode unless we add it to data source
    // await remoteDataSource.updatePassword(email, newPassword);
    throw UnimplementedError('Update password via API not yet implemented');
  }

  @override
  Future<void> restoreSessionFromBiometric(String email, String name) async {
    final userModel = UserModel(name: name, email: email, password: '');
    await localDataSource.saveUser(userModel);
    await localDataSource.setCurrentUser(userModel);
    await localDataSource.setLoggedIn(true);
  }
}
