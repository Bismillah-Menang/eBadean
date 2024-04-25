import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_badean/register/password.dart';
import 'package:flutter/material.dart';

class Email extends StatefulWidget {
  final String fullname;
  final String username;
  Email({required this.fullname, required this.username});

  @override
  EmailPageState createState() => EmailPageState();
}

class EmailPageState extends State<Email> {
  TextEditingController emailController = TextEditingController();

  Future<void> _register(BuildContext context, String fullname, String username, String email) async {
    String url = "http://127.0.0.1:8000/api/register";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'fullname': fullname,
          'username': username,
          'email': email,
        },
      );

      print("Response: ${response.body}");

      final responseData = json.decode(response.body);

      if (responseData['errors'] != null && responseData['errors']['email'] != null &&
          responseData['errors']['email'][0] == "The email has already been taken.") {
        _showErrorDialog(context, "Email sudah terpakai.");
      } else if (responseData['status'] == false &&
          responseData['message'] == "Validation error" &&
          responseData['errors'] != null &&
          responseData['errors']['email'] == null) {
        _navigateToPasswordPage(context, fullname, username, email);
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

  void _navigateToPasswordPage(BuildContext context, String fullname, String username, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Password(
          fullname: fullname,
          username: username,
          email: email,
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
              'Email Anda ?',
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
                controller: emailController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  labelText: 'Masukkan Email',
                  labelStyle: TextStyle(fontSize: 14.0),
                  prefixIcon: Icon(Icons.mail),
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    _register(context, widget.fullname, widget.username, emailController.text);
                  } else {
                    _showErrorDialog(context, "Harap masukkan email anda!");
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
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF1548AD),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
            ),
            SizedBox(height: 473.0),
            Divider(),
          ],
        ),
      ),
    );
  }
}
