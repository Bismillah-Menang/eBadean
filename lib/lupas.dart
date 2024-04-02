import 'package:e_badean/register/fullname.dart';
import 'package:flutter/material.dart';

class Lupas extends StatefulWidget {
  @override
  LupasPageState createState() => LupasPageState();
}

class LupasPageState extends State<Lupas> {
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
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Masukkan Email',
                  labelStyle: TextStyle(fontSize: 14.0),
                  prefixIcon: Icon(Icons.mail),
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
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Fullname()),
                  );
                },
                child: Text(
                  "Send",
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
            SizedBox(height: 402.0),
            Divider(),
          ],
        ),
      ),
    );
  }
}
