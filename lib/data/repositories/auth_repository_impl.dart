import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/user_model.dart';
import '../datasources/remote_datasource.dart';

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
  Future<bool> login(String email, String password, {bool rememberMe = true}) async {
    try {
      final result = await remoteDataSource.login(email, password);
      final token = result['token']?.toString() ?? '';
      
      if (token.isNotEmpty) {
        if (rememberMe) {
          await localDataSource.setLoggedIn(true);
          final userData = result['user'];
          if (userData != null && userData is Map) {
            final userModel = UserModel.fromJson(Map<String, dynamic>.from(userData));
            await localDataSource.setCurrentUser(userModel);
          }
        } else {
          await localDataSource.setLoggedIn(false);
        }
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
}
