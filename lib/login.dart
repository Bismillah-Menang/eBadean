import 'package:e_badean/bottom_nav/bottom_nav.dart';
import 'package:e_badean/lupas.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 105.0),
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
                      decoration: InputDecoration(
                        labelText: 'Username',
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
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 14.0),
                        prefixIcon: Icon(Icons.key),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {},
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavBar()),
                    );
                  },
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
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Belum punya akun? Daftar disini',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF1548AD),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}