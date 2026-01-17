import 'package:mongo_dart/mongo_dart.dart';
import '../models/user_model.dart';

class MongoDataSource {
  static const String _connectionString = 'mongodb://127.0.0.1:27017/handicraft_store';
  static const String _usersCollection = 'users';

  Db? _db;

  Future<void> init() async {
    try {
      _db = await Db.create(_connectionString);
      await _db!.open();
      print('Connected to MongoDB at $_connectionString');
    } catch (e) {
      print('Error connecting to MongoDB: $e');
      rethrow;
    }
  }

  bool get isConnected => _db != null && _db!.isConnected;

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      if (!isConnected) await init();
      
      final collection = _db!.collection(_usersCollection);
      await collection.insert(user.toJson());
    } catch (e) {
      print('Error saving user to MongoDB: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      if (!isConnected) await init();
      
      final collection = _db!.collection(_usersCollection);
      final userMap = await collection.findOne(where.eq('email', email));
      
      if (userMap != null) {
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('Error getting user from MongoDB: $e');
      return null;
    }
  }
}
