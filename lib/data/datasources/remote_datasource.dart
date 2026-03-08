import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:handicraft_online_store/core/config/api_config.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

class RemoteDataSource {
  static String get _baseUrl =>
      kIsWeb ? 'http://localhost:3000/api' : ApiConfig.baseUrl;

  final Dio _dio;

  RemoteDataSource() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: Duration(seconds: ApiConfig.connectTimeoutSeconds),
    receiveTimeout: Duration(seconds: ApiConfig.receiveTimeoutSeconds),
  ));

  Future<void> signUp(UserEntity user) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'name': user.name,
          'email': user.email,
          'password': user.password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.data['message'] ?? 'Signup failed');
      }
    } on DioException catch (e) {
      String msg = e.response?.data['message']?.toString() ?? e.message ?? 'Signup failed';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        msg = 'Cannot reach server. Ensure backend is running and tablet is on same WiFi as computer.';
      }
      throw Exception(msg);
    }
  }

  /// Returns Map with 'token' and optionally 'user' (id, name, email)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          'token': data['token'] as String? ?? '',
          'user': data['user'] as Map<String, dynamic>?,
        };
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      String msg = e.response?.data['message']?.toString() ?? e.message ?? 'Login failed';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        msg = 'Cannot reach server. Ensure backend is running and tablet is on same WiFi as computer.';
      }
      throw Exception(msg);
    }
  }

  // Add other methods like getUserProfile if API supports it
  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await _dio.get(
        '/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
