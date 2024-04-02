import 'package:e_badean/register/username.dart';
import 'package:flutter/material.dart';

class Fullname extends StatefulWidget {
  @override
  FullnamePageState createState() => FullnamePageState();
}

class FullnamePageState extends State<Fullname> {
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
              'Siapa Nama Lengkap Anda ?',
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
                  labelText: 'Masukkan Nama Lengkap',
                  labelStyle: TextStyle(fontSize: 14.0),
                  prefixIcon: Icon(Icons.person_2_outlined),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Username()),
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
            SizedBox(height: 473.0),
            Divider(),
          ],
        ),
      ),
    );
  }
}
