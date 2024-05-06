import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_badean/ip.dart';
import 'email.dart';

class Username extends StatefulWidget {
  final String nama_lengkap;
  Username({required this.nama_lengkap});

  @override
  UsernamePageState createState() => UsernamePageState();
}

class UsernamePageState extends State<Username> {
  TextEditingController usernameController = TextEditingController();

  Future<void> _register(
      BuildContext context, String nama_lengkap, String username) async {
    String url = "${ApiConfig.baseUrl}/api/register";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'fullname': nama_lengkap,
          'username': username,
        },
      );

      print("Response: ${response.body}");

      final responseData = json.decode(response.body);

      if (responseData['errors'] != null &&
          responseData['errors']['username'] != null &&
          responseData['errors']['username'][0] ==
              "The username has already been taken.") {
        _showErrorDialog(context, "Username sudah terpakai.");
      } else if (responseData['status'] == false &&
          responseData['message'] == "Validation error" &&
          responseData['errors'] != null &&
          responseData['errors']['username'] == null) {
        _navigateToEmailPage(context, nama_lengkap, username);
      } else {
        // Handle other cases if needed
      }
    } catch (error) {
      print("Error: $error");
      _showErrorDialog(context, "Terjadi kesalahan. Silakan coba lagi.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pesan kesalahan"),
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

  void _navigateToEmailPage(
      BuildContext context, String nama_lengkap, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Email(
          nama_lengkap: nama_lengkap,
          username: username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Nama pengguna apa yang anda ingin gunakan ?',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 15.0),
            SizedBox(
              height: 50.0,
              child: TextFormField(
                controller: usernameController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  labelText: 'Masukkan Username',
                  labelStyle: TextStyle(fontSize: 14.0),
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
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Minimal 6 karakter dan terdiri dari huruf (a-z), angka (0-9), titik (.), dan atau garis bawah (_).',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF6A6A6B),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (usernameController.text.isNotEmpty) {
                    _register(
                        context, widget.nama_lengkap, usernameController.text);
                  } else {
                    _showErrorDialog(context, "Harap masukkan username anda!");
                  }
                },
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
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
          ],
        ),
      ),
    );
  }
}
