import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';
import 'package:e_badean/ui/detail/editprofil.dart';
import 'package:e_badean/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_badean/ip.dart';
import 'package:http/http.dart' as http;

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
    _populateUserData();
  }

  Future<void> _populateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        User? user = await getUserFromToken(token);

        if (user != null) {
          setState(() {
            _user = user;
          });
        }
      } catch (error) {
        print("Error retrieving user data: $error");
      }
    } else {
      print("Token not found");
    }
  }

  Future<User?> getUserFromToken(String token) async {
    try {
      String url = "${ApiConfig.baseUrl}/api/get_user";

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print("Response getUserFromToken: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final userData = responseData['user'];
          if (userData != null) {
            return User.fromJson(userData);
          }
        } else {
          print("Failed to get user data: ${responseData['message']}");
          return null;
        }
      } else {
        print("Failed to get user data: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error getting user data: $error");
      return null;
    }
  }

  Future<void> _getImage() async {
    try {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Pilih dari Galeri'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromSource(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Ambil Foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromSource(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat memilih gambar")),
      );
    }
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
          _uploadImage();
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

  ImageProvider<Object>? _getImageProvider() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (_user?.penduduk?.fotoProfil != null &&
        _user!.penduduk!.fotoProfil!.isNotEmpty) {
      return NetworkImage(_user!.penduduk!.fotoProfil!);
    } else {
      return null;
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tidak ada gambar yang dipilih")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String url = "${ApiConfig.baseUrl}/api/upload_profil";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = 'Bearer $token';

    var mimeTypeData = lookupMimeType(_imageFile!.path)!.split('/');
    var fileStream = http.ByteStream(_imageFile!.openRead());
    var length = await _imageFile!.length();

    var fileName = _imageFile!.path.split('/').last;

    var multipartFile = http.MultipartFile(
      'foto_profil',
      fileStream,
      length,
      filename: fileName,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );

    request.files.add(multipartFile);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Foto profil anda berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui foto profil")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Terjadi kesalahan saat mengunggah gambar profil")),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    await DBHelper.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 90.0,
            right: 25.0,
            left: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Color(0xFFEBF0FF),
                            backgroundImage: _getImageProvider(),
                            child: _imageFile == null &&
                                    (_user?.penduduk?.fotoProfil == null ||
                                        _user!.penduduk!.fotoProfil!.isEmpty)
                                ? Text(
                                    _user?.email.isNotEmpty ?? false
                                        ? _user!.email[0].toUpperCase()
                                        : '',
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0046F8)),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 8,
                            child: GestureDetector(
                              onTap: _getImage,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFF0046F8),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.0),
                    ElevatedButton(
                      onPressed: () async {
                        final bool? isUpdated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );

                        if (isUpdated == true) {
                          _populateUserData();
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Color(0xFF0046F8),
                        minimumSize: Size(double.infinity, 0),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nama Lengkap: ${_user?.penduduk?.namaLengkap ?? ''}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'No Telepon: ${_user?.penduduk?.noHp ?? ''}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Alamat: ${_user?.penduduk?.alamat ?? ''}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Divider(), // Garis horizontal
                        SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.bottomSlide,
                              titleTextStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              title: 'Konfirmasi',
                              desc:
                                  'Apakah Anda yakin ingin keluar dari aplikasi?',
                              descTextStyle: TextStyle(fontFamily: 'Poppins'),
                              btnOkText: 'Ya',
                              btnCancelText: 'Tidak',
                              btnOkOnPress: () {
                                _logout(context);
                              },
                              btnCancelOnPress: () {},
                              btnOkColor: Color.fromRGBO(29, 216, 163, 80),
                              btnCancelColor: Color(0xFFF90606),
                            )..show();
                          },
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0046F8),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            backgroundColor: Color(0xFFEBF0FF),
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
