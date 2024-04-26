import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav/bottom_nav.dart';
import 'register/fullname.dart';
import 'lupas.dart';

class Login extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  bool _isPasswordVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double emailTextFieldHeight = 50.0;
  double passwordTextFieldHeight = 50.0;

  Future<void> _login() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Validasi jika email atau password kosong
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Gagal"),
          content: Text("Harap isikan email dan password"),
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
      return;
    }

    // Validasi email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Gagal"),
          content: Text("Harap masukkan email yang valid"),
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
      return;
    }

    // Validasi password
    if (password.length < 6 || password.length > 8) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Gagal"),
          content: Text("Password harus terdiri dari 6-8 karakter"),
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
      return;
    }

    // Lanjutkan dengan proses login jika semua validasi terpenuhi
    String url = "http://127.0.0.1:8000/api/login";

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
        String token = responseData['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Notifikasi"),
            content: Text("Anda berhasil login."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        if (response.statusCode == 401) {
          if (responseData['status'] == false) {
            if (responseData['message'] == "validation error") {
              if (responseData['errors'] != null) {
                if (responseData['errors']['email'] != null) {
                  _showErrorDialog(responseData['errors']['email'][0]);
                }
                if (responseData['errors']['password'] != null) {
                  _showErrorDialog(responseData['errors']['password'][0]);
                }
              }
            } else if (responseData['message'] ==
                "Email & Password does not match with our record.") {
              _showErrorDialog("Email dan password tidak sesuai!");
            }
          }
        } else {
          print("HTTP Error ${response.statusCode}: ${response.reasonPhrase}");
        }
      }
    } catch (error) {
      print("Error: $error");
      _showErrorDialog("Terjadi kesalahan. Silakan coba lagi.");
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 105.0),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Lupas()),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Fullname()),
                      );
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
