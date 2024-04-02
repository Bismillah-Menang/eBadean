import 'package:flutter/material.dart';

class Berita extends StatelessWidget {
  const Berita({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "You are on the news page",
          style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}