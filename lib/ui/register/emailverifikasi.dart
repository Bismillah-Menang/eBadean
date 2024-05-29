import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:e_badean/ip.dart';

class EmailVerification extends StatefulWidget {
  final String email;
  final String verificationCode;
  final String password; // Added password parameter
  final String role; // Added role parameter

  EmailVerification({
    required this.email,
    required this.verificationCode,
    required this.password,
    required this.role,
  });

  @override
  EmailVerificationState createState() => EmailVerificationState();
}

class EmailVerificationState extends State<EmailVerification> {
  TextEditingController otpController = TextEditingController();
  String generatedOTP = '';

  void sendVerificationEmail() async {
    // Your email sending logic here
  }

  // Function to save user data to the database
  void saveUserToDatabase() async {
    try {
      // Prepare data to be sent
      Map<String, String> userData = {
        'email': widget.email,
        'password': widget.password,
        'role': widget.role,
      };

      // Perform HTTP POST request to register user
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/register'),
        body: userData,
      );

      // Check the server response
      if (response.statusCode == 201) {
        // User registered successfully
        print('User registered successfully');
         Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Failed to register user
        print('Failed to register user');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred: $e');
    }
  }

  bool otpVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Verifikasi Email',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Kami telah mengirimkan kode verifikasi ke email Anda. Silakan masukkan kode verifikasi untuk melanjutkan proses pendaftaran.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF6A6A6B),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: otpController,
                decoration: InputDecoration(
                  labelText: 'Masukkan Kode Verifikasi',
                  labelStyle: TextStyle(fontSize: 14.0),
                  prefixIcon: Icon(Icons.lock),
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
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String enteredOTP = otpController.text;
                  String expectedOTP = widget.verificationCode;
                  if (enteredOTP == expectedOTP) {
                    setState(() {
                      otpVerified = true;
                    });
                    // Call the function to save user data to the database
                    saveUserToDatabase();
                  } else {
                    // Handle incorrect OTP scenario
                  }
                },
                child: Text(
                  "Verifikasi",
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
