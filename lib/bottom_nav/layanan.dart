import 'package:flutter/material.dart';

class Layanan extends StatelessWidget {
  const Layanan({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "You are on the service page",
          style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
