import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:e_badean/models/user.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  static Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    try {
      String pathDB = await getDatabasesPath();
      String fullPath = path.join(pathDB, 'kelurahan.db');

      return await openDatabase(
        fullPath,
        version: 1,
        onCreate: (db, version) async {
          // Mendefinisikan skema tabel jika database baru dibuat
          await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_lengkap TEXT,
            username TEXT,
            email TEXT,
            no_hp TEXT,
            alamat TEXT,
            jenis_kelamin TEXT,
            ttl TEXT,
            kebangsaan TEXT,
            pekerjaan TEXT,
            status_nikah TEXT,
            nik TEXT,
          )
        ''');
        },
      );
    } catch (e) {
      print("Error inisialisasi database: $e");
      rethrow;
    }
  }

  static Future<void> saveUser(User user, String token) async {
    final db = await database;
    await db.insert(
      'user',
      {
        ...user.toJson(),
        'token': token,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<User?> getUserFromLocal(String token) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'user',
        where: 'token = ?',
        whereArgs: [token],
      );

      if (maps.isNotEmpty) {
        return User.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching user from local database: $error");
      return null;
    }
  }

 static Future<void> updateUser(User updatedUser, String token) async {
    try {
      final db = await database;
      await db.update(
        'user',
        updatedUser.toJson(),
        where:
            'id = ?', 
        whereArgs: [updatedUser.id], 
      );
    } catch (error) {
      print("Error updating user: $error");
      rethrow; 
    }
  }
}
