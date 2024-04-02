import 'package:flutter/material.dart';

class Riwayat extends StatelessWidget {
  const Riwayat({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "You are on the history page",
          style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
