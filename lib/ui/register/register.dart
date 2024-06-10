import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_badean/ui/login/login.dart';
import 'package:e_badean/ui/register/emailverifikasi.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();

  bool _passwordVisible = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _autovalidateMode = AutovalidateMode.disabled;
    });

    String email = emailController.text;
    String password = passwordController.text;
    String role = 'penduduk';
    String verificationCode = _generateOTP();

    if (email.isEmpty ||
        password.isEmpty ||
        role.isEmpty ||
        verificationCode.isEmpty) {
      _showAlertDialog('Notification', 'Please fill in all fields');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('registeredEmail', email);

    _sendVerificationEmail(email, password, role, verificationCode);

    _navigateToEmailVerification(email, password, role, verificationCode);
  }

  void _sendVerificationEmail(String email, String password, String role,
      String verificationCode) async {
    final smtpServer = gmail('badeanassistance@gmail.com', 'kkvtonebvbewrysk');

    final message = Message()
      ..from = Address('badeanassistance@gmail.com', 'Badean Assistance')
      ..recipients.add(email)
      ..subject = 'Kode OTP untuk aplikasi E-Badean'
      ..text =
          '$verificationCode adalah kode verifikasi Anda. Demi keamanan, jangan bagikan kode ini.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode OTP berhasil dikirim ke email Anda'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  String _generateOTP() {
    Random random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  void _showAlertDialog(String title, String message) {
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

  void _navigateToEmailVerification(
      String email, String password, String role, String verificationCode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailVerification(
          email: email,
          password: password,
          role: role,
          verificationCode: verificationCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Akun',
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        bottom: null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Jika Anda belum memiliki akun, Anda dapat mendaftar dengan akun baru',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 14.0),
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
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
                      return 'Email cannot be empty';
                    }
                    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!regex.hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 14.0),
                    prefixIcon: Icon(Icons.key),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFF1548AD),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: 
                    _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1548AD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                    ),
                    SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: Text(
                        'Login disini',
                        style: TextStyle(
                          color: Color(0xFF1548AD),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
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
