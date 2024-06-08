import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 

class DetailBerita extends StatelessWidget {
  final String judul;
  final String tgl;
  final String isi;
  final String sumber;
  final Uint8List foto;

  DetailBerita({
    required this.judul,
    required this.tgl,
    required this.isi,
    required this.sumber,
    required this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 75.0,
            left: 25.0,
            right: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.0),
              Text(
                judul,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tgl,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Image.memory(foto),
              ),
              SizedBox(height: 15.0),
              Text(
                isi,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                ),
              ),
              Text(
                'Baca Selengkapnya :',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  launch(sumber); 
                },
                child: Text(
                  sumber,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15.0,
                    color: Color(0xFF1548AD),
                    decoration: TextDecoration.underline,
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
