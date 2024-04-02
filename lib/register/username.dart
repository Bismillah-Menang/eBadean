import 'package:e_badean/register/email.dart';
import 'package:flutter/material.dart';

class Username extends StatefulWidget {
  @override
  UsernamePageState createState() => UsernamePageState();
}

class UsernamePageState extends State<Username> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Nama pengguna apa yang anda ingin gunakan ?',
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
                textAlignVertical: TextAlignVertical.center,
                obscureText: true,
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
                    fontFamily: 'Poppins'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Email()),
                  );
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Color(0xFF1548AD),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
            ),
            SizedBox(height: 397.0),
            Divider(),
          ],
        ),
      ),
    );
  }
}
