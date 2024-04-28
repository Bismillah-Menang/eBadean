import 'dart:convert';
import 'package:e_badean/ui/register/sk.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  final String fullname;
  final String username;
  final String email;
  Password({required this.fullname, required this.username, required this.email});

  @override
  PasswordPageState createState() => PasswordPageState();
}

class PasswordPageState extends State<Password> {
  bool _isPasswordVisible = true;
  TextEditingController passController = TextEditingController();

  Future<void> _register(BuildContext context, String fullname, String username, String email, String password) async {
    String url = "http://127.0.0.1:8000/api/register";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'fullname': fullname,
          'username': username,
          'email': email,
          'password': password,
        },
      );

      print("Response: ${response.body}");

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Syarken()),
        );
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
          ),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan. Silakan coba lagi nanti.'),
        ),
      );
    }
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
              'Buat Password',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 15.0),
            SizedBox(
              height: 50.0,
              child: TextFormField(
                controller: passController,
                textAlignVertical: TextAlignVertical.center,
                obscureText: _isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Masukkan Password',
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
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Kata sandi dapat terdiri dari huruf, angka, dan simbol dengan maksimal 8 karakter.',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF6A6A6B),
                    fontFamily: 'Poppins'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _register(context, widget.fullname, widget.username,
                      widget.email, passController.text);
                },
                child: Text(
                  "Next",
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
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF1548AD),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
            ),
            SizedBox(height: 420.0), 
            Divider(),
          ],
        ),
      ),
    );
  }
}
