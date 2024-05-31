import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:e_badean/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            token TEXT,
            role TEXT,  -- Tambahkan kolom role di sini
            nama_lengkap TEXT,
            username TEXT,
            no_hp TEXT,
            alamat TEXT,
            jenis_kelamin TEXT,
            tanggal_lahir TEXT,
            kebangsaan TEXT,
            pekerjaan TEXT,
            status_nikah TEXT,
            nik TEXT,
            foto_profil TEXT
          )
        ''');
        },
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  static Future<void> saveUser(User user, String token) async {
    final db = await database;
    await db.insert(
      'user',
      {
        'id': user.id, // Pastikan id disimpan sebagai int
        'email': user.email,
        'role': user.role,
        'token': token,
        // tambahkan kolom lainnya sesuai kebutuhan
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
        // Pastikan 'id' diambil sebagai int
        int userId = maps.first['id'] as int;
        return User.fromJson({
          'id': userId,
          'email': maps.first['email'],
          'role': maps.first['role'],
          'penduduk': maps.first,
        });
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
        where: 'token = ?',
        whereArgs: [token],
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

  static Future<bool> isNotificationShown(String notificationId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(notificationId) ?? false;
    } catch (e) {
      print('Error checking if notification is shown: $e');
      return false;
    }
  }

  static Future<void> saveToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } catch (error) {
      print("Error saving token: $error");
      rethrow;
    }
  }

  static Future<void> savePendudukData(
      Map<String, dynamic> pendudukData, String token) async {
    try {
      final db = await database;
      await db.insert(
        'penduduk',
        pendudukData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      print("Error saving penduduk data: $error");
      rethrow;
    }
  }
}
