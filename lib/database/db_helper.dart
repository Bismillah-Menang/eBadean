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
          await db.execute('''
        CREATE TABLE user (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT,
          token TEXT
        )
      ''');
        },
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

          // no_hp TEXT,
          // alamat TEXT,
          // jenis_kelamin TEXT,
          // tanggal_lahir TEXT,
          // kebangsaan TEXT,
          // pekerjaan TEXT,
          // status_nikah TEXT,
          // nik TEXT,
          // token TEXT,
          // foto_profil TEXT

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
        // Ambil nilai foto_profil dari baris data yang ditemukan
        // final fotoProfil = maps.first['foto_profil'];
        // // Kemudian buat objek User dengan nilai foto_profil yang diambil
        final user = User.fromJson(maps.first);
        // user.foto_profil = fotoProfil; // Set nilai foto_profil
        return user;
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
        where: 'id = ?',
        whereArgs: [updatedUser.id],
      );
    } catch (error) {
      print("Error updating user: $error");
      rethrow;
    }
  }

  static Future<void> updateUserPhoto(String photoPath, String token) async {
    try {
      final db = await database;
      int count = await db.update(
        'user',
        {'foto_profil': photoPath},
        where: 'token = ?',
        whereArgs: [token],
      );
      if (count > 0) {
        print("Foto profil diperbarui di database");
      } else {
        print("Gagal memperbarui foto profil di database");
      }
    } catch (error) {
      print("Error updating user photo: $error");
      rethrow;
    }
  }
}
