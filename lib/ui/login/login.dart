import 'dart:convert';
import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_badean/ip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_badean/ui/detail/editprofil.dart';

class Login extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    String url = "${ApiConfig.baseUrl}/api/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );

      print("Response: ${response.body}");

      if (response.body != null) {
        final responseData = json.decode(response.body);

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200 &&
            responseData['status'] == true &&
            responseData['token'] != null) {
          print("Token berhasil didapatkan: ${responseData['token']}");
          String token = responseData['token'];

          await DBHelper.saveToken(token);

          if (responseData['penduduk'] != null) {
            final pendudukData = responseData['penduduk'];
            await DBHelper.savePendudukData(pendudukData, token);
          }

          User? loggedInUser = await getUserFromToken(responseData['token']);

          if (loggedInUser != null) {
            await DBHelper.saveUser(loggedInUser, token);
            await _saveToken(token);
            if (loggedInUser != null && _isUserProfileComplete(loggedInUser)) {
              _showSuccessDialog2(
                  "Anda berhasil login.", loggedInUser, responseData['token']);
            } else {
              _showSuccessDialog(
                  "Anda berhasil login.", loggedInUser, responseData['token']);
            }
          } else {
            _showErrorDialog("Gagal mendapatkan data pengguna atau penduduk.");
          }
          _printAllUsersFromSQLite();
        } else {
          _handleLoginError(responseData, response.statusCode);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog("Response body is null.");
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Terjadi kesalahan. Silakan coba lagi.");
    }
  }

  Future<void> _printAllUsersFromSQLite() async {
    final allUsers = await DBHelper.getAllUsers();
    print("All users from SQLite:");
    allUsers.forEach((user) {
      print(user);
    });
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<User?> getUserFromToken(String token) async {
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
            User user = User.fromJson(userData);
            return user;
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

  bool _isUserProfileComplete(User user) {
    return user.penduduk != null &&
        user.penduduk!.namaLengkap!.isNotEmpty &&
        user.email.isNotEmpty &&
        user.penduduk!.noHp!.isNotEmpty &&
        user.penduduk!.alamat!.isNotEmpty &&
        user.penduduk!.tempatLahir!.isNotEmpty &&
        user.penduduk!.tanggalLahir!.isNotEmpty &&
        user.penduduk!.kebangsaan!.isNotEmpty &&
        user.penduduk!.pekerjaan!.isNotEmpty &&
        user.penduduk!.agama!.isNotEmpty &&
        user.penduduk!.nik!.isNotEmpty &&
        user.penduduk!.jenisKelamin != null &&
        user.penduduk!.fotoKk != null &&
        user.penduduk!.fotoKtp != null;
  }

  void _handleLoginError(dynamic responseData, int statusCode) {
    if (statusCode == 401) {
      if (responseData['status'] == false) {
        if (responseData['message'] == "validation error") {
          var errors = responseData['errors'];
          if (errors != null) {
            errors.forEach((key, value) {
              _showErrorDialog(value[0]);
            });
          }
        } else if (responseData['message'] ==
            "Email & Password does not match with our record.") {
          _showErrorDialog("Email dan password tidak sesuai!");
        }
      }
    } else {
      print("HTTP Error $statusCode: ${responseData['message']}");
    }
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Login Gagal',
      titleTextStyle: TextStyle(
          fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
      desc: message,
      descTextStyle: TextStyle(fontFamily: 'Poppins'),
      btnOkText: 'OK',
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    )..show();
  }

  void _showSuccessDialog(String message, User user, String token) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Login Berhasil',
      titleTextStyle: TextStyle(
          fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
      desc: message,
      descTextStyle: TextStyle(fontFamily: 'Poppins'),
      btnOkText: 'OK',
      btnOkOnPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfilePage(),
          ),
        );
      },
    )..show();
  }

  void _showSuccessDialog2(String message, User user, String token) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Login Berhasil',
      titleTextStyle: TextStyle(
          fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
      desc: message,
      descTextStyle: TextStyle(fontFamily: 'Poppins'),
      btnOkText: 'OK',
      btnOkOnPress: () {
        Navigator.pushNamed(context, '/bottomnav');
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 130.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Image.asset('assets/images/badean_splash.png',
                            width: 255.0, height: 55.0),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      'Selamat datang di E-Badean',
                      style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Nikmati akses pelayanan surat dalam satu genggaman :)',
                      style: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Color(0xFF1548AD),
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 14.0),
                            prefixIcon: Icon(Icons.mail),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0xFF1548AD),
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            RegExp regex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!regex.hasMatch(value)) {
                              return 'Format email tidak valid';
                            }
                            return null; // Jika valid
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: passwordController,
                          cursorColor: Color(0xFF1548AD),
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: _isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 14.0),
                            prefixIcon: Icon(Icons.key),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0xFF1548AD),
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value.length < 8) {
                              return 'Password harus terdiri dari setidaknya 8 karakter';
                            }
                            return null; // Jika valid
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/lupas');
                          },
                          child: Text(
                            'Lupa Password ?',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF1548AD),
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text(
                          "Masuk",
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
                          backgroundColor: Color(0xFF1548AD),
                          minimumSize: Size(double.infinity, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 20.0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 310.0,
                child: Divider(),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun?",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/daftar');
                    },
                    child: Text(
                      "Daftar di sini",
                      style: TextStyle(
                        color: Color(0xFF1548AD),
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}