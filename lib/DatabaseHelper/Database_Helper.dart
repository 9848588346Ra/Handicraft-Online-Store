// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;
//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String dbPath = await getDatabasesPath();
//     String path = join(dbPath, 'my_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE users (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         surname TEXT NOT NULL,
//         birthdate TEXT,
//         userId TEXT UNIQUE NOT NULL,
//         password TEXT NOT NULL
//       )
//     ''');

//   }


//   Future<int> insertUser(String name, String surname, String birthdate,
//       String userId, String password) async {
//     final db = await database;
//     final userMap = {
//       'name': name,
//       'surname': surname,
//       'birthdate': birthdate,
//       'userId': userId,
//       'password': password,
//     };
//     return await db.insert(
//       'users',
//       userMap,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<Map<String, dynamic>>> getUsers() async {
//     final db = await database;
//     return await db.query('users');
//   }
// }