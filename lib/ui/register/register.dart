import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:e_badean/ui/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:e_badean/ip.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  @override
  RegisterPage createState() => RegisterPage();
}

class RegisterPage extends State<Register> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  String selectedGender = '';

  Future<void> _registerUser(BuildContext context) async {
    String fullname = fullnameController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPassController.text;
    String phoneNumber = phoneController.text;
    String address = alamatController.text;
    String gender = selectedGender;

    // Lakukan validasi form
    if (fullname.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty ||
        gender.isEmpty) {
      _showAlertDialog(context, 'Pemberitahuan', 'Tolong isi semua kolom');
      return;
    }

    // Validasi email
    bool isEmailValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    ).hasMatch(email);
    if (!isEmailValid) {
      _showNotification(context); // Panggil notifikasi
      return;
    }

    // Validasi nomor handphone
    if (!isNumeric(phoneNumber)) {
      _showAlertDialog(context, 'Pemberitahuan', 'no harus berisi angka');
      return;
    }

    // Lakukan validasi password
    if (password != confirmPassword) {
      _showAlertDialog(
          context, 'Pemberitahuan', 'Password dan Confirm Password harus sama');
      return;
    }

    // Lakukan registrasi
    String url = "${ApiConfig.baseUrl}/api/register";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'nama_lengkap': fullname,
          'username': username,
          'email': email,
          'password': password,
          'phone': phoneNumber,
          'alamat': address,
          'jenid_kelamin': gender,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> result = jsonDecode(response.body);
        _showRegisteredUserDialog(context, result['user']);
        _showRegisteredUserDialog(context, result);
        _clearFields();

        // Navigasi ke halaman login setelah registrasi berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        throw Exception('Failed to register user');
      }
    } catch (error) {
      print('Network error: $error');
      _showAlertDialog(context, 'Error', 'Failed to register user: $error');
    }
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void _showNotification(BuildContext context) {
    ScaffoldMessenger.of(context)!.showSnackBar(
      SnackBar(
        content: Text(
          'Tolong masukkan email yang sesuai',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red, // Background color set to red
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRegisteredUserDialog(
      BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Full Name: ${user['fullname']}'),
              Text('Username: ${user['username']}'),
              Text('Email: ${user['email']}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      // Tampilkan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Successful'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearFields() {
    fullnameController.clear();
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPassController.clear();
    phoneController.clear();
    alamatController.clear();
    selectedGender = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Text(
            'Register adalah sebuah tempat yang digunakan untuk register',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            TextFormField(
              controller: fullnameController,
              decoration: InputDecoration(
                labelText: 'Masukkan nama lengkap',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Nama akun',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Password
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Confirm Password
            TextFormField(
              controller: confirmPassController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Nomor Handphone
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Hp',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Gender Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis Kelamin',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = 'Laki-laki';
                        });
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: selectedGender == 'Laki-laki'
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          SizedBox(width: 8),
                          Text('Laki - Laki'),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = 'Perempuan';
                        });
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: selectedGender == 'Perempuan'
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          SizedBox(width: 8),
                          Text('Wanita'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            // Alamat
            TextFormField(
              maxLines: 3,
              controller: alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Tombol Register
            ElevatedButton(
              onPressed: () => _registerUser(context),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(21, 72, 173, 1),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Daftar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            Divider(
              color: Colors.black,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            TextButton(
              onPressed: () {
                // Navigasi kembali ke halaman login.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: 'Sudah punya akun? ',
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Kembali',
                      style: TextStyle(
                          color: const Color.fromRGBO(21, 72, 173, 1)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                    ),
                    TextSpan(
                      text: ' ke halaman login',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ), // Penutup Column
      ), // Penutup SingleChildScrollView
    ); // Penutup Scaffold
  } // Penutup build
} // Penutup RegisterPage
