import 'dart:convert';
import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_badean/ip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getEmailSharedPreferences();
  }

  Future<void> _login() async {
    // Panggil validate untuk menjalankan validator
    if (!_formKey.currentState!.validate()) {
      return;
    }

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

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseData['status'] == true &&
          responseData['token'] != null) {
        print("Token berhasil didapatkan: ${responseData['token']}");
        await _saveToken(responseData['token']);

        User? loggedInUser = await getUserFromToken(responseData['token']);

        if (loggedInUser != null) {
          await DBHelper.saveUser(loggedInUser, responseData['token']);
          print(
              "Data pengguna tersimpan di SQLite: Email: ${loggedInUser.email}, Username: ${loggedInUser.username}");
          // Tampilkan dialog sukses
          _showSuccessDialog(
              "Anda berhasil login.", loggedInUser, responseData['token']);
        } else {
          _showErrorDialog("Gagal mendapatkan data pengguna.");
        }
      } else {
        _handleLoginError(responseData, response.statusCode);
      }
    } catch (error) {
      print("Error: $error");
      _showErrorDialog("Terjadi kesalahan. Silakan coba lagi.");
    }
  }

// digunakan untuk mengambil email di dalam sharedpreference
  void _getEmailSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('registered_email');
    if (savedEmail != null) {
      print('Email dari SharedPreferences: $savedEmail');
      setState(() {
        emailController.text = savedEmail;
      });
    }
  }

  void setEmailControllerText(String email) {
    setState(() {
      emailController.text = email;
    });
  }

  Future<void> _saveEmailSharedPreferences(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
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
        // Pastikan responseData berupa objek JSON yang sesuai dengan struktur User
        return User.fromJson(responseData);
      } else {
        print("Failed to get user data: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error getting user data: $error");
      return null;
    }
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
        Navigator.pushNamed(context, '/bottomnav');
      },
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     SizedBox(height: 10),
      //     Text("Data Pengguna:"),
      //     Text("Email: ${user.email}"),
      //     Text("Username: ${user.username}"),
      //     Text("Token: $token"),
      //   ],
      // ),
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
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
                SizedBox(height: 20.0),
                Text(
                  'Selamat datang di E-Badean',
                  style: TextStyle(
                      fontSize: 17.0,
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
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
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
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
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
                SizedBox(height: 20.0),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Color(0xFF1548AD),
                      minimumSize: Size(double.infinity, 0),
                    ),
                  ),
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
                SizedBox(height: 15.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          'Ketentuan Aplikasi E-Badean',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Dengan masuk ke aplikasi E-Badean, kamu menyetujui segala Syarat dan Ketentuan dan Kebijakan Privasi E-Badean',
                  style: TextStyle(fontSize: 13.0, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun?",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: 'Poppins')),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/daftar');
                      },
                      child: Text(
                        "Daftar di sini",
                        style: TextStyle(
                            color: Color(0xFF1548AD),
                            fontFamily: 'Poppins',
                            fontSize: 14.0),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
