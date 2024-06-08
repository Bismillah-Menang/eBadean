import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'e_badean.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY,
        email TEXT,
        role TEXT,
        token TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE penduduk(
        id INTEGER PRIMARY KEY,
        id_user INTEGER,
        nama_lengkap TEXT,
        no_hp TEXT,
        alamat TEXT,
        tempat_lahir TEXT,
        tanggal_lahir TEXT,
        kebangsaan TEXT,
        pekerjaan TEXT,
        status_nikah TEXT,
        nik TEXT,
        foto_kk TEXT,
        foto_profil TEXT,
        foto_ktp TEXT,
        jenis_kelamin TEXT,
        FOREIGN KEY(id_user) REFERENCES user(id)
      )
    ''');
  }

  static Future<void> saveUser(User user, String token) async {
    final db = await DBHelper.database;
    await db.insert(
      'user',
      {
        'id': user.id,
        'email': user.email,
        'role': user.role,
        'token': token,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (user.penduduk != null) {
      await db.insert(
        'penduduk',
        user.penduduk!.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<User?> getUserFromLocal(String token) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> userMaps = await db.query(
        'user',
        where: 'token = ?',
        whereArgs: [token],
      );

      if (userMaps.isNotEmpty) {
        final userMap = userMaps.first;
        final List<Map<String, dynamic>> pendudukMaps = await db.query(
          'penduduk',
          where: 'id_user = ?',
          whereArgs: [userMap['id']],
        );

        final pendudukData =
            pendudukMaps.isNotEmpty ? pendudukMaps.first : null;

        print('Fetched penduduk: $pendudukData');

        return User.fromJson({
          'id': userMap['id'],
          'email': userMap['email'],
          'role': userMap['role'],
          'penduduk': pendudukData,
        });
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching user from local database: $error");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> user = await db.query('user');
    final List<Map<String, dynamic>> penduduk = await db.query('penduduk');

    final List<Map<String, dynamic>> combinedData = user.map((user) {
      final pendudukData = penduduk.firstWhere(
          (penduduk) => penduduk['id_user'] == user['id'],
          orElse: () => {});
      return {
        ...user,
        'penduduk': pendudukData.isNotEmpty ? pendudukData : null,
      };
    }).toList();

    return combinedData;
  }

  static Future<void> updateUser(User user, String token) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.update(
          'user',
          {
            'email': user.email,
            'role': user.role,
          },
          where: 'token = ?',
          whereArgs: [token],
        );

        if (user.penduduk != null) {
          final Map<String, dynamic> pendudukData = {
            'nama_lengkap': user.penduduk!.namaLengkap,
            'no_hp': user.penduduk!.noHp,
            'alamat': user.penduduk!.alamat,
            'jenis_kelamin': user.penduduk!.jenisKelamin,
            'tempat_lahir': user.penduduk!.tempatLahir,
            'tanggal_lahir': user.penduduk!.tanggalLahir,
            'kebangsaan': user.penduduk!.kebangsaan,
            'pekerjaan': user.penduduk!.pekerjaan,
            'status_nikah': user.penduduk!.statusNikah,
            'nik': user.penduduk!.nik,
          };

          if (user.penduduk!.fotoKk != null) {
            pendudukData['foto_kk'] = user.penduduk!.fotoKk!;
          }

          if (user.penduduk!.fotoKtp != null) {
            pendudukData['foto_ktp'] = user.penduduk!.fotoKtp!;
          }

          await txn.update(
            'penduduk',
            pendudukData,
            where: 'id_user = ?',
            whereArgs: [user.id],
          );
        }
      });
      print("Updated data in DBHelper:");
      print("Email: ${user.email}");
      print("Role: ${user.role}");

      print("Penduduk data:");
      print("Nama Lengkap: ${user.penduduk?.namaLengkap}");
      print("No HP: ${user.penduduk?.noHp}");
      print("User updated successfully");
    } catch (error) {
      print("Error updating user: $error");
      rethrow;
    }
  }

  static Future<void> updateUserPhoto(String photoPath, int idUser) async {
    try {
      final db = await database;
      int count = await db.update(
        'penduduk',
        {'foto_profil': photoPath},
        where: 'id = ?',
        whereArgs: [idUser],
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

  static Future<void> updateUserPhotoKtp(String photoPath, int idUser) async {
    try {
      final db = await database;
      int count = await db.update(
        'penduduk',
        {'foto_ktp': photoPath},
        where: 'id = ?',
        whereArgs: [idUser],
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

  static Future<void> updateUserPhotoKk(String photoPath, int idUser) async {
    try {
      final db = await database;
      int count = await db.update(
        'penduduk',
        {'foto_kk': photoPath},
        where: 'id = ?',
        whereArgs: [idUser],
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
    final db = await database;
    final Map<String, dynamic> pendudukMap = {
      'id': pendudukData['id'],
      'id_user': pendudukData['id_user'],
      'nama_lengkap': pendudukData['nama_lengkap'],
      'no_hp': pendudukData['no_hp'],
      'alamat': pendudukData['alamat'],
      'tempat_lahir': pendudukData['tempat_lahir'],
      'tanggal_lahir': pendudukData['tanggal_lahir'],
      'kebangsaan': pendudukData['kebangsaan'],
      'pekerjaan': pendudukData['pekerjaan'],
      'status_nikah': pendudukData['status_nikah'],
      'nik': pendudukData['nik'],
      'foto_profil': pendudukData['foto_profil'],
      'foto_kk': pendudukData['foto_kk'],
      'jenis_kelamin': pendudukData['jenis_kelamin'],
    };

    await db.insert(
      'penduduk',
      pendudukMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> logout() async {
    final db = await database;
    await db.delete('penduduk');
    await db.delete('user');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
