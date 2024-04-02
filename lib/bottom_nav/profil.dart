import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  const Profil({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "You are on the profil page",
          style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
