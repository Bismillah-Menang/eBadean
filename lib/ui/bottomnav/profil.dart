import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatelessWidget {
  const Profil({Key? key});

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
                    Text(
                      "Profil Saya",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                                  SizedBox(height: 30.0),
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

  Future<User?> _getUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      return DBHelper.getUserFromLocal(token);
    } else {
      return null;
    }
  }
}
