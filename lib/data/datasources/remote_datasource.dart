import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

class RemoteDataSource {
  static const String _androidBaseUrl = 'http://10.0.2.2:3000/api';
  static const String _webBaseUrl = 'http://localhost:3000/api';

  static String get _baseUrl {
    if (kIsWeb) {
      return _webBaseUrl;
    } else {
      // For Android Emulator (default for mobile in this setup)
      return _androidBaseUrl;
    }
  }
  
  final Dio _dio;

  RemoteDataSource() : _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  Future<void> signUp(UserEntity user) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': user.name,
        'email': user.email,
        'password': user.password,
      });
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.data['message'] ?? 'Signup failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'] ?? '';
        final user = response.data['user'];
        return {'token': token, 'user': user};
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  // Add other methods like getUserProfile if API supports it
  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await _dio.get('/profile', 
        options: Options(headers: {'Authorization': 'Bearer $token'})
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
       throw Exception('Failed to get user profile');
    }
  }
}
