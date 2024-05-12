import 'package:e_badean/ip.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Import package awesome_dialog

class Lupas extends StatefulWidget {
  @override
  LupasPageState createState() => LupasPageState();
}

class LupasPageState extends State<Lupas> {
  TextEditingController emailController =
      TextEditingController(); // controller untuk menyimpan alamat email yang dimasukkan
  TextEditingController otpController =
      TextEditingController(); // controller untuk menyimpan OTP yang dimasukkan
  TextEditingController passwordController =
      TextEditingController(); // controller untuk menyimpan password baru
  String generatedOTP = '';

  bool emailSent = false;
  bool otpVerified = false;

  String generateOTP() {
    int length = 6;
    String characters = '0123456789';
    String otp = '';

    for (int i = 0; i < length; i++) {
      otp += characters[Random().nextInt(characters.length)];
    }

    return otp;
  }

  void sendVerificationEmail(
      String recipientEmail, String verificationCode) async {
    final smtpServer = gmail('badeanassistance@gmail.com', 'kkvtonebvbewrysk');

    final message = Message()
      ..from = Address('badeanassistance@gmail.com', 'Badean Assistance')
      ..recipients.add(recipientEmail)
      ..subject = 'Verification Code for Your App'
      ..text = 'Your verification code is: $verificationCode';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      setState(() {
        generatedOTP = verificationCode; // Simpan nilai OTP yang dihasilkan
      });
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  Future<void> updatePassword(String email, String password) async {
    String url = "${ApiConfig.baseUrl}/api/gantipassword";

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print('Password updated successfully');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Notifikasi"),
            content: Text("Password berhasil diperbarui"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Failed to update password');
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }

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
              'Lupa Password ?',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Kami disini untuk membantu! Masukkan email yang anda gunakan saat pendaftaran agar kami dapat memasukkan anda kembali ke akun anda',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF6A6A6B),
                    fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(
              height: 50.0,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Masukkan Email',
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
              ),
            ),
            if (emailSent && !otpVerified)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      controller: otpController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Kode OTP',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.lock),
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
                        String enteredOTP = otpController.text;
                        String expectedOTP =
                            generatedOTP; // Simpan nilai OTP yang dihasilkan sebelumnya
                        if (enteredOTP == expectedOTP) {
                          setState(() {
                            otpVerified = true;
                          });
                        } else {
                          // Tampilkan pesan kesalahan atau umpan balik lainnya
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.topSlide,
                            title: 'Pemberitahuan',
                            titleTextStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            desc:
                                'Kode OTP yang dimasukkan tidak valid. Silakan coba lagi.',
                            descTextStyle: TextStyle(fontFamily: 'Poppins'),
                            btnCancelOnPress: () {},
                            btnOkColor: Colors.red,
                          )..show();
                        }
                      },
                      child: Text(
                        "Verifikasi",
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
                ],
              ),
            if (otpVerified)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      controller: passwordController,
                      textAlignVertical: TextAlignVertical.center,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Password Baru',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.lock),
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
                        updatePassword(
                            emailController.text, passwordController.text);
                      },
                      child: Text(
                        "Ubah Password",
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
                ],
              ),
            SizedBox(height: 20.0),
            if (!otpVerified)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      emailSent = true;
                    });
                    String recipientEmail = emailController
                        .text; // Mengambil alamat email dari controller
                    sendVerificationEmail(recipientEmail,
                        generateOTP()); // Menggunakan alamat email yang diambil
                  },
                  child: Text(
                    emailSent ? "Kirim Ulang OTP" : "Kirim OTP",
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
          ],
        ),
      ),
    );
  }
}
