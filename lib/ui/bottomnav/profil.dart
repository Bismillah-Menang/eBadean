import 'dart:io';
import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';
import 'package:e_badean/ui/detail/editprofil.dart';
import 'package:e_badean/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_badean/ip.dart'; // Pastikan ini mengimpor konfigurasi IP Anda
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<Profil> {
  User? _user;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _refreshProfileData();
  }

  void _refreshProfileData() async {
    User? user = await _getUserFromLocal();
    if (user != null) {
      setState(() {
        _user = user;
        // Jika ada path foto profil dari file lokal, gunakan File
        // if (_user!.foto_profil != null &&
        //     _user!.foto_profil!.startsWith('profile_images')) {
        //   _imageFile = File(_user!.foto_profil!);
        // }
        // // Jika ada path foto profil dari URL, gunakan CachedNetworkImage
        // else if (_user!.foto_profil != null &&
        //     _user!.foto_profil!.startsWith('http')) {
        //   _imageFile =
        //       null; // Kosongkan _imageFile agar CachedNetworkImage dapat digunakan
        // }
        // // Jika tidak ada path foto profil
        // else {
        //   _imageFile = null;
        // }
      });
    }
  }

  Future<User?> _getUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      return DBHelper.getUserFromLocal(token);
    } else {
      return null;
    }
  }

  Future<void> _saveImageToLocalStorage(String imagePath) async {
    try {
      if (imagePath.isNotEmpty) {
        // Simpan foto profil ke penyimpanan lokal (SQLite)
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        if (token != null) {
          await DBHelper.updateUserPhoto(
              imagePath, token); 
        }

        // Upload foto profil ke server
        final Uri url =
            Uri.parse(ApiConfig.baseUrl + '/api/update-profile-photo');

        var request = http.MultipartRequest('POST', url);

        // Menambahkan file gambar ke permintaan
        var mimeTypeData =
            lookupMimeType(imagePath, headerBytes: [0xFF, 0xD8])?.split('/');
        var file = await http.MultipartFile.fromPath(
          'image',
          imagePath,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
        );
        request.files.add(file);

        // Menambahkan ID pengguna ke permintaan
        request.fields['user_id'] = _user!.id.toString();

        var response = await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Foto profil berhasil disimpan")),
          );
        } else {
          // Jika permintaan gagal
          throw Exception(
              'Gagal mengunggah foto profil: ${response.reasonPhrase}');
        }
      } else {
        print('No image selected.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tidak ada gambar yang dipilih")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  Future<void> _getImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);

          _saveImageToLocalStorage(_imageFile!.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat memilih gambar")),
      );
    }
  }

  void _logout() async {
    try {
      // Simpan path foto profil sebelum logout
      // if (_user != null && _user!.foto_profil != null) {
      //   await _saveImageToLocalStorage(_user!.foto_profil!);
      // }

      // Hapus token dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      // Navigasi ke halaman login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat logout")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 50.0,
            horizontal: 35.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 40.0),
                    // CircleAvatar(
                    //   radius: 75.0,
                    //   child: ClipOval(
                    //     child: _imageFile != null
                    //         ? Image.file(_imageFile!,
                    //             fit: BoxFit.cover, width: 150, height: 150)
                    //         : _user?.foto_profil != null
                    //             ? CachedNetworkImage(
                    //                 imageUrl:
                    //                     '${ApiConfig.baseUrl}/${_user!.foto_profil!}',
                    //                 placeholder: (context, url) =>
                    //                     CircularProgressIndicator(),
                    //                 errorWidget: (context, url, error) =>
                    //                     Icon(Icons.error),
                    //                 fit: BoxFit.cover,
                    //                 width: 150,
                    //                 height: 150,
                    //               )
                    //             : Container(
                    //                 color: Colors
                    //                     .grey, // Warna latar belakang yang digunakan saat tidak ada gambar profil
                    //                 width: 150,
                    //                 height: 150,
                    //                 child: Center(
                    //                   child: Icon(
                    //                     Icons
                    //                         .account_circle, // Icon default yang digunakan saat tidak ada gambar profil
                    //                     size: 100,
                    //                     color: Colors.white,
                    //                   ),
                    //                 ),
                    //               ),
                    //   ),
                    // ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _getImage,
                      child: Text("Pilih Foto"),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Memanggil _saveImageToLocalStorage dengan menyediakan path gambar
                        _saveImageToLocalStorage(_imageFile?.path ?? "");
                      },
                      child: Text("Simpan Foto"),
                    ),
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );
                        if (result == true) {
                          _refreshProfileData();
                        }
                      },
                      child: Text(
                        "VERIFIKASI DATA",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Color.fromRGBO(29, 216, 163, 80),
                        minimumSize: Size(double.infinity, 0),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      children: [
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     'Fullname: ${_user?.nama_lengkap ?? ''}',
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontFamily: 'Poppins',
                        //     ),
                        //   ),
                        // ),
                        Divider(), // Garis horizontal
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email: ${_user?.email}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Divider(), // Garis horizontal
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     'No Telepon: ${_user?.no_hp ?? ''}',
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontFamily: 'Poppins',
                        //     ),
                        //   ),
                        // ),
                        Divider(),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     'Alamat: ${_user?.alamat ?? ''}',
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontFamily: 'Poppins',
                        //     ),
                        //   ),
                        // ),
                        Divider(), // Garis horizontal
                        SizedBox(height: 30.0),
                        SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: _logout,
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            backgroundColor: Color(0xFFF90606),
                            minimumSize: Size(double.infinity, 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
