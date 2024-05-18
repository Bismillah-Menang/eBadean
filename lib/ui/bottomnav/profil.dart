import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';
import 'package:e_badean/ui/detail/editprofil.dart';
import 'package:e_badean/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<Profil> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _refreshProfileData();
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
                    FutureBuilder<User?>(
                      future: _getUserFromLocal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            if (snapshot.hasData && snapshot.data != null) {
                              User user = snapshot.data!;
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 75.0,
                                    backgroundImage: NetworkImage(
                                      'https://miro.medium.com/v2/resize:fit:786/format:webp/1*DLJ3UGHPWDtrzfcMTYjfZw.jpeg',
                                    ),
                                  ),
                                  SizedBox(height: 40.0),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfilePage(),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      backgroundColor:
                                          Color.fromRGBO(29, 216, 163, 80),
                                      minimumSize: Size(double.infinity, 0),
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Fullname: ${user.nama_lengkap}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      Divider(), // Garis horizontal
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Email: ${user.email}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      Divider(), // Garis horizontal
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'No Telepon: ${user.no_hp}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      Divider(), 
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Alamat: ${user.alamat}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      Divider(), // Garis horizontal
                                    ],
                                  ),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      backgroundColor: Color(0xFFF90606),
                                      minimumSize: Size(double.infinity, 0),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Text(
                                'Data pengguna tidak ditemukan.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              );
                            }
                          }
                        }
                      },
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

  void _refreshProfileData() async {
    User? user = await _getUserFromLocal();
    if (user != null) {
      setState(() {
        _user = user;
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

  void _logout() async {
    // Hapus token dari penyimpanan lokal
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    await prefs.remove('registered_email');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
  }
}
