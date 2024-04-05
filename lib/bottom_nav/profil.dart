import 'package:e_badean/login.dart';
import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  const Profil({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 50.0,
            horizontal: 25.0,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Profil Saya",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40.0),
                  CircleAvatar(
                    radius: 75.0,
                    backgroundImage: NetworkImage(
                        'https://miro.medium.com/v2/resize:fit:786/format:webp/1*DLJ3UGHPWDtrzfcMTYjfZw.jpeg'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0),
            Divider(),
            SizedBox(height: 10.0),
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: Color(0xFFEEEDF3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Nama Lengkap',
                  hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                      fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 13.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: Color(0xFFEEEDF3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                      fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 13.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: Color(0xFFEEEDF3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                      fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 13.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: Color(0xFFEEEDF3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'No. Hp',
                  hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                      fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 13.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text(
                      "Pengajuan",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Color(0xFF1DD8A3),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Color(0xFFF91414),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
