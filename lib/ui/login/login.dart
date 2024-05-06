import 'dart:convert';
import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_badean/ip.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  bool _isPasswordVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Validasi email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showErrorDialog("Harap masukkan email yang valid");
      return;
    }

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
          _showSuccessDialog("Anda berhasil login.", loggedInUser, responseData['token']);
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Login Gagal"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message, User user, String token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notifikasi"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            SizedBox(height: 10),
            Text("Data Pengguna:"),
            Text("Email: ${user.email}"),
            Text("Username: ${user.username}"),
            Text("Token: $token"),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/bottomnav');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 105.0),
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10.0),
              Text(
                'Nikmati akses pelayanan surat dalam satu genggaman :)',
                style: TextStyle(fontSize: 12.0, fontFamily: 'Poppins'),
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      cursorColor: Color(0xFF1548AD),
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 13.0),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      controller: passwordController,
                      cursorColor: Color(0xFF1548AD),
                      textAlignVertical: TextAlignVertical.center,
                      obscureText: _isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 13.0),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFF1548AD),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    "Login",
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
                          fontSize: 12.0,
                          color: Color(0xFF1548AD),
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
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
                        'atau',
                        style: TextStyle(
                          fontSize: 12.0,
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
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/images/google.png',
                    width: 24,
                    height: 24,
                  ),
                  label: Text(
                    'Masuk dengan Google',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: Colors.black),
                    minimumSize: Size(double.infinity, 0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Dengan masuk ke aplikasi E-Badean, kamu menyetujui segala Syarat dan Ketentuan dan Kebijakan Privasi E-Badean',
                style: TextStyle(fontSize: 10.0, fontFamily: 'Poppins'),
              ),
              SizedBox(height: 70.0),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun?",
                      style: TextStyle(
                          fontSize: 12,
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
                          fontSize: 12),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
