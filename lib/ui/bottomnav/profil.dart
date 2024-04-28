import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  const Profil({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/profile.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 25.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
